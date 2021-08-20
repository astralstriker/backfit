import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_post.freezed.dart';
part 'my_post.g.dart';

@freezed
class MyPost with _$MyPost {
  const factory MyPost({
    required int userId,
    required int id,
    required String title,
    required String body,
  }) = _MyPost;

  factory MyPost.fromJson(Map<String, dynamic> json) => _$MyPostFromJson(json);
}
