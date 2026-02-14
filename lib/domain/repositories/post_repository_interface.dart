import '../entities/post_entity.dart';

abstract class PostRepositoryInterface {
  Stream<List<PostEntity>> getPosts();
  Future<void> createPost(String title, String content, {String? imageUrl});
  Future<void> updatePost(String postId, String title, String content, {String? imageUrl});
  Future<void> deletePost(String postId);
  bool canModifyPost(PostEntity post);
}