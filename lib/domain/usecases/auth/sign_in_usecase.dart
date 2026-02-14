import '../../repositories/auth_repository_interface.dart';  // ИСПРАВЛЕНО: убрал лишний repositories

class SignInUseCase {
  final AuthRepositoryInterface repository;

  SignInUseCase(this.repository);

  Future<void> call(String email, String password) {
    return repository.signIn(email, password);
  }
}