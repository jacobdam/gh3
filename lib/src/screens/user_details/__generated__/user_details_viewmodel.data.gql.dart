// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart' as _i3;
import 'package:gh3/__generated__/serializers.gql.dart' as _i1;
import 'package:gh3/src/widgets/repository_card/__generated__/repository_card.data.gql.dart'
    as _i4;
import 'package:gh3/src/widgets/user_profile/__generated__/user_profile.data.gql.dart'
    as _i2;

part 'user_details_viewmodel.data.gql.g.dart';

abstract class GGetUserDetailsData
    implements Built<GGetUserDetailsData, GGetUserDetailsDataBuilder> {
  GGetUserDetailsData._();

  factory GGetUserDetailsData(
          [void Function(GGetUserDetailsDataBuilder b) updates]) =
      _$GGetUserDetailsData;

  static void _initializeBuilder(GGetUserDetailsDataBuilder b) =>
      b..G__typename = 'Query';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetUserDetailsData_user? get user;
  static Serializer<GGetUserDetailsData> get serializer =>
      _$gGetUserDetailsDataSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserDetailsData.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserDetailsData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserDetailsData.serializer,
        json,
      );
}

abstract class GGetUserDetailsData_user
    implements
        Built<GGetUserDetailsData_user, GGetUserDetailsData_userBuilder>,
        _i2.GUserProfileFragment,
        GUserStatusFragment {
  GGetUserDetailsData_user._();

  factory GGetUserDetailsData_user(
          [void Function(GGetUserDetailsData_userBuilder b) updates]) =
      _$GGetUserDetailsData_user;

  static void _initializeBuilder(GGetUserDetailsData_userBuilder b) =>
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
  _i3.GURI? get websiteUrl;
  @override
  _i3.GURI get avatarUrl;
  @override
  _i3.GURI get url;
  @override
  GGetUserDetailsData_user_repositories get repositories;
  @override
  GGetUserDetailsData_user_followers get followers;
  @override
  GGetUserDetailsData_user_following get following;
  @override
  _i3.GDateTime get createdAt;
  @override
  _i3.GDateTime get updatedAt;
  @override
  GGetUserDetailsData_user_status? get status;
  GGetUserDetailsData_user_starredRepositories get starredRepositories;
  GGetUserDetailsData_user_organizations get organizations;
  static Serializer<GGetUserDetailsData_user> get serializer =>
      _$gGetUserDetailsDataUserSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserDetailsData_user.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserDetailsData_user? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserDetailsData_user.serializer,
        json,
      );
}

abstract class GGetUserDetailsData_user_repositories
    implements
        Built<GGetUserDetailsData_user_repositories,
            GGetUserDetailsData_user_repositoriesBuilder>,
        _i2.GUserProfileFragment_repositories {
  GGetUserDetailsData_user_repositories._();

  factory GGetUserDetailsData_user_repositories(
      [void Function(GGetUserDetailsData_user_repositoriesBuilder b)
          updates]) = _$GGetUserDetailsData_user_repositories;

  static void _initializeBuilder(
          GGetUserDetailsData_user_repositoriesBuilder b) =>
      b..G__typename = 'RepositoryConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GGetUserDetailsData_user_repositories> get serializer =>
      _$gGetUserDetailsDataUserRepositoriesSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserDetailsData_user_repositories.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserDetailsData_user_repositories? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserDetailsData_user_repositories.serializer,
        json,
      );
}

abstract class GGetUserDetailsData_user_followers
    implements
        Built<GGetUserDetailsData_user_followers,
            GGetUserDetailsData_user_followersBuilder>,
        _i2.GUserProfileFragment_followers {
  GGetUserDetailsData_user_followers._();

  factory GGetUserDetailsData_user_followers(
      [void Function(GGetUserDetailsData_user_followersBuilder b)
          updates]) = _$GGetUserDetailsData_user_followers;

  static void _initializeBuilder(GGetUserDetailsData_user_followersBuilder b) =>
      b..G__typename = 'FollowerConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GGetUserDetailsData_user_followers> get serializer =>
      _$gGetUserDetailsDataUserFollowersSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserDetailsData_user_followers.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserDetailsData_user_followers? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserDetailsData_user_followers.serializer,
        json,
      );
}

