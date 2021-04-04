import 'package:coda_wallet/txns/blocs/pooled_txns_entity.dart';
import 'confirmed_txns_entity.dart';

class TxnsEntity {
  ConfirmedTxnsEntity confirmedTxnsEntity;
  PooledTxnsEntity pooledTxnsEntity;
}

class MergedUserCommand {
  String to;
  String from;
  String amount;
  String fee;
  String memo;
  // If this is indexer memo, then no need to do base58check decode
  bool isIndexerMemo;
  bool isDelegation;
  String hash;
  int nonce;
  bool isPooled;
  String dateTime;
  int blockHeight;
}

