import 'package:intl/intl.dart';
import 'package:carpool/constants.dart';

bool isPasswordComplex(String password) {
  if (password.length < 8) {
    return false;
  }
  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  bool hasDigits = password.contains(RegExp(r'[0-9]'));
  bool hasSpecialCharacters = password.contains(RegExp(regexSpecialCharacters));

  return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
}

bool isEmailValid(String email) {
  String emailPattern = regexEmail;
  RegExp regExp = RegExp(emailPattern);
  return regExp.hasMatch(email);
}

String validateRegistrationInput(String name, String email, String phoneNumber,
    String password, String confirmPassword) {
  String errorMessage = '';
  DateTime now = DateTime.now();
  String currentYear = DateFormat('yy').format(now);
  if (password == '' ||
      confirmPassword == '' ||
      name == '' ||
      email == '' ||
      phoneNumber == '') {
    errorMessage = 'ALL FIELD MUST BE FILLED';
  } else if (password != confirmPassword) {
    errorMessage = 'PASSWORDS DON\'T MATCH';
  } else if (!isPasswordComplex(password)) {
    errorMessage =
        'Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters';
  } else if (!RegExp(regexEmail).hasMatch(email) ||
      int.parse(email.substring(0, 2)) > int.parse(currentYear)) {
    errorMessage = 'INVALID ASU EMAIL';
  } else if (!RegExp(regexPhoneNumber).hasMatch(phoneNumber)) {
    errorMessage = 'INVALID PHONE NUMBER';
  } else if (!RegExp(regexName).hasMatch(name)) {
    errorMessage = 'NAME MUST CONTAIN LETTERS ONLY';
  }

  return errorMessage;
}

String validateLoginInput(String email, String password) {
  String errorMessage = '';
  if (email == '' || password == '') {
    errorMessage = 'Please enter email and password';
  } else if (!isEmailValid(email)) {
    errorMessage = 'Invalid email format';
  }
  return errorMessage;
}

String validateEdit(String phoneNumber, String name) {
  String errorMessage = '';
  if (name == '' || phoneNumber == '') {
    errorMessage = 'Fields can\'t be empty';
  } else if (!RegExp(regexPhoneNumber).hasMatch(phoneNumber)) {
    errorMessage = 'INVALID PHONE NUMBER';
  } else if (!RegExp(regexName).hasMatch(name)) {
    errorMessage = 'NAME MUST CONTAIN LETTERS ONLY';
  }
  return errorMessage;
}

String validateAddRide(DateTime selectedDate, String selectedRideTime,
    String selectedStart, String selectedEnd) {
  String errorMessage = '';

  if (selectedDate == null || selectedRideTime == 'null') {
    errorMessage = 'Please choose Date and Time';
  } else if ((selectedStart == 'Gate 3' || selectedStart == 'Gate 4') &&
      (selectedEnd == 'Gate 3' || selectedEnd == 'Gate 4')) {
    errorMessage = 'Path must be from or to university';
  } else if ((selectedStart != 'Gate 3' && selectedStart != 'Gate 4') &&
      (selectedEnd != 'Gate 3' && selectedEnd != 'Gate 4')) {
    errorMessage = 'Path must be from or to university';
  }

  if (selectedRideTime == '7:30 AM') {
    if (selectedStart == 'Gate 3' || selectedStart == 'Gate 4') {
      errorMessage = 'Invalid start point for 7:30 AM ride';
    } else if (selectedEnd != 'Gate 3' && selectedEnd != 'Gate 4') {
      errorMessage = 'Invalid end point for 7:30 AM ride';
    }
  } else if (selectedRideTime == '5:30 PM') {
    if (selectedEnd == 'Gate 3' || selectedEnd == 'Gate 4') {
      errorMessage = 'Invalid end point for 5:30 PM ride';
    } else if (selectedStart != 'Gate 3' && selectedStart != 'Gate 4') {
      errorMessage = 'Invalid start point for 5:30 PM ride';
    }
  }

  DateTime now = DateTime.now();

  if (selectedRideTime == '7:30 AM') {
    int newHour = 7;
    int newMinute = 30;
    DateTime modifiedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      newHour,
      newMinute,
      selectedDate.second,
      selectedDate.millisecond,
      selectedDate.microsecond,
    );
    if ((modifiedDate.difference(now)).inMinutes < 790) {
      errorMessage = '7:30 AM rides should be added before 8 PM';
    }
  } else if (selectedRideTime == '5:30 PM') {
    int newHour = 17;
    int newMinute = 30;
    DateTime modifiedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      newHour,
      newMinute,
      selectedDate.second,
      selectedDate.millisecond,
      selectedDate.microsecond,
    );
    if ((modifiedDate.difference(now)).inMinutes < 390) {
      errorMessage = '5:30 PM rides should be added before 11 AM';
    }
  }
  return errorMessage;
}
