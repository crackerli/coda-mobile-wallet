import 'package:coda_wallet/stake_provider/blocs/stake_provider_type.dart';

abstract class StakeProvidersEvents {
  StakeProvidersEvents();

  @override
  List<Object>? get props => null;
}

class GetStakeProviders extends StakeProvidersEvents {

  GetStakeProviders() : super();

  @override
  List<Object> get props => ['GetStakeProviders'];
}

class SortProvidersEvents extends StakeProvidersEvents {
  SortProvidersManner manner;

  SortProvidersEvents(this.manner);
}
