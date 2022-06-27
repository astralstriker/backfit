
import 'dart:io';

import 'package:backfit/backfit.dart';
import 'my_post.dart';

part 'posts_service.backfit.dart';

@BackfitService()
abstract class Posts {
  @Get('posts')
  Future<Response<List<MyPost>>> postsByUserId(@Query('userId') String userId); 

  
  @multiPart
  @Post('photo')
  Future<Response> uploadFile(@PartFile('image', 'media/*') File file);

    
  @multiPart
  @Post('photos')
  Future<Response> uploadFiles(@PartFile('image', 'media/*') List<File> file);

  @Post('posts')
  Future<Response> addPost(@Body() MyPost post);
}
