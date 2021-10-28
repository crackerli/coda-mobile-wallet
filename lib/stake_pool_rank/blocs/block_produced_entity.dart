class BlockProducedEntity {
  List<BlocksBean?>? blocks;

  static BlockProducedEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    BlockProducedEntity blockProducedEntity = BlockProducedEntity();
    blockProducedEntity.blocks = []..addAll(
      (map['blocks'] as List ?? []).map((o) => BlocksBean.fromMap(o))
    );
    return blockProducedEntity;
  }

  Map toJson() => {
    "blocks": blocks,
  };
}

class BlocksBean {
  int? blockHeight;
  bool? canonical;
  ProtocolStateBean? protocolState;

  static BlocksBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    BlocksBean blocksBean = BlocksBean();
    blocksBean.blockHeight = map['blockHeight'];
    blocksBean.canonical = map['canonical'];
    blocksBean.protocolState = ProtocolStateBean.fromMap(map['protocolState']);
    return blocksBean;
  }

  Map toJson() => {
    "blockHeight": blockHeight,
    "canonical": canonical,
    "protocolState": protocolState,
  };
}

class ProtocolStateBean {
  ConsensusStateBean? consensusState;

  static ProtocolStateBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    ProtocolStateBean protocolStateBean = ProtocolStateBean();
    protocolStateBean.consensusState = ConsensusStateBean.fromMap(map['consensusState']);
    return protocolStateBean;
  }

  Map toJson() => {
    "consensusState": consensusState,
  };
}

class ConsensusStateBean {
  int? epoch;

  static ConsensusStateBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    ConsensusStateBean consensusStateBean = ConsensusStateBean();
    consensusStateBean.epoch = map['epoch'];
    return consensusStateBean;
  }

  Map toJson() => {
    "epoch": epoch,
  };
}

class EpochBlocks {
  int epoch;
  List<BlocksBean> blocks;

  EpochBlocks(this.epoch, this.blocks);
}
