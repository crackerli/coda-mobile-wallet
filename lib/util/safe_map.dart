import 'dart:core';

class SafeMap {
  SafeMap(this.value);

  final dynamic value;

  SafeMap operator [](dynamic key) {
    if (value is Map) return SafeMap(value[key]);
    if (value is List) {
      List _list = value;
      int max = _list.length - 1;
      if (key is int && key <= max) return SafeMap(value[key]);
    }
    return SafeMap(null);
  }

  dynamic get v => value;
  String? get string => value is String ? value as String? : null;
  num? get number => value is num ? value as num? : null;
  int? get intValue => number?.toInt();
  double? get doubleValue => number?.toDouble();
  Map? get map => value is Map ? value as Map? : null;
  List? get list => value is List ? value as List? : null;
  bool? get boolean => value is bool ? value as bool? : false;

  num? get toNum {
    return this.number ?? (string == null ? null : num.tryParse(string!));
  }

  ///   "1.0" => null
  ///   122.0 => 122
  int? get toInt {
    return this.intValue ?? (string == null ? null : int.tryParse(string!));
  }

  int? get forceInt => toDouble?.toInt();

  double? get toDouble {
    return this.doubleValue ??
        this.intValue?.toDouble() ??
        (string == null ? null : double.tryParse(string!));
  }

  /// DateTime form String value.
  /// Use [DateTime.tryParse] Function.
  DateTime? get dateTime => DateTime.tryParse(this.string!);

  /// DateTime from [this.forceInt * 1000] value
  DateTime? get dateTimeFromSecond => this.forceInt != null
      ? DateTime.fromMillisecondsSinceEpoch(this.forceInt! * 1000)
      : null;

  /// DateTime from [this.forceInt] value as [millsecond]
  DateTime? get dateTimeFromMillsecond => this.forceInt != null
      ? DateTime.fromMillisecondsSinceEpoch(this.forceInt!)
      : null;

  /// DateTime from [this.forceInt] value as [microsecond]
  DateTime? get dateTimeFromMicrosecond => this.forceInt != null
      ? DateTime.fromMicrosecondsSinceEpoch(this.forceInt!)
      : null;

  bool isEmpty() {
    if (this.v == null) return true;
    if (this.string == '') return true;
    if (this.number == 0) return true;
    if (this.map?.keys.length == 0) return true;
    if (this.list?.length == 0) return true;
    if (this.boolean == false) return true;
    return false;
  }

  @override
  String toString() => '<SafeMap:$value>';
}
