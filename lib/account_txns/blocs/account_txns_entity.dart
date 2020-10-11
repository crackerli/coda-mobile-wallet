class AccountTxnsEntity {
  AccountTxnsData data;
}

class AccountTxnsData {
  Blocks blocks;
  List<PooledUserCommand> pooledUserCommands;
}

class Blocks {
  List<Node> nodes;
  PageInfo pageInfo;
  int totalCount;
}

class Node {
  ProtocolState protocolState;
  Transactions transactions;
}

class ProtocolState {
  BlockchainState blockchainState;
}

class BlockchainState {
  String date;
}

class Transactions {
  List<UserCommand> userCommands;
  String coinbase;
  CoinbaseReceiverAccount coinbaseReceiverAccount;
  List<FeeTransfer> feeTransfer;
}

class CoinbaseReceiverAccount {
  String publicKey;
}

class FeeTransfer {
  String recipient;
  String fee;
}

class PageInfo {
  bool hasNextPage;
  String lastCursor;
}

class UserCommand {
  String to;
  String from;
  String amount;
  String fee;
  String memo;
  bool isDelegation;
  String hash;
  int nonce;
}

class PooledUserCommand {
  String to;
  String from;
  String amount;
  String fee;
  String memo;
  bool isDelegation;
  String hash;
  int nonce;
}

class MergedUserCommand {
  String to;
  String from;
  String amount;
  String fee;
  String memo;
  bool isDelegation;
  String hash;
  int nonce;
  bool isPooled;
  String dateTime;
  String coinbase;
  bool isMinted;
}
