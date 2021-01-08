import 'package:coda_wallet/txns/blocs/txns_entity.dart';

// class MergedUserCommand {
// String to;
// String from;
// String amount;
// String fee;
// String memo;
// bool isDelegation;
// String hash;
// int nonce;
// bool isPooled;
// String dateTime;
// String coinbase;
// bool isMinted;
// }

enum TxnType {
  NONE,
  MINTED,
  SEND,
  RECEIVE,
  DELEGATION,
  UNDELEGATION
}

String getTxnActionString(MergedUserCommand command, String publicKey) {
  if(command.isDelegation) {

  } else {
    if(command.from == publicKey) {
      return 'Sent';
    }

    if(command.to == publicKey) {
      return 'Received';
    }
  }

  return 'Unknown';
}