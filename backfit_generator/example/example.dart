

import 'dart:io';

import 'package:backfit/backfit.dart';
import 'package:cross_file/cross_file.dart';

import 'my_post.dart';

part 'example.backfit.dart';

@BackfitService()
abstract class Posts {
  @Get('posts')
  Future<Response<MyPost>> postsByUserId(@Query('userId') String userId, @Header('content-type') String contentType); 

  @multiPart
  @Post('photos')
  Future<Response> uploadFile(@PartFile("image", "media/*") XFile? file);
}