const ACCOUNT_QUERY = r'''
  query AccountQuery($publicKey: PublicKey!) {
    accounts(publicKey: $publicKey) {
      nonce
      publicKey
      stakingActive
      token
      delegateAccount {
        publicKey
      }
      balance {
        total
      }
    }
  }
''';
