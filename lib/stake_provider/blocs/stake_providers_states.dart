import 'package:coda_wallet/stake_provider/blocs/stake_provider_type.dart';

abstract class StakeProvidersStates {
  StakeProvidersStates();

  @override
  List<Object>? get props => null;
}

class GetStakeProvidersLoading extends StakeProvidersStates {
  final dynamic data;

  GetStakeProvidersLoading(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class GetStakeProvidersFail extends StakeProvidersStates {
  final dynamic data;

  GetStakeProvidersFail(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class GetStakeProvidersSuccess extends StakeProvidersStates {
  final dynamic data;

  GetStakeProvidersSuccess(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class SortedProvidersStates extends StakeProvidersStates {
  SortProvidersManner manner;
  final dynamic data;

  SortedProvidersStates(this.manner, this.data);
}
