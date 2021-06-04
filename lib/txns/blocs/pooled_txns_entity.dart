/// pooledUserCommands : [{"fee":"666010000000","amount":"350888000000","from":"B62qrGaXh9wekfwaA2yzUbhbvFYynkmBkhYLV36dvy5AkRvgeQnY6vx","to":"B62qnpUj6EJGNvhJFMEAmM6skJRg1H37hVsHvPHMXhHeCXfKhSWGkGN","hash":"CkpZPEy2gRHHX5QSQCWmCW1m8rPAotYd62Uykv4DXBxjfF5aQYVCU","isDelegation":false,"memo":"E4Ys2HUNyS6xwMKtP3vLhcstVG4342tajxrm53s2vJ7LuqS2UN6wi","nonce":10,"token":"1","id":"2G7L3ExMa4onsf1r561aByac95f871xyKdgjL2FiTmwsrd7jWRDe5Tn8S3xBLkeBb1wgVQhGa4nWJACoeH948R3nZ11dAZcBT3ytsPAcqRhbgxW5C6WvMJDwpky11hXKic1J9b1AL3FPJ4tcKcsYCWAF5cmHPa67ZeDc96r75iBz1AWGEXquMhCpx7AcBfAnQnYfGRrMewTdSwtizQofZ8Bm3x1vnkP6E4d3YPK5b8vPpFGKpAkDRxx8LxjREaWBk3rDMxCSy4ZJAvcWvZT9GftAqQmzxCvXUDWYxYZhBJEKVhzUB7ETR9UqzSWH1Y4E7kjh4B73GfeaQM6hHksYUeSWZH9aCxd9pJ9R4wHTCStLkYFse5QgT2y9BzwLeYE4uMXsfgcwP6YyQ7NjqDeqoJjprA","kind":"PAYMENT"}]

class PooledTxnsEntity {
  List<PooledUserCommandBean>? pooledUserCommands;

  static PooledTxnsEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    PooledTxnsEntity pooledTxnsEntityBean = PooledTxnsEntity();
    pooledTxnsEntityBean.pooledUserCommands = []..addAll(
      (map['pooledUserCommands'] as List).map((o) => PooledUserCommandBean.fromMap(o)!)
    );
    return pooledTxnsEntityBean;
  }

  Map toJson() => {
    "pooledUserCommands": pooledUserCommands,
  };
}

/// fee : "666010000000"
/// amount : "350888000000"
/// from : "B62qrGaXh9wekfwaA2yzUbhbvFYynkmBkhYLV36dvy5AkRvgeQnY6vx"
/// to : "B62qnpUj6EJGNvhJFMEAmM6skJRg1H37hVsHvPHMXhHeCXfKhSWGkGN"
/// hash : "CkpZPEy2gRHHX5QSQCWmCW1m8rPAotYd62Uykv4DXBxjfF5aQYVCU"
/// isDelegation : false
/// memo : "E4Ys2HUNyS6xwMKtP3vLhcstVG4342tajxrm53s2vJ7LuqS2UN6wi"
/// nonce : 10
/// token : "1"
/// id : "2G7L3ExMa4onsf1r561aByac95f871xyKdgjL2FiTmwsrd7jWRDe5Tn8S3xBLkeBb1wgVQhGa4nWJACoeH948R3nZ11dAZcBT3ytsPAcqRhbgxW5C6WvMJDwpky11hXKic1J9b1AL3FPJ4tcKcsYCWAF5cmHPa67ZeDc96r75iBz1AWGEXquMhCpx7AcBfAnQnYfGRrMewTdSwtizQofZ8Bm3x1vnkP6E4d3YPK5b8vPpFGKpAkDRxx8LxjREaWBk3rDMxCSy4ZJAvcWvZT9GftAqQmzxCvXUDWYxYZhBJEKVhzUB7ETR9UqzSWH1Y4E7kjh4B73GfeaQM6hHksYUeSWZH9aCxd9pJ9R4wHTCStLkYFse5QgT2y9BzwLeYE4uMXsfgcwP6YyQ7NjqDeqoJjprA"
/// kind : "PAYMENT"

class PooledUserCommandBean {
  String? fee;
  String? amount;
  String? from;
  String? to;
  String? hash;
  bool? isDelegation;
  String? memo;
  int? nonce;
  String? token;
  String? id;
  String? kind;
  dynamic failureReason;

  static PooledUserCommandBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    PooledUserCommandBean pooledUserCommandBean = PooledUserCommandBean();
    pooledUserCommandBean.fee = map['fee'];
    pooledUserCommandBean.amount = map['amount'];
    pooledUserCommandBean.from = map['from'];
    pooledUserCommandBean.to = map['to'];
    pooledUserCommandBean.hash = map['hash'];
    pooledUserCommandBean.isDelegation = map['isDelegation'];
    pooledUserCommandBean.memo = map['memo'];
    pooledUserCommandBean.nonce = map['nonce'];
    pooledUserCommandBean.token = map['token'];
    pooledUserCommandBean.id = map['id'];
    pooledUserCommandBean.kind = map['kind'];
    return pooledUserCommandBean;
  }

  Map toJson() => {
    "fee": fee,
    "amount": amount,
    "from": from,
    "to": to,
    "hash": hash,
    "isDelegation": isDelegation,
    "memo": memo,
    "nonce": nonce,
    "token": token,
    "id": id,
    "kind": kind,
  };
}