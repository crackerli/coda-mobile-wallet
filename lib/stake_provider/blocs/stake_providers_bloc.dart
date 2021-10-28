import 'package:bloc/bloc.dart';
import 'package:coda_wallet/service/indexer_service.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_events.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_states.dart';
import 'package:coda_wallet/util/providers_utils.dart';
import 'package:dio/dio.dart';

class StakeProvidersBloc extends Bloc<StakeProvidersEvents, StakeProvidersStates> {

  late IndexerService _indexerService;

  StakeProvidersBloc(StakeProvidersStates? state) : super(state!) {
    _indexerService = IndexerService();
  }

  StakeProvidersStates get initState => GetStakeProvidersLoading(null);

  @override
  Stream<StakeProvidersStates> mapEventToState(StakeProvidersEvents event) async* {
    if(event is GetStakeProviders) {
      yield* _mapGetStakeProviders(event);
    }
  }

  Stream<StakeProvidersStates>
    _mapGetStakeProviders(GetStakeProviders event) async* {
    yield GetStakeProvidersLoading('Providers Loading...');
    try {
      Response response = await _indexerService.getProviders();

      if (response.statusCode != 200) {
        String? error = response.statusMessage;
        yield GetStakeProvidersFail(error);
        return;
      }

      // Convert provider list to map for quick access.
      ProvidersEntity? providersEntity = ProvidersEntity.fromMap(response.data);
      if (null == providersEntity || null == providersEntity.stakingProviders) {
        yield GetStakeProvidersFail('Server Error');
        return;
      }

      storeProvidersMap(providersEntity.stakingProviders);
      yield GetStakeProvidersSuccess(providersEntity.stakingProviders);
    } catch (e) {
      print('${e.toString()}');
      yield GetStakeProvidersFail('Network Error, Please check and try again!');
    } finally {

    }
  }
}