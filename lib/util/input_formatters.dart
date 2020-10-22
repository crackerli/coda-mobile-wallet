import 'package:flutter/services.dart';
const _regExp=r'[0-9.]';

class SendAmountInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(null != newValue.text && newValue.text.isNotEmpty) {
      if(RegExp(_regExp).firstMatch(newValue.text) == null) {
        return oldValue;
      }

      if(newValue.text.indexOf('.') != newValue.text.lastIndexOf('.')) {
        return oldValue;
      }

      if(newValue.text.endsWith('.')) {
        return newValue;
      }

      if(newValue.text.contains('.')) {
        // Check if exceed the 9 position after .
        int index = newValue.text.lastIndexOf('.');
        String afterPoints = newValue.text.substring(index + 1, newValue.text.length - 1);
        if(afterPoints.length > 9) {
          return oldValue;
        }
      }
      return newValue;
    }
    return newValue;
  }
}

bool checkSendAmountValidation(String src) {
  if(null == src || src.isEmpty) {
    return false;
  }

  // No need to trim since the whitelist input formatter forbid the space input
  if(RegExp(_regExp).firstMatch(src) == null) {
    return false;
  }

  if(src.endsWith('.')) {
    return false;
  }

  // Input has more than one .
  if(src.indexOf('.') != src.lastIndexOf('.')) {
    return false;
  }

  if(src.contains('.')) {
    // Check if exceed the 9 position after .
    int index = src.lastIndexOf('.');
    String afterPoints = src.substring(index + 1, src.length);
    if(afterPoints.length > 9) {
      return false;
    }
  }

  double amountNumeric = double.parse(src);
  if(amountNumeric <= 0) {
    return false;
  }
  return true;
}

bool checkFeeValidation(String src) {
  if(null == src || src.isEmpty) {
    return false;
  }

  // No need to trim since the whitelist input formatter forbid the space input
  if(RegExp(_regExp).firstMatch(src) == null) {
    return false;
  }

  if(src.endsWith('.')) {
    return false;
  }

  // Input has more than one .
  if(src.indexOf('.') != src.lastIndexOf('.')) {
    return false;
  }

  if(src.contains('.')) {
    // Check if exceed the 9 position after .
    int index = src.lastIndexOf('.');
    String afterPoints = src.substring(index + 1, src.length);
    if(afterPoints.length > 9) {
      return false;
    }
  }

  double feeNumeric = double.parse(src);
  if(feeNumeric < 0.001) {
    return false;
  }
  return true;
}