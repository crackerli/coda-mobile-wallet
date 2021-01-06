import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/send/blocs/send_events.dart';
import 'package:coda_wallet/send/blocs/send_states.dart';
import 'package:coda_wallet/send/blocs/send_token_events.dart';
import 'package:coda_wallet/send/blocs/send_token_states.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';

class SendBloc extends
  Bloc<SendEvents, SendStates> {

  CodaService _service;

  String to;
  String from;
  String memo;
  String amount;
  String fee;
  int account;
  bool sendEnabled;
  bool loading;

  SendBloc(SendStates state) : super(state) {
    _service = CodaService();
  }

  bool checkFeeValid() {
    if(null == fee || fee.isEmpty) {
      sendEnabled = false;
      return false;
    }

    if(!checkNumeric(fee)) {
      sendEnabled = false;
      return false;
    }

    sendEnabled = true;
    return true;
  }

  @override
  Stream<SendStates>
    mapEventToState(SendEvents event) async* {
    if(event is SendPayment) {
      yield* _mapSendToStates(event);
      return;
    }

    if(event is ValidateInput) {
      yield* _mapFeeValidateToStates(event);
      return;
    }

    if(event is GetNonce) {
      yield* _mapGetNonceToStates(event);
      return;
    }
  }

  Stream<SendStates>
    _mapFeeValidateToStates(FeeValidate event) async* {
    if(checkFeeValid()) {
      yield FeeValidated();
      return;
    }

    yield FeeInvalidated();
  }

  Stream<SendStates>
    _mapSendToStates(Send event) async* {

    final mutation = event.mutation;
    final variables = event.variables ?? null;

    try {
      loading = true;
      yield SendLoading(null);
      final result = await _service.performMutation(mutation, variables: variables);
      loading = false;

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield SendFail(error);
        return;
      }

      yield SendSuccess(null);
    } catch (e) {
      print(e);
      yield SendFail(e.toString());
    } finally {

    }
  }

  Stream<SendStates>
    _mapGetNonceToStates(GetNonce event) async* {
    final mutation = event.query;
    final variables = event.variables ?? null;

    try {
      loading = true;
      yield GetNonceLoading();
      final result = await _service.performMutation(mutation, variables: variables);
      loading = false;

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield GetNonceFail(error);
        return;
      }

      yield GetNonceSuccess();
    } catch (e) {
      print(e);
      yield GetNonceFail(e.toString());
    } finally {

    }
  }

}
