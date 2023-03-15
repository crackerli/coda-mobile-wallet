import 'package:bloc/bloc.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/coda_service.dart';
import 'package:coda_wallet/stake/blocs/stake_events.dart';
import 'package:coda_wallet/stake/blocs/stake_states.dart';

import '../../constant/constants.dart';

class StakeCenterBloc extends Bloc<StakeEvents, StakeStates> {
  int epoch = 0;
  int slot = 0;

  late CodaService _codaService;
  late bool isStakeLoading;

  StakeCenterBloc(StakeStates state) : super(state) {
    _codaService = CodaService();
    isStakeLoading = false;
  }

  StakeStates get initState => GetConsensusStateLoading(null);

  @override
  Stream<StakeStates> mapEventToState(StakeEvents event) async* {
    if(event is GetConsensusState) {
      yield* _mapGetConsensusStateToStates(event);
    }
  }

  Stream<StakeStates>
    _mapGetConsensusStateToStates(GetConsensusState event) async* {
    final query = event.query;
    final variables = event.variables ?? null;

    try {
      isStakeLoading = true;
      final result = await _codaService.performQuery(query, variables: variables ?? {});

      if(result.hasException) {
        String error = exceptionHandle(result);
        yield GetConsensusStateFailed(error);
        return;
      }

      int epoch = 0;
      int slot = 0;

      List<dynamic>? bestChain = result.data!['bestChain'] ?? null;
      if(null != bestChain && bestChain.length > 0) {
  //      SafeMap safeMap = SafeMap(bestChain[0]);
        epoch = int.tryParse(bestChain[0]?['protocolState']?['consensusState']?['epoch']) ?? 0;
        slot = int.tryParse(bestChain[0]?['protocolState']?['consensusState']?['slot']) ?? 0;
      } else {
        yield GetConsensusStateFailed('Can not get protocol state!');
      }

      yield GetConsensusStateSuccess(epoch, slot);
      isStakeLoading = false;
    } catch (e) {
      print(e);
      yield GetConsensusStateFailed(e.toString());
      isStakeLoading = false;
    }
  }

  _convertSlots2Time(int slot) {
    int remainSlots = SLOT_PER_EPOCH - slot;
    if(remainSlots <= 0) {
      return DateTime.now().millisecondsSinceEpoch + 7140 * 3 * 60 * 1000;
    } else {
      return DateTime.now().millisecondsSinceEpoch + remainSlots * 3 * 60 * 1000;
    }
  }

}