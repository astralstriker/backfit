import 'dart:io';

import 'package:example/my_post.dart';
import 'package:example/network.dart';

void main(List<String> arguments) { 
  apiService.postsByUserId('1').catchError((e) {
    print(e.toString());
  });

  apiService.addPost(MyPost(userId: 1, id: 1, title: 'title', body: 'body'));

  File('standard.txt')
      .writeAsString('some content')
      .then(apiService.uploadFile);
}
