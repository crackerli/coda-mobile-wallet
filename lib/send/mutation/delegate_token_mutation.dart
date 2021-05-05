// const SEND_DELEGATION_MUTATION = r'''
//   mutation SendDelegationMutation($fee: UInt64!, $from: PublicKey!, $to: PublicKey!, $memo: String) {
//     sendDelegation(input: {fee: $fee, to: $to, from: $from, memo: $memo})
//   }
// ''';


const SEND_DELEGATION_MUTATION = r'''
  mutation SendDelegationMutation(
    $fee: UInt64!, $from: PublicKey!, $to: PublicKey!,
    $memo: String, $nonce: UInt32!, $validUntil: Uint32!,
    $field: String!, $scalar: String!) {
    sendDelegation(input: {fee: $fee, to: $to, from: $from, memo: $memo, nonce: $nonce, validUntil: $validUntil}, signature: {scalar: $scalar, field: $field})
  }
  ''';