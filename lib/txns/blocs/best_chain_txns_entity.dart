/// data : {"bestChain":[{"transactions":{"userCommands":[{"hash":"CkpYuAX9yNChJmdcBUXu833a2LS67LqQ2eCHDvMdbAmb2Gee2UCGZ","kind":"PAYMENT","amount":"1000","fee":"10000000","from":"B62qre3erTHfzQckNuibViWQGyyKwZseztqrjPZBv6SQF384Rg6ESAy","isDelegation":false,"memo":"E4YM2vTHhWEg66xpj52JErHUBU4pZ1yageL4TVDDpTTSsv8mK6YaH","to":"B62qjYanmV7y9njVeH5UHkz3GYBm7xKir1rAnoY4KsEYUGLMiU45FSM","nonce":3336}]},"protocolState":{"blockchainState":{"date":"1616574420000"},"consensusState":{"blockHeight":"2510"}}}]}

class BestChainTxnsEntity {
  DataBean? data;

  static BestChainTxnsEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    BestChainTxnsEntity bestChainTxnsEntityBean = BestChainTxnsEntity();
    bestChainTxnsEntityBean.data = DataBean.fromMap(map['data']);
    return bestChainTxnsEntityBean;
  }

  Map toJson() => {
    "data": data,
  };
}

/// bestChain : [{"transactions":{"userCommands":[{"hash":"CkpYuAX9yNChJmdcBUXu833a2LS67LqQ2eCHDvMdbAmb2Gee2UCGZ","kind":"PAYMENT","amount":"1000","fee":"10000000","from":"B62qre3erTHfzQckNuibViWQGyyKwZseztqrjPZBv6SQF384Rg6ESAy","isDelegation":false,"memo":"E4YM2vTHhWEg66xpj52JErHUBU4pZ1yageL4TVDDpTTSsv8mK6YaH","to":"B62qjYanmV7y9njVeH5UHkz3GYBm7xKir1rAnoY4KsEYUGLMiU45FSM","nonce":3336}]},"protocolState":{"blockchainState":{"date":"1616574420000"},"consensusState":{"blockHeight":"2510"}}}]

class DataBean {
  List<BestChainBean>? bestChain;

  static DataBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    DataBean dataBean = DataBean();
    dataBean.bestChain = []..addAll(
      (map['bestChain'] as List).map((o) => BestChainBean.fromMap(o)!)
    );
    return dataBean;
  }

  Map toJson() => {
    "bestChain": bestChain,
  };
}

/// transactions : {"userCommands":[{"hash":"CkpYuAX9yNChJmdcBUXu833a2LS67LqQ2eCHDvMdbAmb2Gee2UCGZ","kind":"PAYMENT","amount":"1000","fee":"10000000","from":"B62qre3erTHfzQckNuibViWQGyyKwZseztqrjPZBv6SQF384Rg6ESAy","isDelegation":false,"memo":"E4YM2vTHhWEg66xpj52JErHUBU4pZ1yageL4TVDDpTTSsv8mK6YaH","to":"B62qjYanmV7y9njVeH5UHkz3GYBm7xKir1rAnoY4KsEYUGLMiU45FSM","nonce":3336}]}
/// protocolState : {"blockchainState":{"date":"1616574420000"},"consensusState":{"blockHeight":"2510"}}

class BestChainBean {
  TransactionsBean? transactions;
  ProtocolStateBean? protocolState;

  static BestChainBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    BestChainBean bestChainBean = BestChainBean();
    bestChainBean.transactions = TransactionsBean.fromMap(map['transactions']);
    bestChainBean.protocolState = ProtocolStateBean.fromMap(map['protocolState']);
    return bestChainBean;
  }

  Map toJson() => {
    "transactions": transactions,
    "protocolState": protocolState,
  };
}

/// blockchainState : {"date":"1616574420000"}
/// consensusState : {"blockHeight":"2510"}

class ProtocolStateBean {
  BlockchainStateBean? blockchainState;
  ConsensusStateBean? consensusState;

