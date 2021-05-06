const CONSENSUS_STATE_QUERY = r'''
  query ConsensusStateQuery {
    bestChain(maxLength: 1) {
      protocolState {
        consensusState {
          epoch
          slot
        }
      }
    }
  }
''';