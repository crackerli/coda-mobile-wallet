const ACCOUNT_TXNS_QUERY = r'''
  query TxQuery($publicKey: PublicKey!) {
    blocks(filter: {relatedTo: $publicKey}) {
      nodes {
        transactions {
          userCommands {
            hash
            memo
            fee
            to
            amount
            from
            fromAccount {
              nonce
            }
          }
          coinbase
          coinbaseReceiverAccount {
            publicKey
          }
        }
      }
      totalCount
    }
  }
''';