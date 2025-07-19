// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart' as _i3;
import 'package:gh3/__generated__/serializers.gql.dart' as _i1;
import 'package:gh3/src/widgets/user_card/__generated__/user_card.data.gql.dart'
    as _i2;

part 'home_viewmodel.data.gql.g.dart';

abstract class GGetFollowingData
    implements Built<GGetFollowingData, GGetFollowingDataBuilder> {
  GGetFollowingData._();

  factory GGetFollowingData([
    void Function(GGetFollowingDataBuilder b) updates,
  ]) = _$GGetFollowingData;

  static void _initializeBuilder(GGetFollowingDataBuilder b) =>
      b..G__typename = 'Query';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetFollowingData_viewer get viewer;
  static Serializer<GGetFollowingData> get serializer =>
      _$gGetFollowingDataSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(GGetFollowingData.serializer, this)
          as Map<String, dynamic>);

  static GGetFollowingData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(GGetFollowingData.serializer, json);
}

abstract class GGetFollowingData_viewer
    implements
        Built<GGetFollowingData_viewer, GGetFollowingData_viewerBuilder> {
  GGetFollowingData_viewer._();

  factory GGetFollowingData_viewer([
    void Function(GGetFollowingData_viewerBuilder b) updates,
  ]) = _$GGetFollowingData_viewer;

  static void _initializeBuilder(GGetFollowingData_viewerBuilder b) =>
      b..G__typename = 'User';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetFollowingData_viewer_following get following;
  static Serializer<GGetFollowingData_viewer> get serializer =>
      _$gGetFollowingDataViewerSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(GGetFollowingData_viewer.serializer, this)
          as Map<String, dynamic>);

  static GGetFollowingData_viewer? fromJson(Map<String, dynamic> json) => _i1
      .serializers
      .deserializeWith(GGetFollowingData_viewer.serializer, json);
}

abstract class GGetFollowingData_viewer_following
    implements
        Built<
          GGetFollowingData_viewer_following,
          GGetFollowingData_viewer_followingBuilder
        > {
  GGetFollowingData_viewer_following._();

  factory GGetFollowingData_viewer_following([
    void Function(GGetFollowingData_viewer_followingBuilder b) updates,
  ]) = _$GGetFollowingData_viewer_following;

  static void _initializeBuilder(GGetFollowingData_viewer_followingBuilder b) =>
      b..G__typename = 'FollowingConnection';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  BuiltList<GGetFollowingData_viewer_following_nodes?>? get nodes;
  GGetFollowingData_viewer_following_pageInfo get pageInfo;
  static Serializer<GGetFollowingData_viewer_following> get serializer =>
      _$gGetFollowingDataViewerFollowingSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetFollowingData_viewer_following.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetFollowingData_viewer_following? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetFollowingData_viewer_following.serializer,
    json,
  );
}

abstract class GGetFollowingData_viewer_following_nodes
    implements
        Built<
          GGetFollowingData_viewer_following_nodes,
          GGetFollowingData_viewer_following_nodesBuilder
        >,
        _i2.GUserCardFragment {
  GGetFollowingData_viewer_following_nodes._();

  factory GGetFollowingData_viewer_following_nodes([
    void Function(GGetFollowingData_viewer_following_nodesBuilder b) updates,
  ]) = _$GGetFollowingData_viewer_following_nodes;

  static void _initializeBuilder(
    GGetFollowingData_viewer_following_nodesBuilder b,
  ) => b..G__typename = 'User';

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
  GGetFollowingData_viewer_following_nodes_repositories get repositories;
  @override
  GGetFollowingData_viewer_following_nodes_followers get followers;
  static Serializer<GGetFollowingData_viewer_following_nodes> get serializer =>
      _$gGetFollowingDataViewerFollowingNodesSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetFollowingData_viewer_following_nodes.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetFollowingData_viewer_following_nodes? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetFollowingData_viewer_following_nodes.serializer,
    json,
  );
}

abstract class GGetFollowingData_viewer_following_nodes_repositories
    implements
        Built<
          GGetFollowingData_viewer_following_nodes_repositories,
          GGetFollowingData_viewer_following_nodes_repositoriesBuilder
        >,
        _i2.GUserCardFragment_repositories {
  GGetFollowingData_viewer_following_nodes_repositories._();

  factory GGetFollowingData_viewer_following_nodes_repositories([
    void Function(
      GGetFollowingData_viewer_following_nodes_repositoriesBuilder b,
    )
    updates,
  ]) = _$GGetFollowingData_viewer_following_nodes_repositories;

  static void _initializeBuilder(
    GGetFollowingData_viewer_following_nodes_repositoriesBuilder b,
  ) => b..G__typename = 'RepositoryConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GGetFollowingData_viewer_following_nodes_repositories>
  get serializer =>
      _$gGetFollowingDataViewerFollowingNodesRepositoriesSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetFollowingData_viewer_following_nodes_repositories.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetFollowingData_viewer_following_nodes_repositories? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetFollowingData_viewer_following_nodes_repositories.serializer,
    json,
  );
}

abstract class GGetFollowingData_viewer_following_nodes_followers
    implements
        Built<
          GGetFollowingData_viewer_following_nodes_followers,
          GGetFollowingData_viewer_following_nodes_followersBuilder
        >,
        _i2.GUserCardFragment_followers {
  GGetFollowingData_viewer_following_nodes_followers._();

  factory GGetFollowingData_viewer_following_nodes_followers([
    void Function(GGetFollowingData_viewer_following_nodes_followersBuilder b)
    updates,
  ]) = _$GGetFollowingData_viewer_following_nodes_followers;

  static void _initializeBuilder(
    GGetFollowingData_viewer_following_nodes_followersBuilder b,
  ) => b..G__typename = 'FollowerConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GGetFollowingData_viewer_following_nodes_followers>
  get serializer => _$gGetFollowingDataViewerFollowingNodesFollowersSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetFollowingData_viewer_following_nodes_followers.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetFollowingData_viewer_following_nodes_followers? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetFollowingData_viewer_following_nodes_followers.serializer,
    json,
  );
}

abstract class GGetFollowingData_viewer_following_pageInfo
    implements
        Built<
          GGetFollowingData_viewer_following_pageInfo,
          GGetFollowingData_viewer_following_pageInfoBuilder
        > {
  GGetFollowingData_viewer_following_pageInfo._();

  factory GGetFollowingData_viewer_following_pageInfo([
    void Function(GGetFollowingData_viewer_following_pageInfoBuilder b) updates,
  ]) = _$GGetFollowingData_viewer_following_pageInfo;

  static void _initializeBuilder(
    GGetFollowingData_viewer_following_pageInfoBuilder b,
  ) => b..G__typename = 'PageInfo';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  bool get hasNextPage;
  String? get endCursor;
  static Serializer<GGetFollowingData_viewer_following_pageInfo>
  get serializer => _$gGetFollowingDataViewerFollowingPageInfoSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetFollowingData_viewer_following_pageInfo.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetFollowingData_viewer_following_pageInfo? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetFollowingData_viewer_following_pageInfo.serializer,
    json,
  );
}
