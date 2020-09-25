
//
String formatTokenNumber(String src) {
  int tokenNumber = int.parse(src);
  double formattedNumber = tokenNumber.toDouble() / 1000000000.0;
  return formattedNumber.toString();
}