/// id : 14750
/// hash : "CkpaDTwYq2ST4KVZnig7kXjb7SKxDP5KkUEGL8eoiTUKaRmMuSQwc"
/// type : "payment"
/// block_hash : "3NKjK1wZso1nCVdQHWQ4a3cMNHtt48PB5pWrBuAXXmnf15WaepCm"
/// block_height : 2168
/// time : "2021-03-23T09:33:00Z"
/// sender : "B62qjb83kxaq8QEKmCqGSPhBi4fPW6zKmgkvYj47gxzGDyDsGvX4Trm"
/// receiver : "B62qq5YxMfnoC9trqNzXDrM46zheg4Jq7qv9WBUtrqMYedgtCP67XCz"
/// amount : "1000000"
/// fee : "1000000"
/// nonce : 4
/// memo : "android test"
/// status : "applied"
/// failure_reason : null
/// sequence_number : 3
/// secondary_sequence_number : null

class IndexerTxnsEntity {
  List<IndexerTxnEntity>? indexerTxnsEntity;
}

class IndexerTxnEntity {
  int? id;
  String? hash;
  String? type;
  String? blockHash;
  int? blockHeight;
  String? time;
  String? sender;
  String? receiver;
  String? amount;
  String? fee;
  int? nonce;
  String? memo;
  String? status;
  dynamic? failureReason;
  int? sequenceNumber;
  dynamic? secondarySequenceNumber;

  static IndexerTxnEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    IndexerTxnEntity indexerTxnEntityBean = IndexerTxnEntity();
    indexerTxnEntityBean.id = map['id'];
    indexerTxnEntityBean.hash = map['hash'];
    indexerTxnEntityBean.type = map['type'];
    indexerTxnEntityBean.blockHash = map['block_hash'];
    indexerTxnEntityBean.blockHeight = map['block_height'];
    indexerTxnEntityBean.time = map['time'];
    indexerTxnEntityBean.sender = map['sender'];
    indexerTxnEntityBean.receiver = map['receiver'];
    indexerTxnEntityBean.amount = map['amount'];
    indexerTxnEntityBean.fee = map['fee'];
    indexerTxnEntityBean.nonce = map['nonce'];
    indexerTxnEntityBean.memo = map['memo'];
    indexerTxnEntityBean.status = map['status'];
    indexerTxnEntityBean.failureReason = map['failure_reason'];
    indexerTxnEntityBean.sequenceNumber = map['sequence_number'];
    indexerTxnEntityBean.secondarySequenceNumber = map['secondary_sequence_number'];
    return indexerTxnEntityBean;
  }

  Map toJson() => {
    "id": id,
    "hash": hash,
    "type": type,
    "block_hash": blockHash,
    "block_height": blockHeight,
    "time": time,
    "sender": sender,
    "receiver": receiver,
    "amount": amount,
    "fee": fee,
    "nonce": nonce,
    "memo": memo,
    "status": status,
    "failure_reason": failureReason,
    "sequence_number": sequenceNumber,
    "secondary_sequence_number": secondarySequenceNumber,
  };
}