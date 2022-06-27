import 'package:meta/meta.dart';

@immutable
class BackfitService {
  final String? baseUrl;
  const BackfitService([this.baseUrl]);
}

@immutable
class Body {
  const Body();
}

@immutable
class Query {
  final String query;
  const Query(this.query);
}

@immutable
class Path {
  final String path;
  const Path(this.path);
}

@immutable
class Header {
  final String key;
  const Header(this.key);
}

@immutable
class Headers {
  final Map<String, dynamic> headers;
  const Headers(this.headers);
}

@immutable
class Head {
  final String url;
  const Head(this.url);
}

@immutable
class Get {
  final String url;
  const Get(this.url);
}

@immutable
class Post {
  final String url;
  const Post(this.url);
}

@immutable
class Put {
  final String url;
  const Put(this.url);
}

@immutable
class Delete {
  final String url;
  const Delete(this.url);
}

const multiPart = Multipart();

@immutable
class Multipart {
  const Multipart();
}

@immutable
class PartFile {
  final String field;
  final String contentType;
  const PartFile(this.field, this.contentType);
}

@immutable
class PartField {
  final String field;
  const PartField(this.field);
}
