const String ACCOUNT_TXNS_QUERY = r'''
  query TxQuery($publicKey: PublicKey!) {
    blocks(filter: {relatedTo: $publicKey}) {
      pageInfo
      nodes {
        transactions {
          userCommands {
            id
            to
            from
            amount
            fee
            isDelegation
          }
        }
      }
    }
  }
''';