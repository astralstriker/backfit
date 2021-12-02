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

  final List<int> _validStatuses = [
    HttpStatus.ok,
    HttpStatus.created,
    HttpStatus.accepted,
    HttpStatus.nonAuthoritativeInformation,
    HttpStatus.partialContent,
  ];

  @override
  Future<Response<MyPost>> postsByUserId(String userId) async {
    final res = await _client!
        .get(Uri.parse('${_client!.baseUrl}/posts?userId=$userId'));
    return Response(
      data: _validStatuses.contains(res.statusCode) && res.body.isNotEmpty
          ? MyPost.fromJson(json.decode(res.body))
          : null,
      statusCode: res.statusCode,
      reasonPhrase: res.reasonPhrase,
      headers: HttpHeaders.fromMap(res.headers),
    );
  }

  @override
  Future<Response> uploadFile(File file) async {
    final request =
        MultipartRequest('POST', Uri.parse('${_client!.baseUrl}/photos'));
    request.files.add(await MultipartFile.fromPath('image', file.path,
        contentType: MediaType('media', '*')));
    final res = await _client!.send(request);
    final data = await res.stream.bytesToString();

    return Response(
      data: _validStatuses.contains(res.statusCode) && data.isNotEmpty
          ? json.decode(data)
          : null,
      statusCode: res.statusCode,
      reasonPhrase: res.reasonPhrase,
      headers: HttpHeaders.fromMap(res.headers),
    );
  }
}
