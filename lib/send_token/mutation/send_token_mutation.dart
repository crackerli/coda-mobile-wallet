const SEND_PAYMENT_MUTATION = r'''
  mutation SendPaymentMutation(
    $amount: UInt64!, $fee: UInt64!, $from: PublicKey!, $to: PublicKey!,
    $memo: String, $nonce: UInt32!, $token: Uint64!, $validUntil: Uint32!,
    $field: String!, $scalar: String!) {
    sendPayment(input: {fee: $fee, to: $to, from: $from, amount: $amount, memo: $memo, nonce: $nonce, validUntil: $validUntil}, signature: {scalar: $scalar, field: $field})
  }
''';
//sendPayment(input: {fee: "", amount: "", to: "", from: "", memo: "", nonce: "", token: "", validUntil: ""}, signature: {scalar: "", field: ""})