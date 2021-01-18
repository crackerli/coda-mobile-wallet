const CONFIRMED_TXNS_QUERY = r'''
  query ConfirmedTxnsQuery($publicKey: String!) {
    transactions(
      limit: 1000
      sortBy: DATETIME_DESC
      query: {from: $publicKey, canonical: true}
    ) {
      fee
      from
      to
      nonce
      amount
      blockHeight
      memo
      hash
      kind
      dateTime
    }
  }
''';