abstract class GGetUserDetailsData_user_following
    implements
        Built<GGetUserDetailsData_user_following,
            GGetUserDetailsData_user_followingBuilder>,
        _i2.GUserProfileFragment_following {
  GGetUserDetailsData_user_following._();

  factory GGetUserDetailsData_user_following(
      [void Function(GGetUserDetailsData_user_followingBuilder b)
          updates]) = _$GGetUserDetailsData_user_following;

  static void _initializeBuilder(GGetUserDetailsData_user_followingBuilder b) =>
      b..G__typename = 'FollowingConnection';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  int get totalCount;
  static Serializer<GGetUserDetailsData_user_following> get serializer =>
      _$gGetUserDetailsDataUserFollowingSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserDetailsData_user_following.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserDetailsData_user_following? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserDetailsData_user_following.serializer,
        json,
      );
}

abstract class GGetUserDetailsData_user_status
    implements
        Built<GGetUserDetailsData_user_status,
            GGetUserDetailsData_user_statusBuilder>,
        GUserStatusFragment_status {
  GGetUserDetailsData_user_status._();

  factory GGetUserDetailsData_user_status(
          [void Function(GGetUserDetailsData_user_statusBuilder b) updates]) =
      _$GGetUserDetailsData_user_status;

  static void _initializeBuilder(GGetUserDetailsData_user_statusBuilder b) =>
      b..G__typename = 'UserStatus';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String? get message;
  @override
  String? get emoji;
  @override
  _i3.GDateTime get createdAt;
  static Serializer<GGetUserDetailsData_user_status> get serializer =>
      _$gGetUserDetailsDataUserStatusSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserDetailsData_user_status.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserDetailsData_user_status? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserDetailsData_user_status.serializer,
        json,
      );
}

abstract class GGetUserDetailsData_user_starredRepositories
    implements
        Built<GGetUserDetailsData_user_starredRepositories,
            GGetUserDetailsData_user_starredRepositoriesBuilder> {
  GGetUserDetailsData_user_starredRepositories._();

  factory GGetUserDetailsData_user_starredRepositories(
      [void Function(GGetUserDetailsData_user_starredRepositoriesBuilder b)
          updates]) = _$GGetUserDetailsData_user_starredRepositories;

  static void _initializeBuilder(
          GGetUserDetailsData_user_starredRepositoriesBuilder b) =>
      b..G__typename = 'StarredRepositoryConnection';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  int get totalCount;
  static Serializer<GGetUserDetailsData_user_starredRepositories>
      get serializer => _$gGetUserDetailsDataUserStarredRepositoriesSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserDetailsData_user_starredRepositories.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserDetailsData_user_starredRepositories? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserDetailsData_user_starredRepositories.serializer,
        json,
      );
}

abstract class GGetUserDetailsData_user_organizations
    implements
        Built<GGetUserDetailsData_user_organizations,
            GGetUserDetailsData_user_organizationsBuilder> {
  GGetUserDetailsData_user_organizations._();

  factory GGetUserDetailsData_user_organizations(
      [void Function(GGetUserDetailsData_user_organizationsBuilder b)
          updates]) = _$GGetUserDetailsData_user_organizations;

  static void _initializeBuilder(
          GGetUserDetailsData_user_organizationsBuilder b) =>
      b..G__typename = 'OrganizationConnection';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  int get totalCount;
  static Serializer<GGetUserDetailsData_user_organizations> get serializer =>
      _$gGetUserDetailsDataUserOrganizationsSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserDetailsData_user_organizations.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserDetailsData_user_organizations? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserDetailsData_user_organizations.serializer,
        json,
      );
}

