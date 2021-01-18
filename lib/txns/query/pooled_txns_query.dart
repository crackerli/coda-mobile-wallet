const POOLED_TXNS_QUERY = r'''
  query PooledTxnsQuery($publicKey: PublicKey!) {
    pooledUserCommands(publicKey: $publicKey) {
      to
      from
      amount
      fee
      memo
      isDelegation
      hash
      nonce
    }
  }
''';