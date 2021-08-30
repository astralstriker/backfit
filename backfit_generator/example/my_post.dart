class MyPost {
  final int userId;
  final int id;
  final String title;
  final String body;

  MyPost(this.userId, this.id, this.title, this.body);

  factory MyPost.fromJson(Map<String, dynamic> json) =>
      MyPost(json["userId"], json['id'], json['title'], json['body']);
}
