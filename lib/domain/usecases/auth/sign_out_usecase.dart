import '../../repositories/auth_repository_interface.dart';  // ИСПРАВЛЕНО

class SignOutUseCase {
  final AuthRepositoryInterface repository;

  SignOutUseCase(this.repository);

  Future<void> call() => repository.signOut();
}