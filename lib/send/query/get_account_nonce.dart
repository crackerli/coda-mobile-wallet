const GET_NONCE_QUERY = r'''
  query GetNonceQuery($publicKey: PublicKey!) {
    account(publicKey: $publicKey) {
      nonce
      inferredNonce
    }
  }
''';