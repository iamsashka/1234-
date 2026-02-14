import '../../repositories/auth_repository_interface.dart';  // ИСПРАВЛЕНО

class ResetPasswordUseCase {
  final AuthRepositoryInterface repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call(String email) => repository.resetPassword(email);
}