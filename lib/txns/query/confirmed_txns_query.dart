const CONFIRMED_TXNS_QUERY = r'''
  query ConfirmedTxnsQuery($from: String!) {
    transactions(
      limit: 1000
      sortBy: DATETIME_DESC
      query: {from: $from, canonical: true}
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