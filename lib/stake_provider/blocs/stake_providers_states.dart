import 'package:coda_wallet/stake_provider/blocs/stake_provider_type.dart';

abstract class StakeProvidersStates {
  StakeProvidersStates();

  @override
  List<Object>? get props => null;
}

class GetStakeProvidersLoading extends StakeProvidersStates {

  GetStakeProvidersLoading() : super();
}

class GetStakeProvidersFail extends StakeProvidersStates {
  final dynamic data;

  GetStakeProvidersFail(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class GetStakeProvidersSuccess extends StakeProvidersStates {

  GetStakeProvidersSuccess() : super();
}

class SortedProvidersStates extends StakeProvidersStates {
  SortProvidersManner manner;

  SortedProvidersStates(this.manner);
}

class ChosenProviderStates extends StakeProvidersStates {

  ChosenProviderStates();
}

class ProviderSearchStates extends StakeProvidersStates {
  ProviderSearchStates();
}