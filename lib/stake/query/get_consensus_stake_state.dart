const CONSENSUS_STAKE_STATE_QUERY = r'''
  query ConsensusStakeStateQuery($publicKey: PublicKey!) {
    bestChain(maxLength: 1) {
      protocolState {
        consensusState {
          epoch
          slot
        }
      }
    }

    accounts(publicKey: $publicKey) {
      publicKey
      stakingActive
      delegateAccount {
        publicKey
      }
    }
  }
''';
