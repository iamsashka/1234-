class PostEntity {
  final String id;
  final String title;
  final String content;
  final String authorEmail;
  final String authorId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;

  const PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.authorEmail,
    required this.authorId,
    required this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  PostEntity copyWith({
    String? id,
    String? title,
    String? content,
    String? authorEmail,
    String? authorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorEmail: authorEmail ?? this.authorEmail,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}