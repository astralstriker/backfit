import 'package:example/api.dart';
import 'package:backfit/backfit.dart';

final client = YoshiClient(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    interceptors: [HttpLogger()]);

final apiService = ApiService.withClient(client);


main(List<String> args) {
  apiService.postsByUserId('1');
}

