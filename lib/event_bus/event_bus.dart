import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class UpdateAccounts {}

abstract class TxnsEventBus {}

class UpdateTxns extends TxnsEventBus {}

class ChooseAccountTxns extends TxnsEventBus {
  final int accountIndex;

  ChooseAccountTxns(this.accountIndex);
}

class FilterTxnsAll extends TxnsEventBus {}

class FilterTxnsSent extends TxnsEventBus {}

class FilterTxnsReceived extends TxnsEventBus {}

class FilterTxnsStaked extends TxnsEventBus {}

class UpdateMyAccounts {}

class SendPasswordInput {
  final String password;

  SendPasswordInput(this.password);
}