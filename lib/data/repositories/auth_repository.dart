import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepository implements AuthRepositoryInterface {
  final FirebaseAuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  @override
  Stream<User?> get authStateChanges => _dataSource.authStateChanges;

  @override
  User? get currentUser => _dataSource.currentUser;

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _dataSource.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await _dataSource.signUp(email, password);
      await _dataSource.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<void> resetPassword(String email) => _dataSource.resetPassword(email);

  @override
  Future<void> sendEmailVerification() => _dataSource.sendEmailVerification();

  @override
  bool isEmailVerified() => _dataSource.isEmailVerified();

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Неверный формат email';
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Email уже используется';
      case 'weak-password':
        return 'Слишком простой пароль';
      default:
        return 'Ошибка: ${e.message}';
    }
  }
}