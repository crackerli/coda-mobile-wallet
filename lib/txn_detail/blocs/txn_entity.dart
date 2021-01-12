import 'package:coda_wallet/types/txn_status_type.dart';

class TxnEntity {
  String from;
  String to;
  String timestamp;
  String amount;
  String fee;
  String memo;
  TxnStatusType txnStatusType;

  TxnEntity(this.from, this.to, this.timestamp, this.amount, this.fee, this.memo, this.txnStatusType);
}