
//
String formatTokenNumber(String src) {
  if(null == src) {
    return '';
  }

  int tokenNumber = int.parse(src);
  double formattedNumber = tokenNumber.toDouble() / 1000000000.0;
  return formattedNumber.toString();
}

String formatAddress(String src) {
  if(null == src) {
    return '';
  }

  String prefix = src.substring(0, 5);
  String postfix = src.substring(src.length - 5, src.length);
  return '$prefix...$postfix';
}