class MergedUserCommand {
  String? to;
  String? from;
  String? amount;
  String? fee;
  String? memo;
  // If this is indexer memo, then no need to do base58check decode
  bool? isIndexerMemo;
  bool? isDelegation;
  String? hash;
  int? nonce;
  bool? isPooled;
  String? dateTime;
  int? blockHeight;
  dynamic failureReason;

  @override
  int get hashCode {
    return hash?.hashCode ?? 123456789;
  }

  @override
  bool operator ==(other) {
    if(other is! MergedUserCommand) {
      return false;
    }
    return hash == other.hash;
  }
}

