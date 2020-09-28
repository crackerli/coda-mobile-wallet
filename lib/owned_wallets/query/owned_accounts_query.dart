const OWNED_ACCOUNTS_QUERY = '''
  query OwnedAccountsQuery {
    ownedWallets {
      delegate
      votingFor
      locked
      isTokenOwner
      isDisabled
      publicKey
      token
      balance {
        total
      }
    }
  }
''';