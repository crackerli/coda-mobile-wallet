import 'package:coda_wallet/send_token/blocs/send_token_entity.dart';
import 'package:coda_wallet/send_token/blocs/send_token_events.dart';
import 'package:coda_wallet/send_token/blocs/send_token_states.dart';
import 'package:coda_wallet/types/send_token_action_status.dart';
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
  }

  SendTokenEntity get sendTokenEntity => _sendTokenEntity;

  set amount(value) => _sendTokenEntity.amount = value;
  set fee(value) => _sendTokenEntity.fee = value;
  set receiver(value) => _sendTokenEntity.receiver = value;
  set sender(value) => _sendTokenEntity.sender = value;
  set memo(value) => _sendTokenEntity.memo = value;

  @override
  Stream<SendTokenStates>
    mapEventToState(SendTokenEvents event) async* {
    if(event is SendPayment) {
      yield* _mapSendPaymentToStates(event);
      return;
    }
  }

  Stream<SendTokenStates>
    _mapSendPaymentToStates(SendPayment event) async* {

    final mutation = event.mutation;
    final variables = event.variables ?? null;

    try {
      _sendTokenEntity.sendTokenActionStatus = SendTokenActionStatus.tokenSending;
      yield SendPaymentLoading(_sendTokenEntity);
      final result = await _service.performMutation(mutation, variables: variables);

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
}
