import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/indexer_service.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_events.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_states.dart';
import 'package:coda_wallet/util/providers_utils.dart';
import 'package:dio/dio.dart';

class StakeProvidersBloc extends Bloc<StakeProvidersEvents, StakeProvidersStates> {

  bool isProvidersLoading;
  IndexerService _indexerService;

  StakeProvidersBloc(StakeProvidersStates state) : super(state) {
    _indexerService = IndexerService();
    isProvidersLoading = false;
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
    isProvidersLoading = true;
    try {
      Response response = await _indexerService.getProviders();

      if (null == response) {
        String error = 'Unknown Error!';
        yield GetStakeProvidersFail(error);
        return;
      }

      if (response.statusCode != 200) {
        String error = response.statusMessage;
        yield GetStakeProvidersFail(error);
        return;
      }

      // Convert provider list to map for quick access.
      ProvidersEntity providersEntity = ProvidersEntity.fromMap(response.data);
      if (null == providersEntity || null == providersEntity.stakingProviders) {
        return;
      }

      storeProvidersMap(providersEntity.stakingProviders);
      yield GetStakeProvidersSuccess(providersEntity.stakingProviders);
      isProvidersLoading = true;
    } catch (e) {
      print('${e.toString()}');
      yield GetStakeProvidersFail('Network Error, Please check and try again!');
    } finally {

    }
  }
}