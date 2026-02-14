import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository_interface.dart';
import '../datasources/firestore_datasource.dart';
import '../models/post.dart';

class PostRepository implements PostRepositoryInterface {
  final FirestoreDataSource _dataSource;

  PostRepository(this._dataSource);

  @override
  Stream<List<PostEntity>> getPosts() {
    return _dataSource.getPosts().map(
      (posts) => posts.map((post) => post as PostEntity).toList()
    );
  }

  @override
  Future<void> createPost(String title, String content, {String? imageUrl}) {
    return _dataSource.createPost(title, content, imageUrl: imageUrl);
  }

  @override
  Future<void> updatePost(String postId, String title, String content, {String? imageUrl}) {
    return _dataSource.updatePost(postId, title, content, imageUrl: imageUrl);
  }

  @override
  Future<void> deletePost(String postId) {
    return _dataSource.deletePost(postId);
  }

  @override
  bool canModifyPost(PostEntity post) {
    final user = FirebaseAuth.instance.currentUser;
    return user != null && post.authorId == user.uid;
  }
}