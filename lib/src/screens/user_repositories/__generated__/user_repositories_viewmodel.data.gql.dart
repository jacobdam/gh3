// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart' as _i2;
import 'package:gh3/__generated__/serializers.gql.dart' as _i1;

part 'user_repositories_viewmodel.data.gql.g.dart';

abstract class GGetUserRepositoriesData
    implements
        Built<GGetUserRepositoriesData, GGetUserRepositoriesDataBuilder> {
  GGetUserRepositoriesData._();

  factory GGetUserRepositoriesData([
    void Function(GGetUserRepositoriesDataBuilder b) updates,
  ]) = _$GGetUserRepositoriesData;

  static void _initializeBuilder(GGetUserRepositoriesDataBuilder b) =>
      b..G__typename = 'Query';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetUserRepositoriesData_user? get user;
  static Serializer<GGetUserRepositoriesData> get serializer =>
      _$gGetUserRepositoriesDataSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(GGetUserRepositoriesData.serializer, this)
          as Map<String, dynamic>);

  static GGetUserRepositoriesData? fromJson(Map<String, dynamic> json) => _i1
      .serializers
      .deserializeWith(GGetUserRepositoriesData.serializer, json);
}

abstract class GGetUserRepositoriesData_user
    implements
        Built<
          GGetUserRepositoriesData_user,
          GGetUserRepositoriesData_userBuilder
        > {
  GGetUserRepositoriesData_user._();

  factory GGetUserRepositoriesData_user([
    void Function(GGetUserRepositoriesData_userBuilder b) updates,
  ]) = _$GGetUserRepositoriesData_user;

  static void _initializeBuilder(GGetUserRepositoriesData_userBuilder b) =>
      b..G__typename = 'User';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetUserRepositoriesData_user_repositories get repositories;
  static Serializer<GGetUserRepositoriesData_user> get serializer =>
      _$gGetUserRepositoriesDataUserSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetUserRepositoriesData_user.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetUserRepositoriesData_user? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetUserRepositoriesData_user.serializer,
        json,
      );
}

abstract class GGetUserRepositoriesData_user_repositories
    implements
        Built<
          GGetUserRepositoriesData_user_repositories,
          GGetUserRepositoriesData_user_repositoriesBuilder
        > {
  GGetUserRepositoriesData_user_repositories._();

  factory GGetUserRepositoriesData_user_repositories([
    void Function(GGetUserRepositoriesData_user_repositoriesBuilder b) updates,
  ]) = _$GGetUserRepositoriesData_user_repositories;

  static void _initializeBuilder(
    GGetUserRepositoriesData_user_repositoriesBuilder b,
  ) => b..G__typename = 'RepositoryConnection';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  int get totalCount;
  GGetUserRepositoriesData_user_repositories_pageInfo get pageInfo;
  BuiltList<GGetUserRepositoriesData_user_repositories_nodes?>? get nodes;
  static Serializer<GGetUserRepositoriesData_user_repositories>
  get serializer => _$gGetUserRepositoriesDataUserRepositoriesSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetUserRepositoriesData_user_repositories.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetUserRepositoriesData_user_repositories.serializer,
    json,
  );
}

abstract class GGetUserRepositoriesData_user_repositories_pageInfo
    implements
        Built<
          GGetUserRepositoriesData_user_repositories_pageInfo,
          GGetUserRepositoriesData_user_repositories_pageInfoBuilder
        > {
  GGetUserRepositoriesData_user_repositories_pageInfo._();

  factory GGetUserRepositoriesData_user_repositories_pageInfo([
    void Function(GGetUserRepositoriesData_user_repositories_pageInfoBuilder b)
    updates,
  ]) = _$GGetUserRepositoriesData_user_repositories_pageInfo;

  static void _initializeBuilder(
    GGetUserRepositoriesData_user_repositories_pageInfoBuilder b,
  ) => b..G__typename = 'PageInfo';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  bool get hasNextPage;
  bool get hasPreviousPage;
  String? get startCursor;
  String? get endCursor;
  static Serializer<GGetUserRepositoriesData_user_repositories_pageInfo>
  get serializer =>
      _$gGetUserRepositoriesDataUserRepositoriesPageInfoSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetUserRepositoriesData_user_repositories_pageInfo.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories_pageInfo? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetUserRepositoriesData_user_repositories_pageInfo.serializer,
    json,
  );
}

