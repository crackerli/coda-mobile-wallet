const STAKE_STATE_QUERY = r'''  
query StakeStateQuery($publicKey: String!, $epoch: Int!) {
  stake(query: {public_key: $publicKey, epoch: $epoch}) {
    balance
    delegate
  }
  nextstake(query: {public_key: $publicKey}) {
    balance
    delegate
  }
}
''';
