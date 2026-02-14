import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email обязателен';
    }
    if (!EmailValidator.validate(value)) {
      return 'Введите корректный email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль обязателен';
    }
    if (value.length < 6) {
      return 'Пароль должен быть не менее 6 символов';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != password) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите заголовок';
    }
    if (value.length < 3) {
      return 'Заголовок должен быть не менее 3 символов';
    }
    return null;
  }

  static String? validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите текст поста';
    }
    if (value.length < 10) {
      return 'Текст должен быть не менее 10 символов';
    }
    return null;
  }
}