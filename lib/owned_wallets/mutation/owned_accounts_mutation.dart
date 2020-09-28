const ACCOUNT_LOCK_MUTATION = r'''
  mutation MyMutation($publicKey: PublicKey!) {
    __typename
    lockAccount(input: {publicKey: $publicKey})
  }
''';

const ACCOUNT_UNLOCK_MUTATION = r'''
  mutation MyMutation($publicKey: PublicKey!, $password: String!) {
    __typename
    unlockAccount(input: {publicKey: $publicKey, password: $password})
  }
''';