abstract class GGetUserRepositoriesData_user_repositories_nodes
    implements
        Built<
          GGetUserRepositoriesData_user_repositories_nodes,
          GGetUserRepositoriesData_user_repositories_nodesBuilder
        >,
        GUserRepositoriesFragment {
  GGetUserRepositoriesData_user_repositories_nodes._();

  factory GGetUserRepositoriesData_user_repositories_nodes([
    void Function(GGetUserRepositoriesData_user_repositories_nodesBuilder b)
    updates,
  ]) = _$GGetUserRepositoriesData_user_repositories_nodes;

  static void _initializeBuilder(
    GGetUserRepositoriesData_user_repositories_nodesBuilder b,
  ) => b..G__typename = 'Repository';

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
  _i2.GURI get url;
  @override
  bool get isPrivate;
  @override
  bool get isFork;
  @override
  bool get isTemplate;
  @override
  bool get isArchived;
  @override
  bool get isMirror;
  @override
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage?
  get primaryLanguage;
  @override
  int get stargazerCount;
  @override
  int get forkCount;
  @override
  _i2.GDateTime get updatedAt;
  @override
  _i2.GDateTime? get pushedAt;
  @override
  _i2.GDateTime get createdAt;
  @override
  GGetUserRepositoriesData_user_repositories_nodes_owner get owner;
  static Serializer<GGetUserRepositoriesData_user_repositories_nodes>
  get serializer => _$gGetUserRepositoriesDataUserRepositoriesNodesSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetUserRepositoriesData_user_repositories_nodes.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories_nodes? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetUserRepositoriesData_user_repositories_nodes.serializer,
    json,
  );
}

abstract class GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage
    implements
        Built<
          GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage,
          GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder
        >,
        GUserRepositoriesFragment_primaryLanguage {
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage._();

  factory GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage([
    void Function(
      GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder b,
    )
    updates,
  ]) = _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage;

  static void _initializeBuilder(
    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder b,
  ) => b..G__typename = 'Language';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get name;
  @override
  String? get color;
  static Serializer<
    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage
  >
  get serializer =>
      _$gGetUserRepositoriesDataUserRepositoriesNodesPrimaryLanguageSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage
                .serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage?
  fromJson(Map<String, dynamic> json) => _i1.serializers.deserializeWith(
    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage.serializer,
    json,
  );
}

abstract class GGetUserRepositoriesData_user_repositories_nodes_owner
    implements
        Built<
          GGetUserRepositoriesData_user_repositories_nodes_owner,
          GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder
        >,
        GUserRepositoriesFragment_owner {
  GGetUserRepositoriesData_user_repositories_nodes_owner._();

  factory GGetUserRepositoriesData_user_repositories_nodes_owner([
    void Function(
      GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder b,
    )
    updates,
  ]) = _$GGetUserRepositoriesData_user_repositories_nodes_owner;

  static void _initializeBuilder(
    GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder b,
  ) => b..G__typename = 'RepositoryOwner';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get login;
  @override
  _i2.GURI get avatarUrl;
  static Serializer<GGetUserRepositoriesData_user_repositories_nodes_owner>
  get serializer =>
      _$gGetUserRepositoriesDataUserRepositoriesNodesOwnerSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetUserRepositoriesData_user_repositories_nodes_owner.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetUserRepositoriesData_user_repositories_nodes_owner? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetUserRepositoriesData_user_repositories_nodes_owner.serializer,
    json,
  );
}

