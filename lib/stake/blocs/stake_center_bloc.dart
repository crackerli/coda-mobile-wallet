import 'package:bloc/bloc.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/coda_service.dart';
import 'package:coda_wallet/stake/blocs/stake_center_events.dart';
import 'package:coda_wallet/stake/blocs/stake_center_states.dart';
import '../../constant/constants.dart';
import '../query/get_consensus_state.dart';

class StakeCenterBloc extends Bloc<StakeCenterEvents, StakeCenterStates> {
  int _epoch = 0;
  int _slot = 0;
  int _accountIndex = 0;

  late CodaService _codaService;
  late bool isStakeLoading;

  StakeCenterBloc(StakeCenterStates state) : super(state) {
    _codaService = CodaService();
    isStakeLoading = false;
  }

  int get epoch => _epoch;
  int get accountIndex => _accountIndex;
  int get slot => _slot;
  int get counterEndTime {
    int remainSlots = SLOT_PER_EPOCH - slot;
    DateTime now = DateTime.now();
    if(remainSlots <= 0) {
      return now.millisecondsSinceEpoch + 7140 * 3 * 60 * 1000;
    } else {
      int seconds = now.second;
      int delta = 180 - (seconds % 180);
      print('adfadsfdsfdf: delta = $delta');
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
    yield TimerEnded();
  }

  Stream<StakeCenterStates>
    _mapGetStakeStatusToStates(GetStakeStatusEvent event) async* {
    final query = CONSENSUS_STATE_QUERY;
    final variables = <String, dynamic>{};

    try {
      isStakeLoading = true;
      yield GetStakeStatusLoading();

      final result = await _codaService.performQuery(query, variables: variables);

      if(result.hasException) {
        String error = exceptionHandle(result);
        yield GetStakeStatusFailed(error);
        return;
      }

      print('Get consensus state successfully!');

      List<dynamic>? bestChain = result.data!['bestChain'] ?? null;
      if(null != bestChain && bestChain.length > 0) {
        _epoch = int.tryParse(bestChain[0]?['protocolState']?['consensusState']?['epoch']) ?? 0;
        _slot = int.tryParse(bestChain[0]?['protocolState']?['consensusState']?['slot']) ?? 0;
      } else {
        yield GetStakeStatusFailed('Can not get protocol state!');
      }

      yield GetStakeStatusSuccess();
      isStakeLoading = false;
    } catch (e) {
      print(e);
      yield GetStakeStatusFailed(e.toString());
      isStakeLoading = false;
    }
  }

  _convertSlots2Time(int slot) {
    int remainSlots = SLOT_PER_EPOCH - slot;
    if(remainSlots <= 0) {
      return DateTime.now().millisecondsSinceEpoch + 7140 * 3 * 60 * 1000;
    } else {
      int now = DateTime.now().second;
      int delta = 180 - (now % 180);
      print('adfadsfdsfdf: delta = $delta');
      return DateTime.now().millisecondsSinceEpoch + remainSlots * 3 * 60 * 1000 + delta * 1000;
    }
  }

}