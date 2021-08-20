// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// YoshiGenerator
// **************************************************************************

class ApiService extends Api with _$Api {
  ApiService() {
    _client = YoshiClient();
  }

  ApiService.withClient(YoshiClient client) {
    _client = client;
  }
}

mixin _$Api implements Api {
  YoshiClient? _client;

  @override
  Future<Response<List<MyPost>>> postsByUserId(String userId) async {
    final res = await _client!
        .get(Uri.parse('${_client!.baseUrl}/posts?userId=$userId'));

    return Response(
      data: res.statusCode == 200
          ? (json.decode(res.body) as List)
              .map((it) => MyPost.fromJson(it))
              .toList()
          : null,
      statusCode: res.statusCode,
      reasonPhrase: res.reasonPhrase,
      headers: HttpHeaders.fromMap(res.headers),
    );
  }
}