abstract class GGetViewerRepositoriesData
    implements
        Built<GGetViewerRepositoriesData, GGetViewerRepositoriesDataBuilder> {
  GGetViewerRepositoriesData._();

  factory GGetViewerRepositoriesData([
    void Function(GGetViewerRepositoriesDataBuilder b) updates,
  ]) = _$GGetViewerRepositoriesData;

  static void _initializeBuilder(GGetViewerRepositoriesDataBuilder b) =>
      b..G__typename = 'Query';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetViewerRepositoriesData_viewer get viewer;
  static Serializer<GGetViewerRepositoriesData> get serializer =>
      _$gGetViewerRepositoriesDataSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetViewerRepositoriesData.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetViewerRepositoriesData? fromJson(Map<String, dynamic> json) => _i1
      .serializers
      .deserializeWith(GGetViewerRepositoriesData.serializer, json);
}

abstract class GGetViewerRepositoriesData_viewer
    implements
        Built<
          GGetViewerRepositoriesData_viewer,
          GGetViewerRepositoriesData_viewerBuilder
        > {
  GGetViewerRepositoriesData_viewer._();

  factory GGetViewerRepositoriesData_viewer([
    void Function(GGetViewerRepositoriesData_viewerBuilder b) updates,
  ]) = _$GGetViewerRepositoriesData_viewer;

  static void _initializeBuilder(GGetViewerRepositoriesData_viewerBuilder b) =>
      b..G__typename = 'User';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GGetViewerRepositoriesData_viewer_repositories get repositories;
  static Serializer<GGetViewerRepositoriesData_viewer> get serializer =>
      _$gGetViewerRepositoriesDataViewerSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetViewerRepositoriesData_viewer.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetViewerRepositoriesData_viewer? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetViewerRepositoriesData_viewer.serializer,
    json,
  );
}

abstract class GGetViewerRepositoriesData_viewer_repositories
    implements
        Built<
          GGetViewerRepositoriesData_viewer_repositories,
          GGetViewerRepositoriesData_viewer_repositoriesBuilder
        > {
  GGetViewerRepositoriesData_viewer_repositories._();

  factory GGetViewerRepositoriesData_viewer_repositories([
    void Function(GGetViewerRepositoriesData_viewer_repositoriesBuilder b)
    updates,
  ]) = _$GGetViewerRepositoriesData_viewer_repositories;

  static void _initializeBuilder(
    GGetViewerRepositoriesData_viewer_repositoriesBuilder b,
  ) => b..G__typename = 'RepositoryConnection';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  int get totalCount;
  GGetViewerRepositoriesData_viewer_repositories_pageInfo get pageInfo;
  BuiltList<GGetViewerRepositoriesData_viewer_repositories_nodes?>? get nodes;
  static Serializer<GGetViewerRepositoriesData_viewer_repositories>
  get serializer => _$gGetViewerRepositoriesDataViewerRepositoriesSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetViewerRepositoriesData_viewer_repositories.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetViewerRepositoriesData_viewer_repositories? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetViewerRepositoriesData_viewer_repositories.serializer,
    json,
  );
}

abstract class GGetViewerRepositoriesData_viewer_repositories_pageInfo
    implements
        Built<
          GGetViewerRepositoriesData_viewer_repositories_pageInfo,
          GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder
        > {
  GGetViewerRepositoriesData_viewer_repositories_pageInfo._();

  factory GGetViewerRepositoriesData_viewer_repositories_pageInfo([
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder b,
    )
    updates,
  ]) = _$GGetViewerRepositoriesData_viewer_repositories_pageInfo;

  static void _initializeBuilder(
    GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder b,
  ) => b..G__typename = 'PageInfo';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  bool get hasNextPage;
  bool get hasPreviousPage;
  String? get startCursor;
  String? get endCursor;
  static Serializer<GGetViewerRepositoriesData_viewer_repositories_pageInfo>
  get serializer =>
      _$gGetViewerRepositoriesDataViewerRepositoriesPageInfoSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetViewerRepositoriesData_viewer_repositories_pageInfo.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetViewerRepositoriesData_viewer_repositories_pageInfo? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetViewerRepositoriesData_viewer_repositories_pageInfo.serializer,
    json,
  );
}

