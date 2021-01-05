//import 'package:intl/intl.dart';
//
String formatTokenNumber(String src) {
  if(null == src || src.isEmpty) {
    return '';
  }

  BigInt tokenNumber = BigInt.parse(src);
  double formattedNumber = tokenNumber.toDouble() / 1000000000.0;
  return formattedNumber.toString();
}

String formatHashEllipsis(String src) {
  if(null == src || src.isEmpty) {
    return '';
  }

  String prefix = src.substring(0, 5);
  String postfix = src.substring(src.length - 5, src.length);
  return '$prefix...$postfix';
}

String formatDateTime(String millisSeconds) {
  if(null == millisSeconds || millisSeconds.isEmpty) {
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

int getNanoMina(String src) {
  if(null == src || src.isEmpty) {
    return 0;
  }

  double tmp = double.parse(src);
  return (tmp * 1000000000).toInt();
}

bool checkNumeric(String str) {
  if(str == null || str.isEmpty) {
    return false;
  }
  return double.tryParse(str) != null;
}