import 'package:flutter/material.dart';

class AppConstants {
  // Цвета
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  
  // Анимации
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  
  // Тексты уведомлений
  static const String welcomeMessage = 'Добро пожаловать!';
  static const String postCreated = 'Пост успешно создан';
  static const String postUpdated = 'Пост обновлен';
  static const String postDeleted = 'Пост удален';
  static const String passwordResetSent = 'Ссылка для сброса пароля отправлена на почту';
}