  static ProtocolStateBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    ProtocolStateBean protocolStateBean = ProtocolStateBean();
    protocolStateBean.blockchainState = BlockchainStateBean.fromMap(map['blockchainState']);
    protocolStateBean.consensusState = ConsensusStateBean.fromMap(map['consensusState']);
    return protocolStateBean;
  }

  Map toJson() => {
    "blockchainState": blockchainState,
    "consensusState": consensusState,
  };
}

/// blockHeight : "2510"

class ConsensusStateBean {
  String? blockHeight;

  static ConsensusStateBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    ConsensusStateBean consensusStateBean = ConsensusStateBean();
    consensusStateBean.blockHeight = map['blockHeight'];
    return consensusStateBean;
  }

  Map toJson() => {
    "blockHeight": blockHeight,
  };
}

/// date : "1616574420000"

class BlockchainStateBean {
  String? date;

  static BlockchainStateBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    BlockchainStateBean blockchainStateBean = BlockchainStateBean();
    blockchainStateBean.date = map['date'];
    return blockchainStateBean;
  }

  Map toJson() => {
    "date": date,
  };
}

/// userCommands : [{"hash":"CkpYuAX9yNChJmdcBUXu833a2LS67LqQ2eCHDvMdbAmb2Gee2UCGZ","kind":"PAYMENT","amount":"1000","fee":"10000000","from":"B62qre3erTHfzQckNuibViWQGyyKwZseztqrjPZBv6SQF384Rg6ESAy","isDelegation":false,"memo":"E4YM2vTHhWEg66xpj52JErHUBU4pZ1yageL4TVDDpTTSsv8mK6YaH","to":"B62qjYanmV7y9njVeH5UHkz3GYBm7xKir1rAnoY4KsEYUGLMiU45FSM","nonce":3336}]

class TransactionsBean {
  List<UserCommandsBean>? userCommands;

  static TransactionsBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    TransactionsBean transactionsBean = TransactionsBean();
    transactionsBean.userCommands = []..addAll(
      (map['userCommands'] as List).map((o) => UserCommandsBean.fromMap(o)!)
    );
    return transactionsBean;
  }

  Map toJson() => {
    "userCommands": userCommands,
  };
}

/// hash : "CkpYuAX9yNChJmdcBUXu833a2LS67LqQ2eCHDvMdbAmb2Gee2UCGZ"
/// kind : "PAYMENT"
/// amount : "1000"
/// fee : "10000000"
/// from : "B62qre3erTHfzQckNuibViWQGyyKwZseztqrjPZBv6SQF384Rg6ESAy"
/// isDelegation : false
/// memo : "E4YM2vTHhWEg66xpj52JErHUBU4pZ1yageL4TVDDpTTSsv8mK6YaH"
/// to : "B62qjYanmV7y9njVeH5UHkz3GYBm7xKir1rAnoY4KsEYUGLMiU45FSM"
/// nonce : 3336

class UserCommandsBean {
  String? hash;
  String? kind;
  String? amount;
  String? fee;
  String? from;
  bool? isDelegation;
  String? memo;
  String? to;
  int? nonce;
  dynamic failureReason;

  static UserCommandsBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    UserCommandsBean userCommandsBean = UserCommandsBean();
    userCommandsBean.hash = map['hash'];
    userCommandsBean.kind = map['kind'];
    userCommandsBean.amount = map['amount'];
    userCommandsBean.fee = map['fee'];
    userCommandsBean.from = map['from'];
    userCommandsBean.isDelegation = map['isDelegation'];
    userCommandsBean.memo = map['memo'];
    userCommandsBean.to = map['to'];
    userCommandsBean.nonce = map['nonce'];
    return userCommandsBean;
  }

  Map toJson() => {
    "hash": hash,
    "kind": kind,
    "amount": amount,
    "fee": fee,
    "from": from,
    "isDelegation": isDelegation,
    "memo": memo,
    "to": to,
    "nonce": nonce,
  };
}