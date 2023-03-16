import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/archive_service.dart';
import 'package:coda_wallet/service/coda_service.dart';
import 'package:coda_wallet/service/common_https_service.dart';
import 'package:coda_wallet/stake/blocs/stake_center_events.dart';
import 'package:coda_wallet/stake/blocs/stake_center_states.dart';
import 'package:coda_wallet/stake/blocs/stake_state_entity.dart';
import 'package:dio/dio.dart';
import '../../constant/constants.dart';
import '../../stake_provider/blocs/stake_providers_entity.dart';
import '../query/get_consensus_state.dart';
import '../query/get_stake_state.dart';

class StakeCenterBloc extends Bloc<StakeCenterEvents, StakeCenterStates> {
  int _epoch = 0;
  int _slot = 0;
  int _accountIndex = 0;
  List<StakeStateEntity> _stakingStates = [];
  Staking_providersBean? _stakingProvider;
  String? _stakingPoolAddress;

  late CodaService _codaService;
  late ArchiveService _archiveService;
  late bool isStakeLoading;

  StakeCenterBloc(StakeCenterStates state) : super(state) {
    _codaService = CodaService();
    _archiveService = ArchiveService();
    isStakeLoading = false;
  }

  int get epoch => _epoch;
  int get accountIndex => _accountIndex;
  int get slot => _slot;
  get publicKey => globalHDAccounts.accounts![accountIndex]!.address;
  get stakingStates => _stakingStates;
  get stakingProvider => _stakingProvider;

  int get counterEndTime {
    int remainSlots = SLOT_PER_EPOCH - _slot;
    DateTime now = DateTime.now();
    if(remainSlots <= 0) {
      return now.millisecondsSinceEpoch + SLOT_PER_EPOCH * 3 * 60 * 1000;
    } else {
      int seconds = now.second;
      int delta = 180 - (seconds % 180);
      return now.millisecondsSinceEpoch + remainSlots * 3 * 60 * 1000 + delta * 1000;
    }
  }

  StakeCenterStates get initState => GetStakeStatusLoading();

  @override
  Stream<StakeCenterStates> mapEventToState(StakeCenterEvents event) async* {
    if(event is GetStakeStatusEvent) {
      yield* _mapGetStakeStatusToStates(event);
    }

    if(event is TimerEndEvent) {
      yield* _mapTimerEndToStates(event);
    }
  }

  Stream<StakeCenterStates>
    _mapTimerEndToStates(TimerEndEvent event) async* {
    _slot = SLOT_PER_EPOCH;
    yield TimerEnded();
  }

  Stream<StakeCenterStates>
    _mapGetStakeStatusToStates(GetStakeStatusEvent event) async* {

    try {
      isStakeLoading = true;
      yield GetStakeStatusLoading();

      final consensusState = await _codaService.performQuery(CONSENSUS_STATE_QUERY, variables: <String, dynamic>{});

      if(consensusState.hasException) {
        String error = exceptionHandle(consensusState);
        yield GetStakeStatusFailed(error);
        return;
      }

      print('Get consensus state successfully!');

      List<dynamic>? bestChain = consensusState.data!['bestChain'] ?? null;
      if(null != bestChain && bestChain.length > 0) {
        _epoch = int.tryParse(bestChain[0]?['protocolState']?['consensusState']?['epoch']) ?? 0;
        _slot = int.tryParse(bestChain[0]?['protocolState']?['consensusState']?['slot']) ?? 0;
      } else {
        yield GetStakeStatusFailed('Can not get protocol state!');
      }

      Map<String, dynamic> variables = Map<String, dynamic>();
      variables['publicKey'] = publicKey;
      variables['epoch'] = _epoch;
      final stakeState = await _archiveService.performQuery(STAKE_STATE_QUERY, variables: variables);
      if(stakeState.hasException) {
        String error = exceptionHandle(stakeState);
        yield GetStakeStatusFailed(error);
        return;
      }

      if(null != stakeState.data) {
        if(null != stakeState.data?['stake']) {
          StakeStateEntity entity = StakeStateEntity();
          double balance = stakeState.data?['stake']['balance'] as double;
          entity.stakeAmount = '${balance.toStringAsFixed(3)}';
          entity.poolAddress = stakeState.data?['stake']['delegate'];
          _stakingStates.add(entity);
        }

        if(null != stakeState.data?['nextstake']) {
          StakeStateEntity entity = StakeStateEntity();
          double balance = stakeState.data?['nextstake']['balance'] as double;
          entity.stakeAmount = '${balance.toStringAsFixed(3)}';
          entity.poolAddress = stakeState.data?['nextstake']['delegate'];
          _stakingStates.add(entity);
        }
      }

      String? providerString = globalPreferences.getString(STAKETAB_PROVIDER_KEY);
      Map<String, dynamic> providerMap;
      try {
        providerMap = json.decode(providerString ?? '');
      } catch(e) {
        providerMap = Map<String, dynamic>();
      }

      if(providerMap.isEmpty) { // Get provider list again
        IndexerService service = IndexerService();
        try {
          Response response = await service.getProviders();

          if (response.statusCode != 200) {
            yield GetStakeStatusFailed('Get pool providers failed!');
            return;
          }

          ProvidersEntity? providersEntity = ProvidersEntity.fromMap(response.data);
          if (null == providersEntity || null == providersEntity.stakingProviders) {
            yield GetStakeStatusFailed('Get pool providers failed!');
            return;
          }

          List<Staking_providersBean?>? providerList = providersEntity.stakingProviders;
          _stakingStates.forEach((state) {
            Staking_providersBean? foundProvider =
              providerList?.singleWhere((provider) => provider?.providerAddress == state.poolAddress);
            if(null != foundProvider) {
              state.fee = (null == foundProvider.providerFee) ? 'Unknown' : '${foundProvider.providerFee}%';
              state.idealApy = (null == foundProvider.providerFee) ? 'Unknown' :
                '${INFLATION_RATE - foundProvider.providerFee! * INFLATION_RATE * 0.01}%';
              state.providerName = foundProvider.providerTitle ?? 'Unknown';
            } else {
              state.fee = 'Unknown';
              state.idealApy = 'Unknown';
              state.providerName = 'Unknown';
            }
          });
        } catch (e) {
          print('Error happen when get providers: ${e.toString()}');
          yield GetStakeStatusFailed('Get pool providers failed!');
          return;
        } finally {}
      } else {
        _stakingStates.forEach((state) {
          Staking_providersBean? foundProvider = Staking_providersBean.fromMap(providerMap[state.poolAddress]);
          if(null != foundProvider) {
            state.fee = (null == foundProvider.providerFee) ? 'Unknown' : '${foundProvider.providerFee}%';
            state.idealApy = (null == foundProvider.providerFee) ? 'Unknown' :
            '${INFLATION_RATE - foundProvider.providerFee! * INFLATION_RATE * 0.01}%';
            state.providerName = foundProvider.providerTitle ?? 'Unknown';
          } else {
            state.fee = 'Unknown';
            state.idealApy = 'Unknown';
            state.providerName = 'Unknown';
          }
        });
      }

      yield GetStakeStatusSuccess();
      isStakeLoading = false;
    } catch (e) {
      print(e);
      yield GetStakeStatusFailed(e.toString());
      isStakeLoading = false;
    }
  }
}
