// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i2;

part 'user_card.data.gql.g.dart';

abstract class GUserCardFragment {
  String get G__typename;
  String get id;
  String get login;
  String? get name;
  _i1.GURI get avatarUrl;
  String? get bio;
  GUserCardFragment_repositories get repositories;
  GUserCardFragment_followers get followers;
}

abstract class GUserCardFragment_repositories {
  String get G__typename;
  int get totalCount;
}

abstract class GUserCardFragment_followers {
  String get G__typename;
  int get totalCount;
}

abstract class GUserCardFragmentData
    implements
        Built<GUserCardFragmentData, GUserCardFragmentDataBuilder>,
        GUserCardFragment {
  GUserCardFragmentData._();

  factory GUserCardFragmentData([
    void Function(GUserCardFragmentDataBuilder b) updates,
  ]) = _$GUserCardFragmentData;

  static void _initializeBuilder(GUserCardFragmentDataBuilder b) =>
      b..G__typename = 'User';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get id;
  @override
  String get login;
  @override
  String? get name;
  @override
  _i1.GURI get avatarUrl;
  @override
  String? get bio;
  @override
  GUserCardFragmentData_repositories get repositories;
  @override
  GUserCardFragmentData_followers get followers;
  static Serializer<GUserCardFragmentData> get serializer =>
      _$gUserCardFragmentDataSerializer;

  Map<String, dynamic> toJson() =>
      (_i2.serializers.serializeWith(GUserCardFragmentData.serializer, this)
          as Map<String, dynamic>);

  static GUserCardFragmentData? fromJson(Map<String, dynamic> json) =>
      _i2.serializers.deserializeWith(GUserCardFragmentData.serializer, json);
}

abstract class GUserCardFragmentData_repositories
    implements
        Built<
          GUserCardFragmentData_repositories,
          GUserCardFragmentData_repositoriesBuilder
        >,
        GUserCardFragment_repositories {
  GUserCardFragmentData_repositories._();

  factory GUserCardFragmentData_repositories([
    void Function(GUserCardFragmentData_repositoriesBuilder b) updates,
  ]) = _$GUserCardFragmentData_repositories;

  static void _initializeBuilder(GUserCardFragmentData_repositoriesBuilder b) =>
      b..G__typename = 'RepositoryConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GUserCardFragmentData_repositories> get serializer =>
      _$gUserCardFragmentDataRepositoriesSerializer;

  Map<String, dynamic> toJson() =>
      (_i2.serializers.serializeWith(
            GUserCardFragmentData_repositories.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GUserCardFragmentData_repositories? fromJson(
    Map<String, dynamic> json,
  ) => _i2.serializers.deserializeWith(
    GUserCardFragmentData_repositories.serializer,
    json,
  );
}

abstract class GUserCardFragmentData_followers
    implements
        Built<
          GUserCardFragmentData_followers,
          GUserCardFragmentData_followersBuilder
        >,
        GUserCardFragment_followers {
  GUserCardFragmentData_followers._();

  factory GUserCardFragmentData_followers([
    void Function(GUserCardFragmentData_followersBuilder b) updates,
  ]) = _$GUserCardFragmentData_followers;

  static void _initializeBuilder(GUserCardFragmentData_followersBuilder b) =>
      b..G__typename = 'FollowerConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GUserCardFragmentData_followers> get serializer =>
      _$gUserCardFragmentDataFollowersSerializer;

  Map<String, dynamic> toJson() =>
      (_i2.serializers.serializeWith(
            GUserCardFragmentData_followers.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GUserCardFragmentData_followers? fromJson(Map<String, dynamic> json) =>
      _i2.serializers.deserializeWith(
        GUserCardFragmentData_followers.serializer,
        json,
      );
}
