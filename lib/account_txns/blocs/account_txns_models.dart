// "transactions": {
// "userCommands": [
// {
// "hash": "CkpZ4zEVSSKnqq8Cj3xkfCRC2fTYGVdGvdCM2gnSku7dxrm94g7cg",
// "memo": "E4YM2vTHhWEg66xpj52JErHUBU4pZ1yageL4TVDDpTTSsv8mK6YaH",
// "fee": "100000000",
// "to": "B62qjcUs1sinKcj5RiBeKU3h5ZyBHbJnaJ1aJ62Sod1jMqcZ6bFYW1G",
// "amount": "10000000000",
// "from": "B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g",
// "fromAccount": {
// "nonce": "2"
// }
// }
// ],
// "coinbase": "200000000000",
// "coinbaseReceiverAccount": {

class AccountTxn {
  final String userCommandHash;
  final String userCommandMemo;
  final String fee;
  final String toAccount;
  final String amount;
  final String fromAccount;
  final String nonce;
  final String coinbaseAccount;
  final String coinbase;

  const AccountTxn({
    this.amount,
    this.coinbaseAccount,
    this.fee,
    this.fromAccount,
    this.nonce,
    this.toAccount,
    this.userCommandHash,
    this.userCommandMemo,
    this.coinbase,
  });
}