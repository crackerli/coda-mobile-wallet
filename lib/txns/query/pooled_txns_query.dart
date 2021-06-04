const POOLED_TXNS_QUERY = r'''
  query PooledTxnsQuery($publicKey: PublicKey!) {
    bestChain(maxLength: 2) {
      transactions {
        userCommands {
          hash
          kind
          amount
          fee
          from
          isDelegation
          memo
          to
          nonce
          failureReason
        }
      }
      protocolState {
        blockchainState {
          date
        }
        consensusState {
          blockHeight
        }
      }
    }
    pooledUserCommands(publicKey: $publicKey) {
      to
      from
      amount
      fee
      memo
      isDelegation
      hash
      nonce
      failureReason
    }
  }
''';