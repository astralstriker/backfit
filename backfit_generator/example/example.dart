
import 'package:backfit/backfit.dart';

import 'my_post.dart';

part 'example.backfit.dart';

@BackfitService()
abstract class Posts {
  @Get('posts')
  Future<Response<MyPost>> postsByUserId(@Query('userId') String userId); 
}