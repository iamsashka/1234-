import '../../repositories/post_repository_interface.dart';  // ИСПРАВЛЕНО

class CreatePostUseCase {
  final PostRepositoryInterface repository;

  CreatePostUseCase(this.repository);

  Future<void> call(String title, String content, {String? imageUrl}) {
    return repository.createPost(title, content, imageUrl: imageUrl);
  }
}