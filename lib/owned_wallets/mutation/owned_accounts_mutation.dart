const CREATE_ACCOUNT_MUTATION = r'''
  mutation CreateAccountMutation($password: String!) {
    __typename
    createAccount(input: {password: $password}) {
      account {
        locked
        balance {
          total
        }
        publicKey
      }
    }
  }
''';