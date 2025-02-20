class PostModel {
  final String id;
  final String author;
  final String body;
  final List<dynamic>? images;
  final String? video;
  final String? scheduledTime;
  final bool isArchived;
  final int commentsCount;
  final int likesCount;
  final int dislikesCount;
  final int viewsCount;

  PostModel({required this.id, required this.author, required this.body, this.images, this.video, this.scheduledTime, this.isArchived = false, this.commentsCount = 0, this.likesCount = 0, this.dislikesCount = 0, this.viewsCount = 0});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      author: json['author'],
      body: json['body'],
      images: json['images'],
      video: json['video'],
      scheduledTime: json['scheduled_time'],
      isArchived: json['is_archived'] ?? false,
      commentsCount: json['comments_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      dislikesCount: json['dislikes_count'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'author': author, 'body': body, 'images': images, 'video': video, 'scheduled_time': scheduledTime, 'is_archived': isArchived, 'comments_count': commentsCount, 'likes_count': likesCount, 'dislikes_count': dislikesCount, 'views_count': viewsCount};
  }
}
