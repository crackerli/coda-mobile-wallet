//import 'package:intl/intl.dart';
//
String formatTokenNumber(String src) {
  if(null == src) {
    return '';
  }

  int tokenNumber = int.parse(src);
  double formattedNumber = tokenNumber.toDouble() / 1000000000.0;
  return formattedNumber.toString();
}

String formatHashEllipsis(String src) {
  if(null == src) {
    return '';
  }

  String prefix = src.substring(0, 5);
  String postfix = src.substring(src.length - 5, src.length);
  return '$prefix...$postfix';
}

String formatDateTime(String dateTime) {
  int timeInMillis = int.parse(dateTime);
  var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  return date.toLocal().toString();
//  var formattedDate = DateFormat.yMMMd().format(date);
}