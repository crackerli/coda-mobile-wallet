const OWNED_ACCOUNTS_QUERY = '''
  query OwnedAccountsQuery {
    ownedWallets {
      locked
      publicKey
      balance {
        total
      }
    }
  }
''';