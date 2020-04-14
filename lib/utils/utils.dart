import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// With the card number with Luhn Algorithm
/// https://en.wikipedia.org/wiki/Luhn_algorithm
String validateReview(String input) {
  if (input.isEmpty) {
    return "Review can't be empty";
  }
}

String validateCardNum(String input) {
  if (input.isEmpty) {
    return "Number is invalid";
  }

  input = getCleanedNumber(input);

  if (input.length < 8) {
    return "Number is invalid";
  }

  int sum = 0;
  int length = input.length;
  for (var i = 0; i < length; i++) {
    // get digits in reverse order
    int digit = int.parse(input[length - i - 1]);

    // every 2nd number multiply with 2
    if (i % 2 == 1) {
      digit *= 2;
    }
    sum += digit > 9 ? (digit - 9) : digit;
  }

  if (sum % 10 == 0) {
    return null;
  }

  return "Number is invalid";
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

formatNumber(number) {
  final formatCurrency = new NumberFormat("#,##0.00", "en_US");
  return formatCurrency.format(number);
}

String getCleanedNumber(String text) {
  RegExp regExp = new RegExp(r"[^0-9]");
  return text.replaceAll(regExp, '');
}

String validateCardNumWithLuhnAlgorithm(String input) {
  if (input.isEmpty) {
    return "Card field can't be empty.";
  }

  input = getCleanedNumber(input);

  if (input.length < 8) {
    // No need to even proceed with the validation if it's less than 8 characters
    return "Card is not valid.";
  }

  int sum = 0;
  int length = input.length;
  for (var i = 0; i < length; i++) {
    // get digits in reverse order
    int digit = int.parse(input[length - i - 1]);

    // every 2nd number multiply with 2
    if (i % 2 == 1) {
      digit *= 2;
    }
    sum += digit > 9 ? (digit - 9) : digit;
  }

  if (sum % 10 == 0) {
    return null;
  }

  return "Card is not valid.";
}

String validateCVV(String value) {
  if (value.isEmpty) {
    return "Field can't be empty";
  }

  if (value.length < 3 || value.length > 4) {
    return "CVV is invalid";
  }
  return null;
}

String addSpaces(String text) {
  var buffer = new StringBuffer();
  for (int i = 0; i < text.length; i++) {
    buffer.write(text[i]);
    var nonZeroIndex = i + 1;
    if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
      buffer.write('  '); // Add double spaces.
    }
  }
  return buffer.toString();
}

String validateDate(String value) {
  if (value.isEmpty) {
    return "Date required";
  }

  int year;
  int month;
  // The value contains a forward slash if the month and year has been
  // entered.
  if (value.contains(new RegExp(r'(\/)'))) {
    var split = value.split(new RegExp(r'(\/)'));
    // The value before the slash is the month while the value to right of
    // it is the year.
    month = int.parse(split[0]);
    year = int.parse(split[1]);
  } else {
    // Only the month was entered
    month = int.parse(value.substring(0, (value.length)));
    year = -1; // Lets use an invalid year intentionally
  }

  if ((month < 1) || (month > 12)) {
    // A valid month is between 1 (January) and 12 (December)
    return 'Expiry month is invalid';
  }

  var fourDigitsYear = convertYearTo4Digits(year);
  if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
    // We are assuming a valid year should be between 1 and 2099.
    // Note that, it's valid doesn't mean that it has not expired.
    return 'Expiry year is invalid';
  }

  if (!hasDateExpired(month, year)) {
    return "Card has expired";
  }
  return null;
}

/// Convert the two-digit year to four-digit year if necessary
int convertYearTo4Digits(int year) {
  if (year < 100 && year >= 0) {
    var now = DateTime.now();
    String currentYear = now.year.toString();
    String prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}

bool hasDateExpired(int month, int year) {
  return !(month == null || year == null) && isNotExpired(year, month);
}

bool isNotExpired(int year, int month) {
  // It has not expired if both the year and date has not passed
  return !hasYearPassed(year) && !hasMonthPassed(year, month);
}

bool hasMonthPassed(int year, int month) {
  var now = DateTime.now();
  // The month has passed if:
  // 1. The year is in the past. In that case, we just assume that the month
  // has passed
  // 2. Card's month (plus another month) is less than current month.
  return hasYearPassed(year) ||
      convertYearTo4Digits(year) == now.year && (month < now.month + 1);
}

bool hasYearPassed(int year) {
  int fourDigitsYear = convertYearTo4Digits(year);
  var now = DateTime.now();
  // The year has passed if the year we are currently, is greater than card's
  // year
  return fourDigitsYear < now.year;
}

parseDateToString(date) {
  DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime dateTime = inputFormat.parse(date);
  DateFormat outputFormat = DateFormat("yyyy-MM-dd");
  DateTime dateTime2 = outputFormat.parse(dateTime.toString());
  return dateTime2.toString().split(" ")[0];
}
