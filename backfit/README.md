# Backfit

Backfit is a Retrofit inspired HTTP Client and API Service generator for Dart. This package works with its companion package called backfit_generator.

## Installation

Add the following to pubspec.yaml

```yaml

dependencies:
  backfit: <latest_version>

dev_dependencies:
  backfit_generator: <latest_version>
  build_runner: <latest_version>

```

## Usage

First create a BackFit client 

```dart

import 'package:backfit/backfit.dart';

final client = BackfitClient(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    interceptors: [HttpLogger()]);

```

Then create an interface annotated with `BackfitService` annotation, it takes base end point as an optional parameter.

`posts_service.dart`
```dart

import 'package:backfit/backfit.dart';

part 'posts_service.g.dart';

@BackfitService()
abstract class Posts {}

```

As per your API requirement create a model with serialization support. In this example, I am using `freezed` and `json_serializable` for it, however these are not necessary. You just need a `toJson()` method and `fromJson` factory or static method inside the model class

`my_post.dart`
```dart

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

```
Now go back to the api_service interface and add an abstract method defining the return type, endpoint and signature.

`posts_service.dart`
```dart

import 'package:backfit/backfit.dart';
import 'my_post.dart';

part 'posts_service.g.dart';

@BackfitService()
abstract class Posts {
  @Get('posts')
  Future<Response<List<MyPost>>> postsByUserId(@Query('userId') String userId); 
}

```
Note that the Response class mentioned here is from `Backfit` and not `http` and as such takes in your Model class as a type parameter for auto parsing.

This generates the following code -

`posts_service.g.dart`
```dart

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
        .get(Uri.parse('${_client!.baseUrl}/posts/posts?userId=$userId'));

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
}

```

What's Next? Consume the Api Service wherever you want like this -

```dart

//in some injector 
final postsService = PostsService.withClient(client);


//inside a consumer
postsService.postsByUserId('1').catchError((e) {
  print(e.toString());
});

```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)