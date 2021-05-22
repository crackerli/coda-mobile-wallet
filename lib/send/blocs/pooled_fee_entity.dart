class PooledFeeEntity {
  List<PooledUserCommandsBean?>? pooledUserCommands;

  static PooledFeeEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    PooledFeeEntity pooledFeeEntityBean = PooledFeeEntity();
    pooledFeeEntityBean.pooledUserCommands = []..addAll(
      (map['pooledUserCommands'] as List).map((o) => PooledUserCommandsBean.fromMap(o))
    );
    return pooledFeeEntityBean;
  }

  Map toJson() => {
    "pooledUserCommands": pooledUserCommands,
  };
}

class PooledUserCommandsBean {
  BigInt? fee;

  static PooledUserCommandsBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    PooledUserCommandsBean pooledUserCommandsBean = PooledUserCommandsBean();
    pooledUserCommandsBean.fee = BigInt.parse(map['fee']);
    return pooledUserCommandsBean;
  }

  Map toJson() => {
    "fee": fee.toString(),
  };
}