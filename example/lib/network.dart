import 'package:example/posts_service.dart';
import 'package:backfit/backfit.dart';

final client = BackfitClient(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    interceptors: [PrettyLogger()]);


final apiService = PostsService.withClient(client);
