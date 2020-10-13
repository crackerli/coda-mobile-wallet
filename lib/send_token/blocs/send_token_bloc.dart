import 'package:coda_wallet/send_token/blocs/send_token_events.dart';
import 'package:coda_wallet/send_token/blocs/send_token_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';

class SendTokenBloc extends
  Bloc<SendTokenEvents, SendTokenStates> {

  CodaService _service;
  String _receiver = 'B62qp6h8ZCYn3eP1RnZf8zA3WWktNWjGK1uBy4ZLd1rGBz6qvRFfYEh';
  String _sender = '';
  String _payment;
  String _memo;
  String _fee = "0.1";

  SendTokenBloc(SendTokenStates state) : super(state) {
    _service = CodaService();
  }

  String get payment => _payment;
  set payment(value) => _payment = value;

  String get receiver => _receiver;
  set receiver(value) => _receiver = value;

  String get memo => _memo;
  set memo(value) => _memo = value;

  String get fee => _fee;
  set fee(value) => _fee = value;

  String get sender => _sender;
  set sender(value) => _sender = value;

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
      yield SendPaymentLoading();
      final result = await _service.performMutation(mutation, variables: variables);

      if (result.hasException) {
        print('graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield SendPaymentFail(result.exception.graphqlErrors[0]);
        return;
      }

      yield SendPaymentSuccess(result.data);
    } catch (e) {
      print(e);
      yield SendPaymentFail(e.toString());
    } finally {

    }
  }
}
