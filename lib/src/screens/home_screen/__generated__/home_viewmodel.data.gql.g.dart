// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetCurrentUserData> _$gGetCurrentUserDataSerializer =
    _$GGetCurrentUserDataSerializer();
Serializer<GGetCurrentUserData_viewer> _$gGetCurrentUserDataViewerSerializer =
    _$GGetCurrentUserData_viewerSerializer();
Serializer<GGetCurrentUserData_viewer_repositories>
_$gGetCurrentUserDataViewerRepositoriesSerializer =
    _$GGetCurrentUserData_viewer_repositoriesSerializer();
Serializer<GGetCurrentUserData_viewer_followers>
_$gGetCurrentUserDataViewerFollowersSerializer =
    _$GGetCurrentUserData_viewer_followersSerializer();

class _$GGetCurrentUserDataSerializer
    implements StructuredSerializer<GGetCurrentUserData> {
  @override
  final Iterable<Type> types = const [
    GGetCurrentUserData,
    _$GGetCurrentUserData,
  ];
  @override
  final String wireName = 'GGetCurrentUserData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetCurrentUserData object, {
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
        specifiedType: const FullType(GGetCurrentUserData_viewer),
      ),
    ];

    return result;
  }

  @override
  GGetCurrentUserData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetCurrentUserDataBuilder();

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
                  specifiedType: const FullType(GGetCurrentUserData_viewer),
                )!
                as GGetCurrentUserData_viewer,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetCurrentUserData_viewerSerializer
    implements StructuredSerializer<GGetCurrentUserData_viewer> {
  @override
  final Iterable<Type> types = const [
    GGetCurrentUserData_viewer,
    _$GGetCurrentUserData_viewer,
  ];
  @override
  final String wireName = 'GGetCurrentUserData_viewer';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetCurrentUserData_viewer object, {
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
        specifiedType: const FullType(GGetCurrentUserData_viewer_repositories),
      ),
      'followers',
      serializers.serialize(
        object.followers,
        specifiedType: const FullType(GGetCurrentUserData_viewer_followers),
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
  GGetCurrentUserData_viewer deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetCurrentUserData_viewerBuilder();

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
                    GGetCurrentUserData_viewer_repositories,
                  ),
                )!
                as GGetCurrentUserData_viewer_repositories,
          );
          break;
        case 'followers':
          result.followers.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetCurrentUserData_viewer_followers,
                  ),
                )!
                as GGetCurrentUserData_viewer_followers,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetCurrentUserData_viewer_repositoriesSerializer
    implements StructuredSerializer<GGetCurrentUserData_viewer_repositories> {
  @override
  final Iterable<Type> types = const [
    GGetCurrentUserData_viewer_repositories,
    _$GGetCurrentUserData_viewer_repositories,
  ];
  @override
  final String wireName = 'GGetCurrentUserData_viewer_repositories';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetCurrentUserData_viewer_repositories object, {
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
  GGetCurrentUserData_viewer_repositories deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetCurrentUserData_viewer_repositoriesBuilder();

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

class _$GGetCurrentUserData_viewer_followersSerializer
    implements StructuredSerializer<GGetCurrentUserData_viewer_followers> {
  @override
  final Iterable<Type> types = const [
    GGetCurrentUserData_viewer_followers,
    _$GGetCurrentUserData_viewer_followers,
  ];
  @override
  final String wireName = 'GGetCurrentUserData_viewer_followers';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetCurrentUserData_viewer_followers object, {
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
  GGetCurrentUserData_viewer_followers deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetCurrentUserData_viewer_followersBuilder();

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

class _$GGetCurrentUserData extends GGetCurrentUserData {
  @override
  final String G__typename;
  @override
  final GGetCurrentUserData_viewer viewer;

  factory _$GGetCurrentUserData([
    void Function(GGetCurrentUserDataBuilder)? updates,
  ]) => (GGetCurrentUserDataBuilder()..update(updates))._build();

  _$GGetCurrentUserData._({required this.G__typename, required this.viewer})
    : super._();
  @override
  GGetCurrentUserData rebuild(
    void Function(GGetCurrentUserDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetCurrentUserDataBuilder toBuilder() =>
      GGetCurrentUserDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetCurrentUserData &&
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
    return (newBuiltValueToStringHelper(r'GGetCurrentUserData')
          ..add('G__typename', G__typename)
          ..add('viewer', viewer))
        .toString();
  }
}

class GGetCurrentUserDataBuilder
    implements Builder<GGetCurrentUserData, GGetCurrentUserDataBuilder> {
  _$GGetCurrentUserData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GGetCurrentUserData_viewerBuilder? _viewer;
  GGetCurrentUserData_viewerBuilder get viewer =>
      _$this._viewer ??= GGetCurrentUserData_viewerBuilder();
  set viewer(GGetCurrentUserData_viewerBuilder? viewer) =>
      _$this._viewer = viewer;

  GGetCurrentUserDataBuilder() {
    GGetCurrentUserData._initializeBuilder(this);
  }

  GGetCurrentUserDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _viewer = $v.viewer.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetCurrentUserData other) {
    _$v = other as _$GGetCurrentUserData;
  }

  @override
  void update(void Function(GGetCurrentUserDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetCurrentUserData build() => _build();

  _$GGetCurrentUserData _build() {
    _$GGetCurrentUserData _$result;
    try {
      _$result =
          _$v ??
          _$GGetCurrentUserData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetCurrentUserData',
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
          r'GGetCurrentUserData',
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

class _$GGetCurrentUserData_viewer extends GGetCurrentUserData_viewer {
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
  final GGetCurrentUserData_viewer_repositories repositories;
  @override
  final GGetCurrentUserData_viewer_followers followers;

  factory _$GGetCurrentUserData_viewer([
    void Function(GGetCurrentUserData_viewerBuilder)? updates,
  ]) => (GGetCurrentUserData_viewerBuilder()..update(updates))._build();

  _$GGetCurrentUserData_viewer._({
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
  GGetCurrentUserData_viewer rebuild(
    void Function(GGetCurrentUserData_viewerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetCurrentUserData_viewerBuilder toBuilder() =>
      GGetCurrentUserData_viewerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetCurrentUserData_viewer &&
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
    return (newBuiltValueToStringHelper(r'GGetCurrentUserData_viewer')
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

class GGetCurrentUserData_viewerBuilder
    implements
        Builder<GGetCurrentUserData_viewer, GGetCurrentUserData_viewerBuilder> {
  _$GGetCurrentUserData_viewer? _$v;

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

  GGetCurrentUserData_viewer_repositoriesBuilder? _repositories;
  GGetCurrentUserData_viewer_repositoriesBuilder get repositories =>
      _$this._repositories ??= GGetCurrentUserData_viewer_repositoriesBuilder();
  set repositories(
    GGetCurrentUserData_viewer_repositoriesBuilder? repositories,
  ) => _$this._repositories = repositories;

  GGetCurrentUserData_viewer_followersBuilder? _followers;
  GGetCurrentUserData_viewer_followersBuilder get followers =>
      _$this._followers ??= GGetCurrentUserData_viewer_followersBuilder();
  set followers(GGetCurrentUserData_viewer_followersBuilder? followers) =>
      _$this._followers = followers;

  GGetCurrentUserData_viewerBuilder() {
    GGetCurrentUserData_viewer._initializeBuilder(this);
  }

  GGetCurrentUserData_viewerBuilder get _$this {
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
  void replace(GGetCurrentUserData_viewer other) {
    _$v = other as _$GGetCurrentUserData_viewer;
  }

  @override
  void update(void Function(GGetCurrentUserData_viewerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetCurrentUserData_viewer build() => _build();

  _$GGetCurrentUserData_viewer _build() {
    _$GGetCurrentUserData_viewer _$result;
    try {
      _$result =
          _$v ??
          _$GGetCurrentUserData_viewer._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetCurrentUserData_viewer',
              'G__typename',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'GGetCurrentUserData_viewer',
              'id',
            ),
            login: BuiltValueNullFieldError.checkNotNull(
              login,
              r'GGetCurrentUserData_viewer',
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
          r'GGetCurrentUserData_viewer',
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

class _$GGetCurrentUserData_viewer_repositories
    extends GGetCurrentUserData_viewer_repositories {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GGetCurrentUserData_viewer_repositories([
    void Function(GGetCurrentUserData_viewer_repositoriesBuilder)? updates,
  ]) => (GGetCurrentUserData_viewer_repositoriesBuilder()..update(updates))
      ._build();

  _$GGetCurrentUserData_viewer_repositories._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GGetCurrentUserData_viewer_repositories rebuild(
    void Function(GGetCurrentUserData_viewer_repositoriesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetCurrentUserData_viewer_repositoriesBuilder toBuilder() =>
      GGetCurrentUserData_viewer_repositoriesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetCurrentUserData_viewer_repositories &&
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
            r'GGetCurrentUserData_viewer_repositories',
          )
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GGetCurrentUserData_viewer_repositoriesBuilder
    implements
        Builder<
          GGetCurrentUserData_viewer_repositories,
          GGetCurrentUserData_viewer_repositoriesBuilder
        > {
  _$GGetCurrentUserData_viewer_repositories? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GGetCurrentUserData_viewer_repositoriesBuilder() {
    GGetCurrentUserData_viewer_repositories._initializeBuilder(this);
  }

  GGetCurrentUserData_viewer_repositoriesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetCurrentUserData_viewer_repositories other) {
    _$v = other as _$GGetCurrentUserData_viewer_repositories;
  }

  @override
  void update(
    void Function(GGetCurrentUserData_viewer_repositoriesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetCurrentUserData_viewer_repositories build() => _build();

  _$GGetCurrentUserData_viewer_repositories _build() {
    final _$result =
        _$v ??
        _$GGetCurrentUserData_viewer_repositories._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetCurrentUserData_viewer_repositories',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GGetCurrentUserData_viewer_repositories',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

class _$GGetCurrentUserData_viewer_followers
    extends GGetCurrentUserData_viewer_followers {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GGetCurrentUserData_viewer_followers([
    void Function(GGetCurrentUserData_viewer_followersBuilder)? updates,
  ]) =>
      (GGetCurrentUserData_viewer_followersBuilder()..update(updates))._build();

  _$GGetCurrentUserData_viewer_followers._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GGetCurrentUserData_viewer_followers rebuild(
    void Function(GGetCurrentUserData_viewer_followersBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetCurrentUserData_viewer_followersBuilder toBuilder() =>
      GGetCurrentUserData_viewer_followersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetCurrentUserData_viewer_followers &&
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
    return (newBuiltValueToStringHelper(r'GGetCurrentUserData_viewer_followers')
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GGetCurrentUserData_viewer_followersBuilder
    implements
        Builder<
          GGetCurrentUserData_viewer_followers,
          GGetCurrentUserData_viewer_followersBuilder
        > {
  _$GGetCurrentUserData_viewer_followers? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GGetCurrentUserData_viewer_followersBuilder() {
    GGetCurrentUserData_viewer_followers._initializeBuilder(this);
  }

  GGetCurrentUserData_viewer_followersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetCurrentUserData_viewer_followers other) {
    _$v = other as _$GGetCurrentUserData_viewer_followers;
  }

  @override
  void update(
    void Function(GGetCurrentUserData_viewer_followersBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetCurrentUserData_viewer_followers build() => _build();

  _$GGetCurrentUserData_viewer_followers _build() {
    final _$result =
        _$v ??
        _$GGetCurrentUserData_viewer_followers._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetCurrentUserData_viewer_followers',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GGetCurrentUserData_viewer_followers',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
