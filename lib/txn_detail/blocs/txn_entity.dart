import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/types/txn_status_type.dart';

class TxnEntity {
  String from;
  String to;
  String? timestamp;
  String amount;
  String fee;
  String? memo;
  bool isIndexerMemo;
  TxnStatus txnStatus;
  TxnType txnType;

  get total {
    BigInt? amountB = BigInt.tryParse(amount);
    BigInt? feeB = BigInt.tryParse(fee);

    if(null != amountB && null != feeB) {
      BigInt totalB = amountB + feeB;
      return totalB.toString();
    } else {
      return '';
    }
  }

  TxnEntity(this.from, this.to, this.timestamp, this.amount, this.fee, this.memo, this.txnStatus, this.txnType, this.isIndexerMemo);
}