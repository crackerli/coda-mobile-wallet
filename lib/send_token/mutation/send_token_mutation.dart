const SEND_PAYMENT_MUTATION = r'''
  mutation SendPaymentMutation($amount: UInt64!, $fee: UInt64!, $from: PublicKey!, $to: PublicKey!, $memo: String) {
    sendPayment(input: {fee: $fee, to: $to, from: $from, amount: $amount, memo: $memo})
  }
''';
