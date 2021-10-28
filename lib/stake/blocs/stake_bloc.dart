import 'package:bloc/bloc.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/coda_service.dart';
import 'package:coda_wallet/stake/blocs/stake_events.dart';
import 'package:coda_wallet/stake/blocs/stake_states.dart';
import 'package:coda_wallet/util/safe_map.dart';

class StakeBloc extends Bloc<StakeEvents, StakeStates> {

  late CodaService _codaService;

  StakeBloc(StakeStates state) : super(state) {
    _codaService = CodaService();
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
      final result = await _codaService.performQuery(query, variables: variables ?? {});

      if(null == result) {
        String error = 'Unknown Error!';
        yield GetConsensusStateFailed(error);
        return;
      }

      if(result.hasException) {
        String error = exceptionHandle(result);
        yield GetConsensusStateFailed(error);
        return;
      }

      int epoch = 0;
      int slot = 0;

      List<dynamic>? bestChain = result.data!['bestChain'] ?? null;
      if(null != bestChain && bestChain.length > 0) {
        SafeMap safeMap = SafeMap(bestChain[0]);
        epoch = int.tryParse(safeMap['protocolState']['consensusState']['epoch'].value) ?? 0;
        slot = int.tryParse(safeMap['protocolState']['consensusState']['slot'].value) ?? 0;
      } else {
        yield GetConsensusStateFailed('Can not get protocol state!');
      }

      yield GetConsensusStateSuccess(epoch, slot);
    } catch (e) {
      print(e);
      yield GetConsensusStateFailed(e.toString());
    }
  }

}