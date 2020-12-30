const SEND_DELEGATION_MUTATION = r'''
  mutation SendDelegationMutation($fee: UInt64!, $from: PublicKey!, $to: PublicKey!, $memo: String) {
    sendDelegation(input: {fee: $fee, to: $to, from: $from, memo: $memo})
  }
''';