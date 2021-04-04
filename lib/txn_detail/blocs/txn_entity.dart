import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/types/txn_status_type.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';

class TxnEntity {
  String from;
  String to;
  String timestamp;
  String amount;
  String fee;
  String memo;
  bool isIndexerMemo;
  TxnStatus txnStatus;
  TxnType txnType;

  get total {
    BigInt amountB = BigInt.tryParse(amount);
    BigInt feeB = BigInt.tryParse(fee);
    BigInt totalB = amountB + feeB;
    return totalB.toString();
  }

  TxnEntity(this.from, this.to, this.timestamp, this.amount, this.fee, this.memo, this.txnStatus, this.txnType, this.isIndexerMemo);
}