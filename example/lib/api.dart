
import 'package:backfit/backfit.dart';
import 'my_post.dart';

part 'api.g.dart';

@BackfitService()
abstract class Api {
  @Get('posts')
  Future<Response<List<MyPost>>> postsByUserId(@Query('userId') String userId); 
}
