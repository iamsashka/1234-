import '../../repositories/post_repository_interface.dart';
import '../../entities/post_entity.dart';

class GetPostsUseCase {
  final PostRepositoryInterface repository;

  GetPostsUseCase(this.repository);

  Stream<List<PostEntity>> call() => repository.getPosts();
}