const OWNED_ACCOUNTS_QUERY = '''
  query OwnedAccountsQuery {
    ownedWallets {
      nonce
      inferredNonce
      receiptChainHash
      delegate
      votingFor
      locked
      isTokenOwner
      isDisabled
      publicKey
    }
  }
''';