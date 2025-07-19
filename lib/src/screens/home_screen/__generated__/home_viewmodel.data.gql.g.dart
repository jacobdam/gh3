// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetFollowingData> _$gGetFollowingDataSerializer =
    _$GGetFollowingDataSerializer();
Serializer<GGetFollowingData_viewer> _$gGetFollowingDataViewerSerializer =
    _$GGetFollowingData_viewerSerializer();
Serializer<GGetFollowingData_viewer_following>
_$gGetFollowingDataViewerFollowingSerializer =
    _$GGetFollowingData_viewer_followingSerializer();
Serializer<GGetFollowingData_viewer_following_nodes>
_$gGetFollowingDataViewerFollowingNodesSerializer =
    _$GGetFollowingData_viewer_following_nodesSerializer();
Serializer<GGetFollowingData_viewer_following_nodes_repositories>
_$gGetFollowingDataViewerFollowingNodesRepositoriesSerializer =
    _$GGetFollowingData_viewer_following_nodes_repositoriesSerializer();
Serializer<GGetFollowingData_viewer_following_nodes_followers>
_$gGetFollowingDataViewerFollowingNodesFollowersSerializer =
    _$GGetFollowingData_viewer_following_nodes_followersSerializer();
Serializer<GGetFollowingData_viewer_following_pageInfo>
_$gGetFollowingDataViewerFollowingPageInfoSerializer =
    _$GGetFollowingData_viewer_following_pageInfoSerializer();

