abstract class StakeCenterStates {}

class GetStakeStatusLoading extends StakeCenterStates {
  GetStakeStatusLoading();
}

class GetStakeStatusFailed extends StakeCenterStates {
  final String error;

  GetStakeStatusFailed(this.error);
}

class GetStakeStatusSuccess extends StakeCenterStates {
  GetStakeStatusSuccess();
}

class TimerEnded extends StakeCenterStates {}