abstract class GGetUserRepositoriesData
    implements
        Built<GGetUserRepositoriesData, GGetUserRepositoriesDataBuilder> {
  GGetUserRepositoriesData._();

  factory GGetUserRepositoriesData(
          [void Function(GGetUserRepositoriesDataBuilder b) updates]) =
      _$GGetUserRepositoriesData;

  static void _initializeBuilder(GGetUserRepositoriesDataBuilder b) =>
      b..G__typename = 'Query';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetUserRepositoriesData_user? get user;
  static Serializer<GGetUserRepositoriesData> get serializer =>
      _$gGetUserRepositoriesDataSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserRepositoriesData.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserRepositoriesData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserRepositoriesData.serializer,
        json,
      );
}

abstract class GGetUserRepositoriesData_user
    implements
        Built<GGetUserRepositoriesData_user,
            GGetUserRepositoriesData_userBuilder> {
  GGetUserRepositoriesData_user._();

  factory GGetUserRepositoriesData_user(
          [void Function(GGetUserRepositoriesData_userBuilder b) updates]) =
      _$GGetUserRepositoriesData_user;

  static void _initializeBuilder(GGetUserRepositoriesData_userBuilder b) =>
      b..G__typename = 'User';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetUserRepositoriesData_user_repositories get repositories;
  static Serializer<GGetUserRepositoriesData_user> get serializer =>
      _$gGetUserRepositoriesDataUserSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserRepositoriesData_user.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserRepositoriesData_user? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserRepositoriesData_user.serializer,
        json,
      );
}

abstract class GGetUserRepositoriesData_user_repositories
    implements
        Built<GGetUserRepositoriesData_user_repositories,
            GGetUserRepositoriesData_user_repositoriesBuilder> {
  GGetUserRepositoriesData_user_repositories._();

  factory GGetUserRepositoriesData_user_repositories(
      [void Function(GGetUserRepositoriesData_user_repositoriesBuilder b)
          updates]) = _$GGetUserRepositoriesData_user_repositories;

  static void _initializeBuilder(
          GGetUserRepositoriesData_user_repositoriesBuilder b) =>
      b..G__typename = 'RepositoryConnection';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  BuiltList<GGetUserRepositoriesData_user_repositories_nodes?>? get nodes;
  GGetUserRepositoriesData_user_repositories_pageInfo get pageInfo;
  static Serializer<GGetUserRepositoriesData_user_repositories>
      get serializer => _$gGetUserRepositoriesDataUserRepositoriesSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserRepositoriesData_user_repositories.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserRepositoriesData_user_repositories.serializer,
        json,
      );
}

abstract class GGetUserRepositoriesData_user_repositories_nodes
    implements
        Built<GGetUserRepositoriesData_user_repositories_nodes,
            GGetUserRepositoriesData_user_repositories_nodesBuilder>,
        _i4.GRepositoryCardFragment {
  GGetUserRepositoriesData_user_repositories_nodes._();

  factory GGetUserRepositoriesData_user_repositories_nodes(
      [void Function(GGetUserRepositoriesData_user_repositories_nodesBuilder b)
          updates]) = _$GGetUserRepositoriesData_user_repositories_nodes;

  static void _initializeBuilder(
          GGetUserRepositoriesData_user_repositories_nodesBuilder b) =>
      b..G__typename = 'Repository';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get id;
  @override
  String get name;
  @override
  String get nameWithOwner;
  @override
  String? get description;
  @override
  int get stargazerCount;
  @override
  int get forkCount;
  @override
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage?
      get primaryLanguage;
  @override
  _i3.GDateTime get updatedAt;
  @override
  bool get isPrivate;
  static Serializer<GGetUserRepositoriesData_user_repositories_nodes>
      get serializer =>
          _$gGetUserRepositoriesDataUserRepositoriesNodesSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserRepositoriesData_user_repositories_nodes.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories_nodes? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserRepositoriesData_user_repositories_nodes.serializer,
        json,
      );
}

