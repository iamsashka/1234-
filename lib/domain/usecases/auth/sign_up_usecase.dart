import '../../repositories/auth_repository_interface.dart';

class SignUpUseCase {
  final AuthRepositoryInterface repository;

  SignUpUseCase(this.repository);

  Future<void> call(String email, String password) {
    return repository.signUp(email, password);
  }
}