abstract class GGetViewerRepositoriesData_viewer_repositories_nodes
    implements
        Built<
          GGetViewerRepositoriesData_viewer_repositories_nodes,
          GGetViewerRepositoriesData_viewer_repositories_nodesBuilder
        >,
        GUserRepositoriesFragment {
  GGetViewerRepositoriesData_viewer_repositories_nodes._();

  factory GGetViewerRepositoriesData_viewer_repositories_nodes([
    void Function(GGetViewerRepositoriesData_viewer_repositories_nodesBuilder b)
    updates,
  ]) = _$GGetViewerRepositoriesData_viewer_repositories_nodes;

  static void _initializeBuilder(
    GGetViewerRepositoriesData_viewer_repositories_nodesBuilder b,
  ) => b..G__typename = 'Repository';

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
  _i2.GURI get url;
  @override
  bool get isPrivate;
  @override
  bool get isFork;
  @override
  bool get isTemplate;
  @override
  bool get isArchived;
  @override
  bool get isMirror;
  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage?
  get primaryLanguage;
  @override
  int get stargazerCount;
  @override
  int get forkCount;
  @override
  _i2.GDateTime get updatedAt;
  @override
  _i2.GDateTime? get pushedAt;
  @override
  _i2.GDateTime get createdAt;
  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_owner get owner;
  static Serializer<GGetViewerRepositoriesData_viewer_repositories_nodes>
  get serializer =>
      _$gGetViewerRepositoriesDataViewerRepositoriesNodesSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetViewerRepositoriesData_viewer_repositories_nodes.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetViewerRepositoriesData_viewer_repositories_nodes? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetViewerRepositoriesData_viewer_repositories_nodes.serializer,
    json,
  );
}

abstract class GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
    implements
        Built<
          GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage,
          GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder
        >,
        GUserRepositoriesFragment_primaryLanguage {
  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage._();

  factory GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage([
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder
      b,
    )
    updates,
  ]) = _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage;

  static void _initializeBuilder(
    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder
    b,
  ) => b..G__typename = 'Language';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get name;
  @override
  String? get color;
  static Serializer<
    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
  >
  get serializer =>
      _$gGetViewerRepositoriesDataViewerRepositoriesNodesPrimaryLanguageSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
                .serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage?
  fromJson(Map<String, dynamic> json) => _i1.serializers.deserializeWith(
    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
        .serializer,
    json,
  );
}

abstract class GGetViewerRepositoriesData_viewer_repositories_nodes_owner
    implements
        Built<
          GGetViewerRepositoriesData_viewer_repositories_nodes_owner,
          GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder
        >,
        GUserRepositoriesFragment_owner {
  GGetViewerRepositoriesData_viewer_repositories_nodes_owner._();

  factory GGetViewerRepositoriesData_viewer_repositories_nodes_owner([
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder b,
    )
    updates,
  ]) = _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner;

  static void _initializeBuilder(
    GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder b,
  ) => b..G__typename = 'RepositoryOwner';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get login;
  @override
  _i2.GURI get avatarUrl;
  static Serializer<GGetViewerRepositoriesData_viewer_repositories_nodes_owner>
  get serializer =>
      _$gGetViewerRepositoriesDataViewerRepositoriesNodesOwnerSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GGetViewerRepositoriesData_viewer_repositories_nodes_owner
                .serializer,
            this,
          )
          as Map<String, dynamic>);

  static GGetViewerRepositoriesData_viewer_repositories_nodes_owner? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GGetViewerRepositoriesData_viewer_repositories_nodes_owner.serializer,
    json,
  );
}

abstract class GUserRepositoriesFragment {
  String get G__typename;
  String get id;
  String get name;
  String get nameWithOwner;
  String? get description;
  _i2.GURI get url;
  bool get isPrivate;
  bool get isFork;
  bool get isTemplate;
  bool get isArchived;
  bool get isMirror;
  GUserRepositoriesFragment_primaryLanguage? get primaryLanguage;
  int get stargazerCount;
  int get forkCount;
  _i2.GDateTime get updatedAt;
  _i2.GDateTime? get pushedAt;
  _i2.GDateTime get createdAt;
  GUserRepositoriesFragment_owner get owner;
}

