import 'package:coda_wallet/send_token/blocs/send_token_entity.dart';
import 'package:coda_wallet/send_token/blocs/send_token_events.dart';
import 'package:coda_wallet/send_token/blocs/send_token_states.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';

class SendTokenBloc extends
  Bloc<SendTokenEvents, SendTokenStates> {

  CodaService _service;
  SendTokenEntity _sendTokenEntity;

  SendTokenBloc(SendTokenStates state) : super(state) {
    _service = CodaService();
    _sendTokenEntity = SendTokenEntity();
    _sendTokenEntity.fee = '0.1';
    _sendTokenEntity.sendEnabled = false;
    _sendTokenEntity.isSending = false;
  }

  SendTokenEntity get sendTokenEntity => _sendTokenEntity;

  set sendAmount(value)  => _sendTokenEntity.sendAmount  = value;
  set fee(value)         => _sendTokenEntity.fee         = value;
  set receiver(value)    => _sendTokenEntity.receiver    = value;
  set sender(value)      => _sendTokenEntity.sender      = value;
  set memo(value)        => _sendTokenEntity.memo        = value;
  set isLocked(value)    => _sendTokenEntity.isLocked    = value;
  set balance(value)     => _sendTokenEntity.balance     = value;
  set sendEnabled(value) => _sendTokenEntity.sendEnabled = value;
  set isSending(value)   => _sendTokenEntity.isSending   = value;

  String get sendAmount  => _sendTokenEntity.sendAmount;
  String get fee         => _sendTokenEntity.fee;
  String get receiver    => _sendTokenEntity.receiver;
  String get sender      => _sendTokenEntity.sender;
  String get memo        => _sendTokenEntity.memo;
  String get balance     => _sendTokenEntity.balance;
  bool   get isLocked    => _sendTokenEntity.isLocked;
  bool   get sendEnabled => _sendTokenEntity.sendEnabled;
  bool   get isSending   => _sendTokenEntity.isSending;

  bool checkSendContentValid() {
    if(null == _sendTokenEntity.receiver ||
       0 == _sendTokenEntity.receiver.length ||
       null == _sendTokenEntity.sendAmount ||
       0 == _sendTokenEntity.sendAmount.length ||
       null == _sendTokenEntity.fee ||
       0 == _sendTokenEntity.fee.length ||
       isLocked) {
      sendEnabled = false;
      return false;
    }

    if(!checkNumeric(_sendTokenEntity.sendAmount) ||
       !checkNumeric(_sendTokenEntity.fee)) {
      sendEnabled = false;
      return false;
    }

    sendEnabled = true;
    return true;
  }

  @override
  Stream<SendTokenStates>
    mapEventToState(SendTokenEvents event) async* {
    if(event is SendPayment) {
      yield* _mapSendPaymentToStates(event);
      return;
    }

    if(event is ValidateInput) {
      yield* _mapValidateInputToStates(event);
      return;
    }

    if(event is ToggleLockStatus) {
      yield* _mapToggleLockStatusToStates(event);
      return;
    }
  }

  Stream<SendTokenStates>
    _mapValidateInputToStates(ValidateInput event) async* {
    if(checkSendContentValid()) {
      yield InputValidated();
      return;
    }

    yield InputInvalidated();
  }

  Stream<SendTokenStates>
    _mapSendPaymentToStates(SendPayment event) async* {

    final mutation = event.mutation;
    final variables = event.variables ?? null;

    try {
      isSending = true;
      yield SendPaymentLoading(_sendTokenEntity);
      final result = await _service.performMutation(mutation, variables: variables);
      isSending = false;
      if (result.hasException) {
        print('graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield SendPaymentFail(result.exception.graphqlErrors[0]);
        return;
      }

      yield SendPaymentSuccess(_sendTokenEntity);
    } catch (e) {
      print(e);
      yield SendPaymentFail(e.toString());
    } finally {

    }
  }

  Stream<SendTokenStates>
    _mapToggleLockStatusToStates(ToggleLockStatus event) async* {

    final query = event.mutation;
    final variables = event.variables ?? null;

    try {
      yield ToggleLockStatusLoading();
      final result = await _service.performMutation(query, variables: variables);

      if (result.hasException) {
        print('graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield ToggleLockStatusFail(result.exception?.graphqlErrors[0]);
        return;
      }

      _sendTokenEntity.isLocked = !_sendTokenEntity.isLocked;
      checkSendContentValid();
      yield ToggleLockStatusSuccess();
    } catch (e) {
      print(e);
      yield ToggleLockStatusFail(e.toString());
    } finally {

    }
  }

}
