import 'package:intl/intl.dart';

extension StringCustomIntExtension on String? {
  String get currency {
    var value = double.tryParse(this.toString()) ?? 0.0;
    if (value == 0) return '0';
    return value.truncateToDouble() == value 
        ? NumberFormat('#,##0').format(value)
        : NumberFormat('#,##0.00').format(value);
  }
}

extension IntCustomIntExtension on int? {
  String get currency {
    var value = this?.toDouble() ?? 0.0;
    if (value == 0) return '0';
    return NumberFormat('#,##0').format(value);
  }
}

extension DoubleCustomIntExtension on double? {
  String get currency {
    var value = this ?? 0.0;
    if (value == 0) return '0';
    return value.truncateToDouble() == value 
        ? NumberFormat('#,##0').format(value)
        : NumberFormat('#,##0.00').format(value);
  }
}

extension NumCustomIntExtension on num? {
  String get currency {
    var value = this?.toDouble() ?? 0.0;
    if (value == 0) return '0';
    return value.truncateToDouble() == value 
        ? NumberFormat('#,##0').format(value)
        : NumberFormat('#,##0.00').format(value);
  }
}

extension NotNullStringCustomIntExtension on String {
  String get currency {
    var value = double.tryParse(this) ?? 0.0;
    if (value == 0) return '0';
    return value.truncateToDouble() == value 
        ? NumberFormat('#,##0').format(value)
        : NumberFormat('#,##0.00').format(value);
  }
}

extension NotNullIntCustomIntExtension on int {
  String get currency {
    if (this == 0) return '0';
    return NumberFormat('#,##0').format(this);
  }
}

extension NotNullDoubleCustomIntExtension on double {
  String get currency {
    if (this == 0) return '0';
    return truncateToDouble() == this 
        ? NumberFormat('#,##0').format(this)
        : NumberFormat('#,##0.00').format(this);
  } 
}

extension NotNullNumCustomIntExtension on num {
  String get currency {
    var value = toDouble();
    if (value == 0) return '0';
    return value.truncateToDouble() == value 
        ? NumberFormat('#,##0').format(value)
        : NumberFormat('#,##0.00').format(value);
  }
}
