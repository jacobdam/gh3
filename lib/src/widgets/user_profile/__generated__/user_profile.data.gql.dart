// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i2;

part 'user_profile.data.gql.g.dart';

abstract class GUserProfileFragment {
  String get G__typename;
  String get id;
  String get login;
  String? get name;
  String get email;
  String? get bio;
  String? get location;
  String? get company;
  _i1.GURI? get websiteUrl;
  _i1.GURI get avatarUrl;
  _i1.GURI get url;
  GUserProfileFragment_repositories get repositories;
  GUserProfileFragment_followers get followers;
  GUserProfileFragment_following get following;
  _i1.GDateTime get createdAt;
  _i1.GDateTime get updatedAt;
}

abstract class GUserProfileFragment_repositories {
  String get G__typename;
  int get totalCount;
}

abstract class GUserProfileFragment_followers {
  String get G__typename;
  int get totalCount;
}

abstract class GUserProfileFragment_following {
  String get G__typename;
  int get totalCount;
}

abstract class GUserProfileFragmentData
    implements
        Built<GUserProfileFragmentData, GUserProfileFragmentDataBuilder>,
        GUserProfileFragment {
  GUserProfileFragmentData._();

  factory GUserProfileFragmentData([
    void Function(GUserProfileFragmentDataBuilder b) updates,
  ]) = _$GUserProfileFragmentData;

  static void _initializeBuilder(GUserProfileFragmentDataBuilder b) =>
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
  String get email;
  @override
  String? get bio;
  @override
  String? get location;
  @override
  String? get company;
  @override
  _i1.GURI? get websiteUrl;
  @override
  _i1.GURI get avatarUrl;
  @override
  _i1.GURI get url;
  @override
  GUserProfileFragmentData_repositories get repositories;
  @override
  GUserProfileFragmentData_followers get followers;
  @override
  GUserProfileFragmentData_following get following;
  @override
  _i1.GDateTime get createdAt;
  @override
  _i1.GDateTime get updatedAt;
  static Serializer<GUserProfileFragmentData> get serializer =>
      _$gUserProfileFragmentDataSerializer;

  Map<String, dynamic> toJson() =>
      (_i2.serializers.serializeWith(GUserProfileFragmentData.serializer, this)
          as Map<String, dynamic>);

  static GUserProfileFragmentData? fromJson(Map<String, dynamic> json) => _i2
      .serializers
      .deserializeWith(GUserProfileFragmentData.serializer, json);
}

abstract class GUserProfileFragmentData_repositories
    implements
        Built<
          GUserProfileFragmentData_repositories,
          GUserProfileFragmentData_repositoriesBuilder
        >,
        GUserProfileFragment_repositories {
  GUserProfileFragmentData_repositories._();

  factory GUserProfileFragmentData_repositories([
    void Function(GUserProfileFragmentData_repositoriesBuilder b) updates,
  ]) = _$GUserProfileFragmentData_repositories;

  static void _initializeBuilder(
    GUserProfileFragmentData_repositoriesBuilder b,
  ) => b..G__typename = 'RepositoryConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GUserProfileFragmentData_repositories> get serializer =>
      _$gUserProfileFragmentDataRepositoriesSerializer;

  Map<String, dynamic> toJson() =>
      (_i2.serializers.serializeWith(
            GUserProfileFragmentData_repositories.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GUserProfileFragmentData_repositories? fromJson(
    Map<String, dynamic> json,
  ) => _i2.serializers.deserializeWith(
    GUserProfileFragmentData_repositories.serializer,
    json,
  );
}

abstract class GUserProfileFragmentData_followers
    implements
        Built<
          GUserProfileFragmentData_followers,
          GUserProfileFragmentData_followersBuilder
        >,
        GUserProfileFragment_followers {
  GUserProfileFragmentData_followers._();

  factory GUserProfileFragmentData_followers([
    void Function(GUserProfileFragmentData_followersBuilder b) updates,
  ]) = _$GUserProfileFragmentData_followers;

  static void _initializeBuilder(GUserProfileFragmentData_followersBuilder b) =>
      b..G__typename = 'FollowerConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GUserProfileFragmentData_followers> get serializer =>
      _$gUserProfileFragmentDataFollowersSerializer;

  Map<String, dynamic> toJson() =>
      (_i2.serializers.serializeWith(
            GUserProfileFragmentData_followers.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GUserProfileFragmentData_followers? fromJson(
    Map<String, dynamic> json,
  ) => _i2.serializers.deserializeWith(
    GUserProfileFragmentData_followers.serializer,
    json,
  );
}

abstract class GUserProfileFragmentData_following
    implements
        Built<
          GUserProfileFragmentData_following,
          GUserProfileFragmentData_followingBuilder
        >,
        GUserProfileFragment_following {
  GUserProfileFragmentData_following._();

  factory GUserProfileFragmentData_following([
    void Function(GUserProfileFragmentData_followingBuilder b) updates,
  ]) = _$GUserProfileFragmentData_following;

  static void _initializeBuilder(GUserProfileFragmentData_followingBuilder b) =>
      b..G__typename = 'FollowingConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GUserProfileFragmentData_following> get serializer =>
      _$gUserProfileFragmentDataFollowingSerializer;

  Map<String, dynamic> toJson() =>
      (_i2.serializers.serializeWith(
            GUserProfileFragmentData_following.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GUserProfileFragmentData_following? fromJson(
    Map<String, dynamic> json,
  ) => _i2.serializers.deserializeWith(
    GUserProfileFragmentData_following.serializer,
    json,
  );
}
