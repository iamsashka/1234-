import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required String id,
    required String title,
    required String content,
    required String authorEmail,
    required String authorId,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? imageUrl,
  }) : super(
          id: id,
          title: title,
          content: content,
          authorEmail: authorEmail,
          authorId: authorId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          imageUrl: imageUrl,
        );

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorEmail: data['authorEmail'] ?? '',
      authorId: data['authorId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'authorEmail': authorEmail,
      'authorId': authorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'imageUrl': imageUrl,
    };
  }
}