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

String formatDateTime(String millisSeconds) {
  if(null == millisSeconds) {
    return '';
  }

  int timeInMillis = int.parse(millisSeconds);
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  int year = dateTime.year;
  int month = dateTime.month;
  int day = dateTime.day;
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  int second = dateTime.second;
  return '$year-$month-$day $hour:$minute:$second';
}