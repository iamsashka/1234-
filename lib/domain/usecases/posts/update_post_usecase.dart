import '../../repositories/post_repository_interface.dart';  // ИСПРАВЛЕНО

class UpdatePostUseCase {
  final PostRepositoryInterface repository;

  UpdatePostUseCase(this.repository);

  Future<void> call(String postId, String title, String content, {String? imageUrl}) {
    return repository.updatePost(postId, title, content, imageUrl: imageUrl);
  }
}