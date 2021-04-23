const ACCOUNT_QUERY = r'''
  query AccountQuery($publicKey: PublicKey!) {
    accounts(publicKey: $publicKey) {
      nonce
      publicKey
      stakingActive
      token
      delegate
      balance {
        total
      }
    }
  }
''';
