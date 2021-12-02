// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_service.dart';

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
  Future<Response<List<MyPost>>> postsByUserId(String userId) async {
    final res = await _client!
        .get(Uri.parse('${_client!.baseUrl}/posts?userId=$userId'));

    return Response(
      data: res.body.isNotEmpty
          ? (json.decode(res.body) as List)
              .map((it) => MyPost.fromJson(it))
              .toList()
          : null,
      statusCode: res.statusCode,
      reasonPhrase: res.reasonPhrase,
      headers: HttpHeaders.fromMap(res.headers),
    );
  }

  @override
  Future<Response> uploadFile(File file) async {
    final request =
        MultipartRequest('POST', Uri.parse('${_client!.baseUrl}/photo'));
    request.files.add(await MultipartFile.fromPath('image', file.path,
        contentType: MediaType('media', '*')));
    final res = await _client!.send(request);
    final data = await res.stream.bytesToString();

    return Response(
      data: data.isNotEmpty ? json.decode(data) : null,
      statusCode: res.statusCode,
      reasonPhrase: res.reasonPhrase,
      headers: HttpHeaders.fromMap(res.headers),
    );
  }

  @override
  Future<Response> uploadFiles(List<File> file) async {
    final request =
        MultipartRequest('POST', Uri.parse('${_client!.baseUrl}/photos'));
    for (final _$x in file) {
      request.files.add(await MultipartFile.fromPath('image', _$x.path,
          contentType: MediaType('media', '*')));
    }
    final res = await _client!.send(request);
    final data = await res.stream.bytesToString();

    return Response(
      data: data.isNotEmpty ? json.decode(data) : null,
      statusCode: res.statusCode,
      reasonPhrase: res.reasonPhrase,
      headers: HttpHeaders.fromMap(res.headers),
    );
  }
}
