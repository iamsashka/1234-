import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post.dart';

class FirestoreDataSource {
  final CollectionReference _posts = 
      FirebaseFirestore.instance.collection('posts');

  Stream<List<PostModel>> getPosts() {
    return _posts.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList()
    );
  }

  Future<void> createPost(String title, String content, {String? imageUrl}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Пользователь не авторизован');

    await _posts.add({
      'title': title,
      'content': content,
      'authorEmail': user.email,
      'authorId': user.uid,
      'createdAt': Timestamp.now(),
      'updatedAt': null,
      'imageUrl': imageUrl,
    });
  }

  Future<void> updatePost(String postId, String title, String content, {String? imageUrl}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Пользователь не авторизован');

    final postDoc = await _posts.doc(postId).get();
    if (postDoc['authorId'] != user.uid) {
      throw Exception('Можно редактировать только свои посты');
    }

    await _posts.doc(postId).update({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deletePost(String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Пользователь не авторизован');

    final postDoc = await _posts.doc(postId).get();
    if (postDoc['authorId'] != user.uid) {
      throw Exception('Можно удалять только свои посты');
    }

    await _posts.doc(postId).delete();
  }
}