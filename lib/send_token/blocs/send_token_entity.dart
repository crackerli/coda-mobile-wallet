import 'package:coda_wallet/types/send_token_action_status.dart';

class SendTokenEntity {
  String receiver;
  String sender;
  String memo;
  String sendAmount;
  String fee;
  String balance;
  bool isLocked;
  bool sendEnabled;
  SendTokenActionStatus sendTokenActionStatus;
}