abstract class GUserRepositoriesFragment_primaryLanguage {
  String get G__typename;
  String get name;
  String? get color;
}

abstract class GUserRepositoriesFragment_owner {
  String get G__typename;
  String get login;
  _i2.GURI get avatarUrl;
}

abstract class GUserRepositoriesFragmentData
    implements
        Built<
          GUserRepositoriesFragmentData,
          GUserRepositoriesFragmentDataBuilder
        >,
        GUserRepositoriesFragment {
  GUserRepositoriesFragmentData._();

  factory GUserRepositoriesFragmentData([
    void Function(GUserRepositoriesFragmentDataBuilder b) updates,
  ]) = _$GUserRepositoriesFragmentData;

  static void _initializeBuilder(GUserRepositoriesFragmentDataBuilder b) =>
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
  _i2.GURI get url;
  @override
  bool get isPrivate;
  @override
  bool get isFork;
  @override
  bool get isTemplate;
  @override
  bool get isArchived;
  @override
  bool get isMirror;
  @override
  GUserRepositoriesFragmentData_primaryLanguage? get primaryLanguage;
  @override
  int get stargazerCount;
  @override
  int get forkCount;
  @override
  _i2.GDateTime get updatedAt;
  @override
  _i2.GDateTime? get pushedAt;
  @override
  _i2.GDateTime get createdAt;
  @override
  GUserRepositoriesFragmentData_owner get owner;
  static Serializer<GUserRepositoriesFragmentData> get serializer =>
      _$gUserRepositoriesFragmentDataSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GUserRepositoriesFragmentData.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GUserRepositoriesFragmentData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUserRepositoriesFragmentData.serializer,
        json,
      );
}

abstract class GUserRepositoriesFragmentData_primaryLanguage
    implements
        Built<
          GUserRepositoriesFragmentData_primaryLanguage,
          GUserRepositoriesFragmentData_primaryLanguageBuilder
        >,
        GUserRepositoriesFragment_primaryLanguage {
  GUserRepositoriesFragmentData_primaryLanguage._();

  factory GUserRepositoriesFragmentData_primaryLanguage([
    void Function(GUserRepositoriesFragmentData_primaryLanguageBuilder b)
    updates,
  ]) = _$GUserRepositoriesFragmentData_primaryLanguage;

  static void _initializeBuilder(
    GUserRepositoriesFragmentData_primaryLanguageBuilder b,
  ) => b..G__typename = 'Language';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get name;
  @override
  String? get color;
  static Serializer<GUserRepositoriesFragmentData_primaryLanguage>
  get serializer => _$gUserRepositoriesFragmentDataPrimaryLanguageSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GUserRepositoriesFragmentData_primaryLanguage.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GUserRepositoriesFragmentData_primaryLanguage? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GUserRepositoriesFragmentData_primaryLanguage.serializer,
    json,
  );
}

abstract class GUserRepositoriesFragmentData_owner
    implements
        Built<
          GUserRepositoriesFragmentData_owner,
          GUserRepositoriesFragmentData_ownerBuilder
        >,
        GUserRepositoriesFragment_owner {
  GUserRepositoriesFragmentData_owner._();

  factory GUserRepositoriesFragmentData_owner([
    void Function(GUserRepositoriesFragmentData_ownerBuilder b) updates,
  ]) = _$GUserRepositoriesFragmentData_owner;

  static void _initializeBuilder(
    GUserRepositoriesFragmentData_ownerBuilder b,
  ) => b..G__typename = 'RepositoryOwner';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get login;
  @override
  _i2.GURI get avatarUrl;
  static Serializer<GUserRepositoriesFragmentData_owner> get serializer =>
      _$gUserRepositoriesFragmentDataOwnerSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(
            GUserRepositoriesFragmentData_owner.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GUserRepositoriesFragmentData_owner? fromJson(
    Map<String, dynamic> json,
  ) => _i1.serializers.deserializeWith(
    GUserRepositoriesFragmentData_owner.serializer,
    json,
  );
}
