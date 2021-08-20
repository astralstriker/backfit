// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'my_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MyPost _$MyPostFromJson(Map<String, dynamic> json) {
  return _MyPost.fromJson(json);
}

/// @nodoc
class _$MyPostTearOff {
  const _$MyPostTearOff();

  _MyPost call(
      {required int userId,
      required int id,
      required String title,
      required String body}) {
    return _MyPost(
      userId: userId,
      id: id,
      title: title,
      body: body,
    );
  }

  MyPost fromJson(Map<String, Object> json) {
    return MyPost.fromJson(json);
  }
}

/// @nodoc
const $MyPost = _$MyPostTearOff();

/// @nodoc
mixin _$MyPost {
  int get userId => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MyPostCopyWith<MyPost> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyPostCopyWith<$Res> {
  factory $MyPostCopyWith(MyPost value, $Res Function(MyPost) then) =
      _$MyPostCopyWithImpl<$Res>;
  $Res call({int userId, int id, String title, String body});
}

/// @nodoc
class _$MyPostCopyWithImpl<$Res> implements $MyPostCopyWith<$Res> {
  _$MyPostCopyWithImpl(this._value, this._then);

  final MyPost _value;
  // ignore: unused_field
  final $Res Function(MyPost) _then;

  @override
  $Res call({
    Object? userId = freezed,
    Object? id = freezed,
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_value.copyWith(
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$MyPostCopyWith<$Res> implements $MyPostCopyWith<$Res> {
  factory _$MyPostCopyWith(_MyPost value, $Res Function(_MyPost) then) =
      __$MyPostCopyWithImpl<$Res>;
  @override
  $Res call({int userId, int id, String title, String body});
}

/// @nodoc
class __$MyPostCopyWithImpl<$Res> extends _$MyPostCopyWithImpl<$Res>
    implements _$MyPostCopyWith<$Res> {
  __$MyPostCopyWithImpl(_MyPost _value, $Res Function(_MyPost) _then)
      : super(_value, (v) => _then(v as _MyPost));

  @override
  _MyPost get _value => super._value as _MyPost;

  @override
  $Res call({
    Object? userId = freezed,
    Object? id = freezed,
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_MyPost(
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MyPost implements _MyPost {
  const _$_MyPost(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory _$_MyPost.fromJson(Map<String, dynamic> json) =>
      _$$_MyPostFromJson(json);

  @override
  final int userId;
  @override
  final int id;
  @override
  final String title;
  @override
  final String body;

  @override
  String toString() {
    return 'MyPost(userId: $userId, id: $id, title: $title, body: $body)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MyPost &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.body, body) ||
                const DeepCollectionEquality().equals(other.body, body)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(body);

  @JsonKey(ignore: true)
  @override
  _$MyPostCopyWith<_MyPost> get copyWith =>
      __$MyPostCopyWithImpl<_MyPost>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MyPostToJson(this);
  }
}

abstract class _MyPost implements MyPost {
  const factory _MyPost(
      {required int userId,
      required int id,
      required String title,
      required String body}) = _$_MyPost;

  factory _MyPost.fromJson(Map<String, dynamic> json) = _$_MyPost.fromJson;

  @override
  int get userId => throw _privateConstructorUsedError;
  @override
  int get id => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get body => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MyPostCopyWith<_MyPost> get copyWith => throw _privateConstructorUsedError;
}
