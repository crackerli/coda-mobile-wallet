import 'package:coda_wallet/types/send_token_action_status.dart';

class SendTokenEntity {
  String receiver;
  String sender;
  String memo;
  String amount;
  String fee;
  bool isLocked;
  SendTokenActionStatus sendTokenActionStatus;
}