import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/types/txn_status_type.dart';

class TxnEntity {
  String from;
  String to;
  String timestamp;
  String amount;
  String fee;
  String memo;
  TxnStatus txnStatus;
  TxnType txnType;

  get total {
    double amountD = double.parse(amount);
    double feeD = double.parse(fee);
    double totalD = feeD + amountD;
    return totalD.toString();
  }

  TxnEntity(this.from, this.to, this.timestamp, this.amount, this.fee, this.memo, this.txnStatus, this.txnType);
}