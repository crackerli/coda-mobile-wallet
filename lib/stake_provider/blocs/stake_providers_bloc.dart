import 'package:bloc/bloc.dart';
import 'package:coda_wallet/service/indexer_service.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_provider_type.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_events.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_states.dart';
import 'package:coda_wallet/util/providers_utils.dart';
import 'package:dio/dio.dart';

class StakeProvidersBloc extends Bloc<StakeProvidersEvents, StakeProvidersStates> {

  final List<String> sortMannerNames = <String>['Default', 'Pool Size/Percent', 'Fee', 'Delegators'];
  final List<SortProvidersManner> sortManners = <SortProvidersManner>[SortProvidersManner.SortByDefault,
    SortProvidersManner.SortByPoolSize, SortProvidersManner.SortByFee, SortProvidersManner.SortByDelegators];

  late bool isProvidersLoading;
  late IndexerService _indexerService;
  SortProvidersManner currentSortManner = SortProvidersManner.SortByDefault;
  List<Staking_providersBean?> _stakingProviders = [];
  Staking_providersBean? _everStake;
  bool dropDownMenuEnabled = false;

  StakeProvidersBloc(StakeProvidersStates? state) : super(state!) {
    _indexerService = IndexerService();
    isProvidersLoading = false;
  }

  StakeProvidersStates get initState => GetStakeProvidersLoading(null);
  List<Staking_providersBean?>? get stakingProviders {
    if(null != _everStake && _stakingProviders.isNotEmpty) {
      return [_everStake, ..._stakingProviders];
    }
    return [];
  }

  @override
  Stream<StakeProvidersStates> mapEventToState(StakeProvidersEvents event) async* {
    if(event is GetStakeProviders) {
      yield* _mapGetStakeProviders(event);
      return;
    }

    if(event is SortProvidersEvents) {
      yield* _mapSortProviders(event);
      return;
    }
  }

  Stream<StakeProvidersStates>
    _mapSortProviders(SortProvidersEvents event) async* {
    currentSortManner = event.manner;
    if(_stakingProviders.isEmpty) {
      print('Staking Providers list is empty!!');
      yield SortedProvidersStates(SortProvidersManner.SortByDefault, <Staking_providersBean?>[]);
      return;
    }

    switch(event.manner) {
      case SortProvidersManner.SortByPoolSize:
        _stakingProviders.sort((element1, element2) {
          double stakedSum1 = element1?.stakedSum ?? 0;
          double stakedSum2 = element2?.stakedSum ?? 0;
          return stakedSum2.compareTo(stakedSum1);
        });
        yield SortedProvidersStates(SortProvidersManner.SortByPoolSize, [_everStake, ..._stakingProviders]);
        break;
      case SortProvidersManner.SortByFee:
        _stakingProviders.sort((element1, element2) {
          double fee1 = element1?.providerFee ?? 0;
          double fee2 = element2?.providerFee ?? 0;
          return fee1.compareTo(fee2);
        });
        yield SortedProvidersStates(SortProvidersManner.SortByFee, [_everStake, ..._stakingProviders]);
        break;
      case SortProvidersManner.SortByDelegators:
        _stakingProviders.sort((element1, element2) {
          num delegators1 = element1?.delegatorsNum ?? 0;
          num delegators2 = element2?.delegatorsNum ?? 0;
          return delegators2.compareTo(delegators1);
        });
        yield SortedProvidersStates(SortProvidersManner.SortByDelegators, [_everStake, ..._stakingProviders]);
        break;
      default:
        _stakingProviders.sort((element1, element2) {
          num providerId1 = element1?.providerId ?? 0;
          num providerId2 = element2?.providerId ?? 0;
          return providerId1.compareTo(providerId2);
        });
        yield SortedProvidersStates(SortProvidersManner.SortByDefault, [_everStake, ..._stakingProviders]);
        break;
    }
  }

  Stream<StakeProvidersStates>
    _mapGetStakeProviders(GetStakeProviders event) async* {
    yield GetStakeProvidersLoading('Providers Loading...');
    isProvidersLoading = true;
    try {
      Response response = await _indexerService.getProviders();

      if (response.statusCode != 200) {
        String? error = response.statusMessage;
        isProvidersLoading = false;
        dropDownMenuEnabled = false;
        yield GetStakeProvidersFail(error);
        return;
      }

      // Convert provider list to map for quick access.
      ProvidersEntity? providersEntity = ProvidersEntity.fromMap(response.data);
      if (null == providersEntity || null == providersEntity.stakingProviders) {
        isProvidersLoading = false;
        dropDownMenuEnabled = false;
        yield GetStakeProvidersFail('Server Error, Please check and try again!');
        return;
      }

      providersEntity.stakingProviders?.removeWhere((element) {
        if(null == element) {
          return true;
        }

        if(null == element.providerAddress || element.providerAddress!.isEmpty) {
          return true;
        }
        return false;
      });
      storeProvidersMap(providersEntity.stakingProviders);
      _stakingProviders = providersEntity.stakingProviders!;
      // Retrieve element of EverStake
      _everStake = _stakingProviders.singleWhere((element) {
        if(element!.providerId == 230
          && element.providerTitle == 'Everstake'
          && element.email == 'inbox@everstake.one') {
          return true;
        }
        return false;
      })!;
      _stakingProviders.removeWhere((element) {
        if (element!.providerId == 230
            && element.providerTitle == 'Everstake'
            && element.email == 'inbox@everstake.one') {
          return true;
        }
        return false;
      });

      isProvidersLoading = false;
      dropDownMenuEnabled = true;
      yield GetStakeProvidersSuccess([_everStake, ..._stakingProviders]);
    } catch (e) {
      print('${e.toString()}');
      isProvidersLoading = false;
      dropDownMenuEnabled = false;
      yield GetStakeProvidersFail('Network Error, Please check and try again!');
    } finally {

    }
  }
}