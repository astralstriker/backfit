// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BackfitGenerator
// **************************************************************************

class PostsService extends Posts with _$Posts {
  PostsService() {
    _client = BackfitClient();
  }

  PostsService.withClient(BackfitClient client) {
    _client = client;
  }
}

mixin _$Posts implements Posts {
  BackfitClient? _client;

  @override
  Future<Response<MyPost>> postsByUserId(String userId) async {
    final res = await _client!
        .get(Uri.parse('${_client!.baseUrl}/posts?userId=$userId'));
    return Response(
      data: res.body.isNotEmpty ? MyPost.fromJson(json.decode(res.body)) : null,
      statusCode: res.statusCode,
      reasonPhrase: res.reasonPhrase,
      headers: HttpHeaders.fromMap(res.headers),
    );
  }
}
