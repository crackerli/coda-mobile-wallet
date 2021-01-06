const ACCOUNT_TXNS_MUTATION = r'''
  query {
    characters(page: 1) {
      results {
        id
        name
        status
      }
    }
  }
''';