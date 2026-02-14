import '../../repositories/post_repository_interface.dart';  // ИСПРАВЛЕНО

class DeletePostUseCase {
  final PostRepositoryInterface repository;

  DeletePostUseCase(this.repository);

  Future<void> call(String postId) => repository.deletePost(postId);
}