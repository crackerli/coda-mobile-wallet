import 'dart:typed_data';

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

abstract class SendEventBus {}

class SendPasswordInput extends SendEventBus {
  final String password;

  SendPasswordInput(this.password);
}

class SendPaymentAgain extends SendEventBus {}

class GetNonceAgain extends SendEventBus {}

class GetPooledFeeAgain extends SendEventBus {}

class NewAccountPasswordInput {
  final String password;

  NewAccountPasswordInput(this.password);
}

abstract class SettingChangeEventBus {}

class RemoveWalletSucceed extends SettingChangeEventBus {}

class RemoveWalletFail extends SettingChangeEventBus {}

class NetworkChange extends SettingChangeEventBus {}

class ChangePasswordFail extends SettingChangeEventBus {}

class ChangePasswordSucceed extends SettingChangeEventBus {
  Uint8List seed;
  ChangePasswordSucceed(this.seed);
}