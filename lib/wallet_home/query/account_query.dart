const ACCOUNT_QUERY = r'''
  query AccountQuery($publicKey: PublicKey!) {
    account(publicKey: $publicKey, token: "1") {
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
