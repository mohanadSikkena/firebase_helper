
import 'package:flutter/cupertino.dart';

abstract class Validator{
  bool validation(String value);
  String errorMessage();
}

class NormalText extends Validator{
  @override
  String errorMessage() {
    return "";
  }

  @override
  bool validation(String? value) {
    return true;
  }

}


class PhoneValidation extends Validator{
  @override
  String errorMessage() {
   return "Enter A Valid Phone Number";
  }

  @override
  bool validation(String value) {
    return RegExp(r'^\+?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$')
            .hasMatch(value);
  }

}

class PasswordValidation extends Validator{
  bool _isNotEmpty = false;
  final String _isEmptyMessage = "Please enter a password";


  bool _hasUpperCase =true;
  final String _hasUpperCaseMessage = 'Contains at least one uppercase letter\n';
  bool _hasLowerCase = true;
  final String _hasLowerCaseMessage = 'Contains at least one lowercase letter.\n';
  bool _hasDigits = true;
  final String _hasDigitMessage = 'Contains at least one digit.\n';
  bool _hasSpecialChar = true;
  final String _hasSpecialCharMessage = 'Contains at least one special character\n';
  bool _hasMinLength = true;
  final String _hasMinLengthMessage = 'Is at least 8 characters long';

  @override

  String errorMessage() {
    if (!_isNotEmpty){
      return _isEmptyMessage;
    }
    return "${!_hasUpperCase?_hasUpperCaseMessage:""}${!_hasLowerCase?_hasLowerCaseMessage:""}${!_hasDigits?_hasDigitMessage:""}${!_hasSpecialChar?_hasSpecialCharMessage:""}${!_hasMinLength?_hasMinLengthMessage:""}";
  }

  hasUppercase(String s) => RegExp(r'[A-Z]').hasMatch(s);
  hasLowercase(String s) => RegExp(r'[a-z]').hasMatch(s);
  hasDigit(String s) => RegExp(r'[0-9]').hasMatch(s);
  hasSpecialChara(String s) => RegExp(r'[!@#$&*~]').hasMatch(s);
  hasMinLengthF(String s) => s.length >= 8;


  @override
  bool validation(String value) {
    if(value.isEmpty){
      return _isNotEmpty =false;
    }
    _isNotEmpty = true;
    _hasUpperCase=hasUppercase(value);
    _hasLowerCase = hasLowercase(value);
    _hasDigits=hasDigit(value);
    _hasSpecialChar=hasSpecialChara(value);
    _hasMinLength = hasMinLengthF(value);
    return _hasUpperCase&&_hasLowerCase&&_hasDigits&&_hasSpecialChar&&_hasMinLength;
  }

}

class ConfirmPasswordValidation extends Validator{
  TextEditingController passwordController ;
  ConfirmPasswordValidation(this.passwordController);
  @override
  String errorMessage() {
    return "Must Match the Password";
  }

  @override
  bool validation(String value) {
    return value ==passwordController.text;
  }

}

class EmailValidation extends Validator{

  bool emailExist = false;
  @override
  String errorMessage() {
    if(emailExist){
      return "The emailadress already in use";
    }
    return "Please Enter A Valid Email";
  }

  @override
  bool validation(String value) {
    if(emailExist){
      return false;
    }
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$")
        .hasMatch(value);
  }
}

class LoginValidation extends Validator {
  bool _isFieldNotEmpty = false;
  bool loginFailed = false;
  final String _emptyFieldMessage = "please enter a valid password.";

  @override
  String errorMessage() {
    if(!_isFieldNotEmpty){
      return _emptyFieldMessage;
    }
    return "Wrong Email or Password ";
  }

  @override
  bool validation(String value) {
    if (value.isEmpty){
      return _isFieldNotEmpty = false;
    }
    _isFieldNotEmpty = true;

    return !loginFailed ;

  }

}
class UserNameValidation extends Validator {
  bool _isFieldNotEmpty = false;
  bool userNameTaken = false;
  final String _emptyFieldMessage = "please enter a valid Username.";

  @override
  String errorMessage() {
    if(!_isFieldNotEmpty){
      return _emptyFieldMessage;
    }
    return "Username Already Taken";
  }

  @override
  bool validation(String value) {
    if (value.isEmpty){
      return _isFieldNotEmpty = false;
    }
    _isFieldNotEmpty = true;

    return !userNameTaken ;

  }

}
class DateValidator extends Validator {
  final String _emptyFieldMessage = "please enter a valid DateTime.";

  @override
  String errorMessage() {
      return _emptyFieldMessage;

  }

  @override
  bool validation(String value) {
      return value.isNotEmpty;



  }

}
class RequiredField extends Validator {
  final String _emptyFieldMessage = "This Field Is Required.";

  @override
  String errorMessage() {
      return _emptyFieldMessage;
  }

  @override
  bool validation(String value) {
      return value.isNotEmpty;



  }

}