const ARCHIVED_TXNS_QUERY = r'''
  query ArchivedTxnsQuery($from: String!, $to: String!) {
    transactions(
      limit: 1000
      sortBy: DATETIME_DESC
      query: {OR: [{from: $from}, {to: $to}], AND: {canonical: true}}
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
      isDelegation
      failureReason
    }
  }
''';