abstract class GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage
    implements
        Built<GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage,
            GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder>,
        _i4.GRepositoryCardFragment_primaryLanguage {
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage._();

  factory GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage(
          [void Function(
                  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder
                      b)
              updates]) =
      _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage;

  static void _initializeBuilder(
          GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder
              b) =>
      b..G__typename = 'Language';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get name;
  @override
  String? get color;
  static Serializer<
          GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage>
      get serializer =>
          _$gGetUserRepositoriesDataUserRepositoriesNodesPrimaryLanguageSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage
            .serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage?
      fromJson(Map<String, dynamic> json) => _i1.serializers.deserializeWith(
            GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage
                .serializer,
            json,
          );
}

abstract class GGetUserRepositoriesData_user_repositories_pageInfo
    implements
        Built<GGetUserRepositoriesData_user_repositories_pageInfo,
            GGetUserRepositoriesData_user_repositories_pageInfoBuilder> {
  GGetUserRepositoriesData_user_repositories_pageInfo._();

  factory GGetUserRepositoriesData_user_repositories_pageInfo(
      [void Function(
              GGetUserRepositoriesData_user_repositories_pageInfoBuilder b)
          updates]) = _$GGetUserRepositoriesData_user_repositories_pageInfo;

  static void _initializeBuilder(
          GGetUserRepositoriesData_user_repositories_pageInfoBuilder b) =>
      b..G__typename = 'PageInfo';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  bool get hasNextPage;
  String? get endCursor;
  static Serializer<GGetUserRepositoriesData_user_repositories_pageInfo>
      get serializer =>
          _$gGetUserRepositoriesDataUserRepositoriesPageInfoSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetUserRepositoriesData_user_repositories_pageInfo.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories_pageInfo? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserRepositoriesData_user_repositories_pageInfo.serializer,
        json,
      );
}

abstract class GUserStatusFragment {
  String get G__typename;
  GUserStatusFragment_status? get status;
}

abstract class GUserStatusFragment_status {
  String get G__typename;
  String? get message;
  String? get emoji;
  _i3.GDateTime get createdAt;
}

abstract class GUserStatusFragmentData
    implements
        Built<GUserStatusFragmentData, GUserStatusFragmentDataBuilder>,
        GUserStatusFragment {
  GUserStatusFragmentData._();

  factory GUserStatusFragmentData(
          [void Function(GUserStatusFragmentDataBuilder b) updates]) =
      _$GUserStatusFragmentData;

  static void _initializeBuilder(GUserStatusFragmentDataBuilder b) =>
      b..G__typename = 'User';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  GUserStatusFragmentData_status? get status;
  static Serializer<GUserStatusFragmentData> get serializer =>
      _$gUserStatusFragmentDataSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUserStatusFragmentData.serializer,
        this,
      ) as Map<String, dynamic>);

  static GUserStatusFragmentData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUserStatusFragmentData.serializer,
        json,
      );
}

abstract class GUserStatusFragmentData_status
    implements
        Built<GUserStatusFragmentData_status,
            GUserStatusFragmentData_statusBuilder>,
        GUserStatusFragment_status {
  GUserStatusFragmentData_status._();

  factory GUserStatusFragmentData_status(
          [void Function(GUserStatusFragmentData_statusBuilder b) updates]) =
      _$GUserStatusFragmentData_status;

  static void _initializeBuilder(GUserStatusFragmentData_statusBuilder b) =>
      b..G__typename = 'UserStatus';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String? get message;
  @override
  String? get emoji;
  @override
  _i3.GDateTime get createdAt;
  static Serializer<GUserStatusFragmentData_status> get serializer =>
      _$gUserStatusFragmentDataStatusSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUserStatusFragmentData_status.serializer,
        this,
      ) as Map<String, dynamic>);

  static GUserStatusFragmentData_status? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUserStatusFragmentData_status.serializer,
        json,
      );
}
