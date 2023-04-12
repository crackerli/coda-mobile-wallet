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
import '../query/get_consensus_stake_state.dart';
import '../query/get_stake_state.dart';

class StakeCenterBloc extends Bloc<StakeCenterEvents, StakeCenterStates> {

  int _epoch = 0;
  int _slot = 0;
  int _accountIndex = 0;
  bool _accountActive = false;
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

  List<StakeStateEntity> get stakingStates => _stakingStates;
  Staking_providersBean? get stakingProvider => _stakingProvider;
  String? get stakingPoolAddress => _stakingPoolAddress;
  bool get accountActive => _accountActive;

  set accountIndex(int index) => _accountIndex = index;

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
      Map<String, dynamic> variables0 = Map<String, dynamic>();
      variables0['publicKey'] = publicKey;

      clearAllStates();
      final stakingState = await _codaService.performQuery(CONSENSUS_STAKE_STATE_QUERY, variables: variables0);

      if(stakingState.hasException) {
        String error = exceptionHandle(stakingState);
        isStakeLoading = false;
        yield GetStakeStatusFailed(error);
        return;
      }

      print('Get consensus state successfully!');

      List<dynamic>? bestChain = stakingState.data!['bestChain'] ?? null;
      if(null != bestChain && bestChain.length > 0) {
        _epoch = int.tryParse(bestChain[0]?['protocolState']?['consensusState']?['epoch']) ?? 0;
        _slot = int.tryParse(bestChain[0]?['protocolState']?['consensusState']?['slot']) ?? 0;
      } else {
        yield GetStakeStatusFailed('Can not get protocol state!');
        isStakeLoading = false;
        return;
      }

      dynamic accounts = stakingState.data!['accounts'];
      if(null == accounts || (accounts as List).isEmpty) {
        _accountActive = false;
        // This account is not active, no need to get other info
        yield GetStakeStatusSuccess();
        isStakeLoading = false;
        return;
      } else {
        _accountActive = true;
        _stakingPoolAddress = accounts[0]?['delegateAccount']?['publicKey'] ?? null;
        if(!isAccountStaking()) {
          // This account has not been staked, no need to get more info
          isStakeLoading = false;
          yield GetStakeStatusSuccess();
          return;
        }
      }

      Map<String, dynamic> variables1 = Map<String, dynamic>();
      variables1['publicKey'] = publicKey;
      variables1['epoch'] = _epoch;
      final stakeState = await _archiveService.performQuery(STAKE_STATE_QUERY, variables: variables1);
      if(stakeState.hasException) {
        String error = exceptionHandle(stakeState);
        isStakeLoading = false;
        yield GetStakeStatusFailed(error);
        return;
      }

      if(null != stakeState.data) {
        if(null != stakeState.data?['stake']) {
          StakeStateEntity entity = StakeStateEntity();
          double balance = stakeState.data?['stake']['balance'].toDouble();
          entity.stakeAmount = '${balance.toStringAsFixed(3)}';
          entity.poolAddress = stakeState.data?['stake']['delegate'];
          entity.isCurrent = true;
          if(publicKey == entity.poolAddress) {
            print('Ignore self staking on current epoch');
          } else {
            _stakingStates.add(entity);
          }
        }

        if(null != stakeState.data?['nextstake']) {
          StakeStateEntity entity = StakeStateEntity();
          double balance = stakeState.data?['nextstake']['balance'].toDouble();
          entity.stakeAmount = '${balance.toStringAsFixed(3)}';
          entity.poolAddress = stakeState.data?['nextstake']['delegate'];
          entity.isCurrent = false;
          if(publicKey == entity.poolAddress) {
            print('Ignore self staking on next epoch');
          } else {
            _stakingStates.add(entity);
          }
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
            isStakeLoading = false;
            return;
          }

          ProvidersEntity? providersEntity = ProvidersEntity.fromMap(response.data);
          if (null == providersEntity || null == providersEntity.stakingProviders) {
            yield GetStakeStatusFailed('Get pool providers failed!');
            isStakeLoading = false;
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

          // Find last delegated pool provider
          _stakingProvider = providerList?.singleWhere((provider) => provider?.providerAddress == _stakingPoolAddress);
        } catch (e) {
          print('Error happen when get providers: ${e.toString()}');
          yield GetStakeStatusFailed('Get pool providers failed!');
          isStakeLoading = false;
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

        // Find last delegated pool provider
        _stakingProvider = Staking_providersBean.fromMap(providerMap[_stakingPoolAddress]);
      }

      yield GetStakeStatusSuccess();
      isStakeLoading = false;
    } catch (e) {
      print(e);
      yield GetStakeStatusFailed(e.toString());
      isStakeLoading = false;
    }
  }

  bool isAccountStaking() {
    return null != _stakingPoolAddress && _stakingPoolAddress!.isNotEmpty && _stakingPoolAddress != publicKey;
  }

  clearAllStates() {
    _stakingStates.clear();
    _stakingProvider = null;
    _stakingPoolAddress = null;
    _accountActive = false;
  }
}
