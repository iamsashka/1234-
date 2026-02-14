import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepositoryInterface {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> sendEmailVerification();
  bool isEmailVerified();
}