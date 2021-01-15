const POOLED_FEE_QUERY = r'''
  query PooledFeeQuery {
    pooledUserCommands {
      fee
    }
  }
''';