class _$GGetFollowingDataSerializer
    implements StructuredSerializer<GGetFollowingData> {
  @override
  final Iterable<Type> types = const [GGetFollowingData, _$GGetFollowingData];
  @override
  final String wireName = 'GGetFollowingData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetFollowingData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'viewer',
      serializers.serialize(
        object.viewer,
        specifiedType: const FullType(GGetFollowingData_viewer),
      ),
    ];

    return result;
  }

  @override
  GGetFollowingData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetFollowingDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'viewer':
          result.viewer.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(GGetFollowingData_viewer),
                )!
                as GGetFollowingData_viewer,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetFollowingData_viewerSerializer
    implements StructuredSerializer<GGetFollowingData_viewer> {
  @override
  final Iterable<Type> types = const [
    GGetFollowingData_viewer,
    _$GGetFollowingData_viewer,
  ];
  @override
  final String wireName = 'GGetFollowingData_viewer';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetFollowingData_viewer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'following',
      serializers.serialize(
        object.following,
        specifiedType: const FullType(GGetFollowingData_viewer_following),
      ),
    ];

    return result;
  }

  @override
  GGetFollowingData_viewer deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetFollowingData_viewerBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'following':
          result.following.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetFollowingData_viewer_following,
                  ),
                )!
                as GGetFollowingData_viewer_following,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetFollowingData_viewer_followingSerializer
    implements StructuredSerializer<GGetFollowingData_viewer_following> {
  @override
  final Iterable<Type> types = const [
    GGetFollowingData_viewer_following,
    _$GGetFollowingData_viewer_following,
  ];
  @override
  final String wireName = 'GGetFollowingData_viewer_following';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetFollowingData_viewer_following object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'pageInfo',
      serializers.serialize(
        object.pageInfo,
        specifiedType: const FullType(
          GGetFollowingData_viewer_following_pageInfo,
        ),
      ),
    ];
    Object? value;
    value = object.nodes;
    if (value != null) {
      result
        ..add('nodes')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType.nullable(GGetFollowingData_viewer_following_nodes),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  GGetFollowingData_viewer_following deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetFollowingData_viewer_followingBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'nodes':
          result.nodes.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType.nullable(
                      GGetFollowingData_viewer_following_nodes,
                    ),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'pageInfo':
          result.pageInfo.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetFollowingData_viewer_following_pageInfo,
                  ),
                )!
                as GGetFollowingData_viewer_following_pageInfo,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetFollowingData_viewer_following_nodesSerializer
    implements StructuredSerializer<GGetFollowingData_viewer_following_nodes> {
  @override
  final Iterable<Type> types = const [
    GGetFollowingData_viewer_following_nodes,
    _$GGetFollowingData_viewer_following_nodes,
  ];
  @override
  final String wireName = 'GGetFollowingData_viewer_following_nodes';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetFollowingData_viewer_following_nodes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'login',
      serializers.serialize(
        object.login,
        specifiedType: const FullType(String),
      ),
      'avatarUrl',
      serializers.serialize(
        object.avatarUrl,
        specifiedType: const FullType(_i3.GURI),
      ),
      'repositories',
      serializers.serialize(
        object.repositories,
        specifiedType: const FullType(
          GGetFollowingData_viewer_following_nodes_repositories,
        ),
      ),
      'followers',
      serializers.serialize(
        object.followers,
        specifiedType: const FullType(
          GGetFollowingData_viewer_following_nodes_followers,
        ),
      ),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.bio;
    if (value != null) {
      result
        ..add('bio')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GGetFollowingData_viewer_following_nodes deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetFollowingData_viewer_following_nodesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'login':
          result.login =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'avatarUrl':
          result.avatarUrl.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i3.GURI),
                )!
                as _i3.GURI,
          );
          break;
        case 'bio':
          result.bio =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'repositories':
          result.repositories.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetFollowingData_viewer_following_nodes_repositories,
                  ),
                )!
                as GGetFollowingData_viewer_following_nodes_repositories,
          );
          break;
        case 'followers':
          result.followers.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetFollowingData_viewer_following_nodes_followers,
                  ),
                )!
                as GGetFollowingData_viewer_following_nodes_followers,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetFollowingData_viewer_following_nodes_repositoriesSerializer
    implements
        StructuredSerializer<
          GGetFollowingData_viewer_following_nodes_repositories
        > {
  @override
  final Iterable<Type> types = const [
    GGetFollowingData_viewer_following_nodes_repositories,
    _$GGetFollowingData_viewer_following_nodes_repositories,
  ];
  @override
  final String wireName =
      'GGetFollowingData_viewer_following_nodes_repositories';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetFollowingData_viewer_following_nodes_repositories object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'totalCount',
      serializers.serialize(
        object.totalCount,
        specifiedType: const FullType(int),
      ),
    ];

    return result;
  }

  @override
  GGetFollowingData_viewer_following_nodes_repositories deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        GGetFollowingData_viewer_following_nodes_repositoriesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'totalCount':
          result.totalCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetFollowingData_viewer_following_nodes_followersSerializer
    implements
        StructuredSerializer<
          GGetFollowingData_viewer_following_nodes_followers
        > {
  @override
  final Iterable<Type> types = const [
    GGetFollowingData_viewer_following_nodes_followers,
    _$GGetFollowingData_viewer_following_nodes_followers,
  ];
  @override
  final String wireName = 'GGetFollowingData_viewer_following_nodes_followers';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetFollowingData_viewer_following_nodes_followers object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'totalCount',
      serializers.serialize(
        object.totalCount,
        specifiedType: const FullType(int),
      ),
    ];

    return result;
  }

  @override
  GGetFollowingData_viewer_following_nodes_followers deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetFollowingData_viewer_following_nodes_followersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'totalCount':
          result.totalCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetFollowingData_viewer_following_pageInfoSerializer
    implements
        StructuredSerializer<GGetFollowingData_viewer_following_pageInfo> {
  @override
  final Iterable<Type> types = const [
    GGetFollowingData_viewer_following_pageInfo,
    _$GGetFollowingData_viewer_following_pageInfo,
  ];
  @override
  final String wireName = 'GGetFollowingData_viewer_following_pageInfo';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetFollowingData_viewer_following_pageInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'hasNextPage',
      serializers.serialize(
        object.hasNextPage,
        specifiedType: const FullType(bool),
      ),
    ];
    Object? value;
    value = object.endCursor;
    if (value != null) {
      result
        ..add('endCursor')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GGetFollowingData_viewer_following_pageInfo deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetFollowingData_viewer_following_pageInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'hasNextPage':
          result.hasNextPage =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'endCursor':
          result.endCursor =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetFollowingData extends GGetFollowingData {
  @override
  final String G__typename;
  @override
  final GGetFollowingData_viewer viewer;

  factory _$GGetFollowingData([
    void Function(GGetFollowingDataBuilder)? updates,
  ]) => (GGetFollowingDataBuilder()..update(updates))._build();

  _$GGetFollowingData._({required this.G__typename, required this.viewer})
    : super._();
  @override
  GGetFollowingData rebuild(void Function(GGetFollowingDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetFollowingDataBuilder toBuilder() =>
      GGetFollowingDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetFollowingData &&
        G__typename == other.G__typename &&
        viewer == other.viewer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, viewer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetFollowingData')
          ..add('G__typename', G__typename)
          ..add('viewer', viewer))
        .toString();
  }
}

class GGetFollowingDataBuilder
    implements Builder<GGetFollowingData, GGetFollowingDataBuilder> {
  _$GGetFollowingData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GGetFollowingData_viewerBuilder? _viewer;
  GGetFollowingData_viewerBuilder get viewer =>
      _$this._viewer ??= GGetFollowingData_viewerBuilder();
  set viewer(GGetFollowingData_viewerBuilder? viewer) =>
      _$this._viewer = viewer;

  GGetFollowingDataBuilder() {
    GGetFollowingData._initializeBuilder(this);
  }

  GGetFollowingDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _viewer = $v.viewer.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetFollowingData other) {
    _$v = other as _$GGetFollowingData;
  }

  @override
  void update(void Function(GGetFollowingDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetFollowingData build() => _build();

  _$GGetFollowingData _build() {
    _$GGetFollowingData _$result;
    try {
      _$result =
          _$v ??
          _$GGetFollowingData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetFollowingData',
              'G__typename',
            ),
            viewer: viewer.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'viewer';
        viewer.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetFollowingData',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetFollowingData_viewer extends GGetFollowingData_viewer {
  @override
  final String G__typename;
  @override
  final GGetFollowingData_viewer_following following;

  factory _$GGetFollowingData_viewer([
    void Function(GGetFollowingData_viewerBuilder)? updates,
  ]) => (GGetFollowingData_viewerBuilder()..update(updates))._build();

  _$GGetFollowingData_viewer._({
    required this.G__typename,
    required this.following,
  }) : super._();
  @override
  GGetFollowingData_viewer rebuild(
    void Function(GGetFollowingData_viewerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetFollowingData_viewerBuilder toBuilder() =>
      GGetFollowingData_viewerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetFollowingData_viewer &&
        G__typename == other.G__typename &&
        following == other.following;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, following.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetFollowingData_viewer')
          ..add('G__typename', G__typename)
          ..add('following', following))
        .toString();
  }
}

class GGetFollowingData_viewerBuilder
    implements
        Builder<GGetFollowingData_viewer, GGetFollowingData_viewerBuilder> {
  _$GGetFollowingData_viewer? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GGetFollowingData_viewer_followingBuilder? _following;
  GGetFollowingData_viewer_followingBuilder get following =>
      _$this._following ??= GGetFollowingData_viewer_followingBuilder();
  set following(GGetFollowingData_viewer_followingBuilder? following) =>
      _$this._following = following;

  GGetFollowingData_viewerBuilder() {
    GGetFollowingData_viewer._initializeBuilder(this);
  }

  GGetFollowingData_viewerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _following = $v.following.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetFollowingData_viewer other) {
    _$v = other as _$GGetFollowingData_viewer;
  }

  @override
  void update(void Function(GGetFollowingData_viewerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetFollowingData_viewer build() => _build();

  _$GGetFollowingData_viewer _build() {
    _$GGetFollowingData_viewer _$result;
    try {
      _$result =
          _$v ??
          _$GGetFollowingData_viewer._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetFollowingData_viewer',
              'G__typename',
            ),
            following: following.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'following';
        following.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetFollowingData_viewer',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetFollowingData_viewer_following
    extends GGetFollowingData_viewer_following {
  @override
  final String G__typename;
  @override
  final BuiltList<GGetFollowingData_viewer_following_nodes?>? nodes;
  @override
  final GGetFollowingData_viewer_following_pageInfo pageInfo;

  factory _$GGetFollowingData_viewer_following([
    void Function(GGetFollowingData_viewer_followingBuilder)? updates,
  ]) => (GGetFollowingData_viewer_followingBuilder()..update(updates))._build();

  _$GGetFollowingData_viewer_following._({
    required this.G__typename,
    this.nodes,
    required this.pageInfo,
  }) : super._();
  @override
  GGetFollowingData_viewer_following rebuild(
    void Function(GGetFollowingData_viewer_followingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetFollowingData_viewer_followingBuilder toBuilder() =>
      GGetFollowingData_viewer_followingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetFollowingData_viewer_following &&
        G__typename == other.G__typename &&
        nodes == other.nodes &&
        pageInfo == other.pageInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, nodes.hashCode);
    _$hash = $jc(_$hash, pageInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetFollowingData_viewer_following')
          ..add('G__typename', G__typename)
          ..add('nodes', nodes)
          ..add('pageInfo', pageInfo))
        .toString();
  }
}

class GGetFollowingData_viewer_followingBuilder
    implements
        Builder<
          GGetFollowingData_viewer_following,
          GGetFollowingData_viewer_followingBuilder
        > {
  _$GGetFollowingData_viewer_following? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  ListBuilder<GGetFollowingData_viewer_following_nodes?>? _nodes;
  ListBuilder<GGetFollowingData_viewer_following_nodes?> get nodes =>
      _$this._nodes ??=
          ListBuilder<GGetFollowingData_viewer_following_nodes?>();
  set nodes(ListBuilder<GGetFollowingData_viewer_following_nodes?>? nodes) =>
      _$this._nodes = nodes;

  GGetFollowingData_viewer_following_pageInfoBuilder? _pageInfo;
  GGetFollowingData_viewer_following_pageInfoBuilder get pageInfo =>
      _$this._pageInfo ??= GGetFollowingData_viewer_following_pageInfoBuilder();
  set pageInfo(GGetFollowingData_viewer_following_pageInfoBuilder? pageInfo) =>
      _$this._pageInfo = pageInfo;

  GGetFollowingData_viewer_followingBuilder() {
    GGetFollowingData_viewer_following._initializeBuilder(this);
  }

  GGetFollowingData_viewer_followingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _nodes = $v.nodes?.toBuilder();
      _pageInfo = $v.pageInfo.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetFollowingData_viewer_following other) {
    _$v = other as _$GGetFollowingData_viewer_following;
  }

  @override
  void update(
    void Function(GGetFollowingData_viewer_followingBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetFollowingData_viewer_following build() => _build();

  _$GGetFollowingData_viewer_following _build() {
    _$GGetFollowingData_viewer_following _$result;
    try {
      _$result =
          _$v ??
          _$GGetFollowingData_viewer_following._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetFollowingData_viewer_following',
              'G__typename',
            ),
            nodes: _nodes?.build(),
            pageInfo: pageInfo.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nodes';
        _nodes?.build();
        _$failedField = 'pageInfo';
        pageInfo.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetFollowingData_viewer_following',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetFollowingData_viewer_following_nodes
    extends GGetFollowingData_viewer_following_nodes {
  @override
  final String G__typename;
  @override
  final String id;
  @override
  final String login;
  @override
  final String? name;
  @override
  final _i3.GURI avatarUrl;
  @override
  final String? bio;
  @override
  final GGetFollowingData_viewer_following_nodes_repositories repositories;
  @override
  final GGetFollowingData_viewer_following_nodes_followers followers;

  factory _$GGetFollowingData_viewer_following_nodes([
    void Function(GGetFollowingData_viewer_following_nodesBuilder)? updates,
  ]) => (GGetFollowingData_viewer_following_nodesBuilder()..update(updates))
      ._build();

  _$GGetFollowingData_viewer_following_nodes._({
    required this.G__typename,
    required this.id,
    required this.login,
    this.name,
    required this.avatarUrl,
    this.bio,
    required this.repositories,
    required this.followers,
  }) : super._();
  @override
  GGetFollowingData_viewer_following_nodes rebuild(
    void Function(GGetFollowingData_viewer_following_nodesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetFollowingData_viewer_following_nodesBuilder toBuilder() =>
      GGetFollowingData_viewer_following_nodesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetFollowingData_viewer_following_nodes &&
        G__typename == other.G__typename &&
        id == other.id &&
        login == other.login &&
        name == other.name &&
        avatarUrl == other.avatarUrl &&
        bio == other.bio &&
        repositories == other.repositories &&
        followers == other.followers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, login.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, repositories.hashCode);
    _$hash = $jc(_$hash, followers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetFollowingData_viewer_following_nodes',
          )
          ..add('G__typename', G__typename)
          ..add('id', id)
          ..add('login', login)
          ..add('name', name)
          ..add('avatarUrl', avatarUrl)
          ..add('bio', bio)
          ..add('repositories', repositories)
          ..add('followers', followers))
        .toString();
  }
}

class GGetFollowingData_viewer_following_nodesBuilder
    implements
        Builder<
          GGetFollowingData_viewer_following_nodes,
          GGetFollowingData_viewer_following_nodesBuilder
        > {
  _$GGetFollowingData_viewer_following_nodes? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _login;
  String? get login => _$this._login;
  set login(String? login) => _$this._login = login;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  _i3.GURIBuilder? _avatarUrl;
  _i3.GURIBuilder get avatarUrl => _$this._avatarUrl ??= _i3.GURIBuilder();
  set avatarUrl(_i3.GURIBuilder? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  GGetFollowingData_viewer_following_nodes_repositoriesBuilder? _repositories;
  GGetFollowingData_viewer_following_nodes_repositoriesBuilder
  get repositories => _$this._repositories ??=
      GGetFollowingData_viewer_following_nodes_repositoriesBuilder();
  set repositories(
    GGetFollowingData_viewer_following_nodes_repositoriesBuilder? repositories,
  ) => _$this._repositories = repositories;

  GGetFollowingData_viewer_following_nodes_followersBuilder? _followers;
  GGetFollowingData_viewer_following_nodes_followersBuilder get followers =>
      _$this._followers ??=
          GGetFollowingData_viewer_following_nodes_followersBuilder();
  set followers(
    GGetFollowingData_viewer_following_nodes_followersBuilder? followers,
  ) => _$this._followers = followers;

  GGetFollowingData_viewer_following_nodesBuilder() {
    GGetFollowingData_viewer_following_nodes._initializeBuilder(this);
  }

  GGetFollowingData_viewer_following_nodesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _id = $v.id;
      _login = $v.login;
      _name = $v.name;
      _avatarUrl = $v.avatarUrl.toBuilder();
      _bio = $v.bio;
      _repositories = $v.repositories.toBuilder();
      _followers = $v.followers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetFollowingData_viewer_following_nodes other) {
    _$v = other as _$GGetFollowingData_viewer_following_nodes;
  }

  @override
  void update(
    void Function(GGetFollowingData_viewer_following_nodesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetFollowingData_viewer_following_nodes build() => _build();

  _$GGetFollowingData_viewer_following_nodes _build() {
    _$GGetFollowingData_viewer_following_nodes _$result;
    try {
      _$result =
          _$v ??
          _$GGetFollowingData_viewer_following_nodes._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetFollowingData_viewer_following_nodes',
              'G__typename',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'GGetFollowingData_viewer_following_nodes',
              'id',
            ),
            login: BuiltValueNullFieldError.checkNotNull(
              login,
              r'GGetFollowingData_viewer_following_nodes',
              'login',
            ),
            name: name,
            avatarUrl: avatarUrl.build(),
            bio: bio,
            repositories: repositories.build(),
            followers: followers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'avatarUrl';
        avatarUrl.build();

        _$failedField = 'repositories';
        repositories.build();
        _$failedField = 'followers';
        followers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetFollowingData_viewer_following_nodes',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetFollowingData_viewer_following_nodes_repositories
    extends GGetFollowingData_viewer_following_nodes_repositories {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GGetFollowingData_viewer_following_nodes_repositories([
    void Function(GGetFollowingData_viewer_following_nodes_repositoriesBuilder)?
    updates,
  ]) =>
      (GGetFollowingData_viewer_following_nodes_repositoriesBuilder()
            ..update(updates))
          ._build();

  _$GGetFollowingData_viewer_following_nodes_repositories._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GGetFollowingData_viewer_following_nodes_repositories rebuild(
    void Function(GGetFollowingData_viewer_following_nodes_repositoriesBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetFollowingData_viewer_following_nodes_repositoriesBuilder toBuilder() =>
      GGetFollowingData_viewer_following_nodes_repositoriesBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetFollowingData_viewer_following_nodes_repositories &&
        G__typename == other.G__typename &&
        totalCount == other.totalCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, totalCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetFollowingData_viewer_following_nodes_repositories',
          )
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GGetFollowingData_viewer_following_nodes_repositoriesBuilder
    implements
        Builder<
          GGetFollowingData_viewer_following_nodes_repositories,
          GGetFollowingData_viewer_following_nodes_repositoriesBuilder
        > {
  _$GGetFollowingData_viewer_following_nodes_repositories? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GGetFollowingData_viewer_following_nodes_repositoriesBuilder() {
    GGetFollowingData_viewer_following_nodes_repositories._initializeBuilder(
      this,
    );
  }

  GGetFollowingData_viewer_following_nodes_repositoriesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetFollowingData_viewer_following_nodes_repositories other) {
    _$v = other as _$GGetFollowingData_viewer_following_nodes_repositories;
  }

  @override
  void update(
    void Function(GGetFollowingData_viewer_following_nodes_repositoriesBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetFollowingData_viewer_following_nodes_repositories build() => _build();

  _$GGetFollowingData_viewer_following_nodes_repositories _build() {
    final _$result =
        _$v ??
        _$GGetFollowingData_viewer_following_nodes_repositories._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetFollowingData_viewer_following_nodes_repositories',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GGetFollowingData_viewer_following_nodes_repositories',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

class _$GGetFollowingData_viewer_following_nodes_followers
    extends GGetFollowingData_viewer_following_nodes_followers {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GGetFollowingData_viewer_following_nodes_followers([
    void Function(GGetFollowingData_viewer_following_nodes_followersBuilder)?
    updates,
  ]) =>
      (GGetFollowingData_viewer_following_nodes_followersBuilder()
            ..update(updates))
          ._build();

  _$GGetFollowingData_viewer_following_nodes_followers._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GGetFollowingData_viewer_following_nodes_followers rebuild(
    void Function(GGetFollowingData_viewer_following_nodes_followersBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetFollowingData_viewer_following_nodes_followersBuilder toBuilder() =>
      GGetFollowingData_viewer_following_nodes_followersBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetFollowingData_viewer_following_nodes_followers &&
        G__typename == other.G__typename &&
        totalCount == other.totalCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, totalCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetFollowingData_viewer_following_nodes_followers',
          )
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GGetFollowingData_viewer_following_nodes_followersBuilder
    implements
        Builder<
          GGetFollowingData_viewer_following_nodes_followers,
          GGetFollowingData_viewer_following_nodes_followersBuilder
        > {
  _$GGetFollowingData_viewer_following_nodes_followers? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GGetFollowingData_viewer_following_nodes_followersBuilder() {
    GGetFollowingData_viewer_following_nodes_followers._initializeBuilder(this);
  }

  GGetFollowingData_viewer_following_nodes_followersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetFollowingData_viewer_following_nodes_followers other) {
    _$v = other as _$GGetFollowingData_viewer_following_nodes_followers;
  }

  @override
  void update(
    void Function(GGetFollowingData_viewer_following_nodes_followersBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetFollowingData_viewer_following_nodes_followers build() => _build();

  _$GGetFollowingData_viewer_following_nodes_followers _build() {
    final _$result =
        _$v ??
        _$GGetFollowingData_viewer_following_nodes_followers._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetFollowingData_viewer_following_nodes_followers',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GGetFollowingData_viewer_following_nodes_followers',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

class _$GGetFollowingData_viewer_following_pageInfo
    extends GGetFollowingData_viewer_following_pageInfo {
  @override
  final String G__typename;
  @override
  final bool hasNextPage;
  @override
  final String? endCursor;

  factory _$GGetFollowingData_viewer_following_pageInfo([
    void Function(GGetFollowingData_viewer_following_pageInfoBuilder)? updates,
  ]) => (GGetFollowingData_viewer_following_pageInfoBuilder()..update(updates))
      ._build();

  _$GGetFollowingData_viewer_following_pageInfo._({
    required this.G__typename,
    required this.hasNextPage,
    this.endCursor,
  }) : super._();
  @override
  GGetFollowingData_viewer_following_pageInfo rebuild(
    void Function(GGetFollowingData_viewer_following_pageInfoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetFollowingData_viewer_following_pageInfoBuilder toBuilder() =>
      GGetFollowingData_viewer_following_pageInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetFollowingData_viewer_following_pageInfo &&
        G__typename == other.G__typename &&
        hasNextPage == other.hasNextPage &&
        endCursor == other.endCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, hasNextPage.hashCode);
    _$hash = $jc(_$hash, endCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetFollowingData_viewer_following_pageInfo',
          )
          ..add('G__typename', G__typename)
          ..add('hasNextPage', hasNextPage)
          ..add('endCursor', endCursor))
        .toString();
  }
}

class GGetFollowingData_viewer_following_pageInfoBuilder
    implements
        Builder<
          GGetFollowingData_viewer_following_pageInfo,
          GGetFollowingData_viewer_following_pageInfoBuilder
        > {
  _$GGetFollowingData_viewer_following_pageInfo? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  bool? _hasNextPage;
  bool? get hasNextPage => _$this._hasNextPage;
  set hasNextPage(bool? hasNextPage) => _$this._hasNextPage = hasNextPage;

  String? _endCursor;
  String? get endCursor => _$this._endCursor;
  set endCursor(String? endCursor) => _$this._endCursor = endCursor;

  GGetFollowingData_viewer_following_pageInfoBuilder() {
    GGetFollowingData_viewer_following_pageInfo._initializeBuilder(this);
  }

  GGetFollowingData_viewer_following_pageInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _hasNextPage = $v.hasNextPage;
      _endCursor = $v.endCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetFollowingData_viewer_following_pageInfo other) {
    _$v = other as _$GGetFollowingData_viewer_following_pageInfo;
  }

  @override
  void update(
    void Function(GGetFollowingData_viewer_following_pageInfoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetFollowingData_viewer_following_pageInfo build() => _build();

  _$GGetFollowingData_viewer_following_pageInfo _build() {
    final _$result =
        _$v ??
        _$GGetFollowingData_viewer_following_pageInfo._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetFollowingData_viewer_following_pageInfo',
            'G__typename',
          ),
          hasNextPage: BuiltValueNullFieldError.checkNotNull(
            hasNextPage,
            r'GGetFollowingData_viewer_following_pageInfo',
            'hasNextPage',
          ),
          endCursor: endCursor,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
