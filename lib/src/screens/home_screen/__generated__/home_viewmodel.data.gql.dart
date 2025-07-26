// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart' as _i3;
import 'package:gh3/__generated__/serializers.gql.dart' as _i1;
import 'package:gh3/src/widgets/user_card/__generated__/user_card.data.gql.dart'
    as _i2;

part 'home_viewmodel.data.gql.g.dart';

abstract class GGetCurrentUserData
    implements Built<GGetCurrentUserData, GGetCurrentUserDataBuilder> {
  GGetCurrentUserData._();

  factory GGetCurrentUserData(
          [void Function(GGetCurrentUserDataBuilder b) updates]) =
      _$GGetCurrentUserData;

  static void _initializeBuilder(GGetCurrentUserDataBuilder b) =>
      b..G__typename = 'Query';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetCurrentUserData_viewer get viewer;
  static Serializer<GGetCurrentUserData> get serializer =>
      _$gGetCurrentUserDataSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetCurrentUserData.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetCurrentUserData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetCurrentUserData.serializer,
        json,
      );
}

abstract class GGetCurrentUserData_viewer
    implements
        Built<GGetCurrentUserData_viewer, GGetCurrentUserData_viewerBuilder>,
        _i2.GUserCardFragment {
  GGetCurrentUserData_viewer._();

  factory GGetCurrentUserData_viewer(
          [void Function(GGetCurrentUserData_viewerBuilder b) updates]) =
      _$GGetCurrentUserData_viewer;

  static void _initializeBuilder(GGetCurrentUserData_viewerBuilder b) =>
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
  _i3.GURI get avatarUrl;
  @override
  String? get bio;
  @override
  GGetCurrentUserData_viewer_repositories get repositories;
  @override
  GGetCurrentUserData_viewer_followers get followers;
  static Serializer<GGetCurrentUserData_viewer> get serializer =>
      _$gGetCurrentUserDataViewerSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetCurrentUserData_viewer.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetCurrentUserData_viewer? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetCurrentUserData_viewer.serializer,
        json,
      );
}

abstract class GGetCurrentUserData_viewer_repositories
    implements
        Built<GGetCurrentUserData_viewer_repositories,
            GGetCurrentUserData_viewer_repositoriesBuilder>,
        _i2.GUserCardFragment_repositories {
  GGetCurrentUserData_viewer_repositories._();

  factory GGetCurrentUserData_viewer_repositories(
      [void Function(GGetCurrentUserData_viewer_repositoriesBuilder b)
          updates]) = _$GGetCurrentUserData_viewer_repositories;

  static void _initializeBuilder(
          GGetCurrentUserData_viewer_repositoriesBuilder b) =>
      b..G__typename = 'RepositoryConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GGetCurrentUserData_viewer_repositories> get serializer =>
      _$gGetCurrentUserDataViewerRepositoriesSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetCurrentUserData_viewer_repositories.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetCurrentUserData_viewer_repositories? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetCurrentUserData_viewer_repositories.serializer,
        json,
      );
}

abstract class GGetCurrentUserData_viewer_followers
    implements
        Built<GGetCurrentUserData_viewer_followers,
            GGetCurrentUserData_viewer_followersBuilder>,
        _i2.GUserCardFragment_followers {
  GGetCurrentUserData_viewer_followers._();

  factory GGetCurrentUserData_viewer_followers(
      [void Function(GGetCurrentUserData_viewer_followersBuilder b)
          updates]) = _$GGetCurrentUserData_viewer_followers;

  static void _initializeBuilder(
          GGetCurrentUserData_viewer_followersBuilder b) =>
      b..G__typename = 'FollowerConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GGetCurrentUserData_viewer_followers> get serializer =>
      _$gGetCurrentUserDataViewerFollowersSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetCurrentUserData_viewer_followers.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetCurrentUserData_viewer_followers? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetCurrentUserData_viewer_followers.serializer,
        json,
      );
}
