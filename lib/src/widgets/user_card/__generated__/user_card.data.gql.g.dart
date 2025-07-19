// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_card.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GUserCardFragmentData> _$gUserCardFragmentDataSerializer =
    _$GUserCardFragmentDataSerializer();
Serializer<GUserCardFragmentData_repositories>
_$gUserCardFragmentDataRepositoriesSerializer =
    _$GUserCardFragmentData_repositoriesSerializer();
Serializer<GUserCardFragmentData_followers>
_$gUserCardFragmentDataFollowersSerializer =
    _$GUserCardFragmentData_followersSerializer();

class _$GUserCardFragmentDataSerializer
    implements StructuredSerializer<GUserCardFragmentData> {
  @override
  final Iterable<Type> types = const [
    GUserCardFragmentData,
    _$GUserCardFragmentData,
  ];
  @override
  final String wireName = 'GUserCardFragmentData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserCardFragmentData object, {
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
        specifiedType: const FullType(_i1.GURI),
      ),
      'repositories',
      serializers.serialize(
        object.repositories,
        specifiedType: const FullType(GUserCardFragmentData_repositories),
      ),
      'followers',
      serializers.serialize(
        object.followers,
        specifiedType: const FullType(GUserCardFragmentData_followers),
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
  GUserCardFragmentData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserCardFragmentDataBuilder();

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
                  specifiedType: const FullType(_i1.GURI),
                )!
                as _i1.GURI,
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
                    GUserCardFragmentData_repositories,
                  ),
                )!
                as GUserCardFragmentData_repositories,
          );
          break;
        case 'followers':
          result.followers.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GUserCardFragmentData_followers,
                  ),
                )!
                as GUserCardFragmentData_followers,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GUserCardFragmentData_repositoriesSerializer
    implements StructuredSerializer<GUserCardFragmentData_repositories> {
  @override
  final Iterable<Type> types = const [
    GUserCardFragmentData_repositories,
    _$GUserCardFragmentData_repositories,
  ];
  @override
  final String wireName = 'GUserCardFragmentData_repositories';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserCardFragmentData_repositories object, {
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
  GUserCardFragmentData_repositories deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserCardFragmentData_repositoriesBuilder();

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

class _$GUserCardFragmentData_followersSerializer
    implements StructuredSerializer<GUserCardFragmentData_followers> {
  @override
  final Iterable<Type> types = const [
    GUserCardFragmentData_followers,
    _$GUserCardFragmentData_followers,
  ];
  @override
  final String wireName = 'GUserCardFragmentData_followers';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserCardFragmentData_followers object, {
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
  GUserCardFragmentData_followers deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserCardFragmentData_followersBuilder();

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

class _$GUserCardFragmentData extends GUserCardFragmentData {
  @override
  final String G__typename;
  @override
  final String id;
  @override
  final String login;
  @override
  final String? name;
  @override
  final _i1.GURI avatarUrl;
  @override
  final String? bio;
  @override
  final GUserCardFragmentData_repositories repositories;
  @override
  final GUserCardFragmentData_followers followers;

  factory _$GUserCardFragmentData([
    void Function(GUserCardFragmentDataBuilder)? updates,
  ]) => (GUserCardFragmentDataBuilder()..update(updates))._build();

  _$GUserCardFragmentData._({
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
  GUserCardFragmentData rebuild(
    void Function(GUserCardFragmentDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserCardFragmentDataBuilder toBuilder() =>
      GUserCardFragmentDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserCardFragmentData &&
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
    return (newBuiltValueToStringHelper(r'GUserCardFragmentData')
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

class GUserCardFragmentDataBuilder
    implements Builder<GUserCardFragmentData, GUserCardFragmentDataBuilder> {
  _$GUserCardFragmentData? _$v;

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

  _i1.GURIBuilder? _avatarUrl;
  _i1.GURIBuilder get avatarUrl => _$this._avatarUrl ??= _i1.GURIBuilder();
  set avatarUrl(_i1.GURIBuilder? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  GUserCardFragmentData_repositoriesBuilder? _repositories;
  GUserCardFragmentData_repositoriesBuilder get repositories =>
      _$this._repositories ??= GUserCardFragmentData_repositoriesBuilder();
  set repositories(GUserCardFragmentData_repositoriesBuilder? repositories) =>
      _$this._repositories = repositories;

  GUserCardFragmentData_followersBuilder? _followers;
  GUserCardFragmentData_followersBuilder get followers =>
      _$this._followers ??= GUserCardFragmentData_followersBuilder();
  set followers(GUserCardFragmentData_followersBuilder? followers) =>
      _$this._followers = followers;

  GUserCardFragmentDataBuilder() {
    GUserCardFragmentData._initializeBuilder(this);
  }

  GUserCardFragmentDataBuilder get _$this {
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
  void replace(GUserCardFragmentData other) {
    _$v = other as _$GUserCardFragmentData;
  }

  @override
  void update(void Function(GUserCardFragmentDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserCardFragmentData build() => _build();

  _$GUserCardFragmentData _build() {
    _$GUserCardFragmentData _$result;
    try {
      _$result =
          _$v ??
          _$GUserCardFragmentData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GUserCardFragmentData',
              'G__typename',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'GUserCardFragmentData',
              'id',
            ),
            login: BuiltValueNullFieldError.checkNotNull(
              login,
              r'GUserCardFragmentData',
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
          r'GUserCardFragmentData',
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

class _$GUserCardFragmentData_repositories
    extends GUserCardFragmentData_repositories {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GUserCardFragmentData_repositories([
    void Function(GUserCardFragmentData_repositoriesBuilder)? updates,
  ]) => (GUserCardFragmentData_repositoriesBuilder()..update(updates))._build();

  _$GUserCardFragmentData_repositories._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GUserCardFragmentData_repositories rebuild(
    void Function(GUserCardFragmentData_repositoriesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserCardFragmentData_repositoriesBuilder toBuilder() =>
      GUserCardFragmentData_repositoriesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserCardFragmentData_repositories &&
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
    return (newBuiltValueToStringHelper(r'GUserCardFragmentData_repositories')
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GUserCardFragmentData_repositoriesBuilder
    implements
        Builder<
          GUserCardFragmentData_repositories,
          GUserCardFragmentData_repositoriesBuilder
        > {
  _$GUserCardFragmentData_repositories? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GUserCardFragmentData_repositoriesBuilder() {
    GUserCardFragmentData_repositories._initializeBuilder(this);
  }

  GUserCardFragmentData_repositoriesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserCardFragmentData_repositories other) {
    _$v = other as _$GUserCardFragmentData_repositories;
  }

  @override
  void update(
    void Function(GUserCardFragmentData_repositoriesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GUserCardFragmentData_repositories build() => _build();

  _$GUserCardFragmentData_repositories _build() {
    final _$result =
        _$v ??
        _$GUserCardFragmentData_repositories._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GUserCardFragmentData_repositories',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GUserCardFragmentData_repositories',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

class _$GUserCardFragmentData_followers
    extends GUserCardFragmentData_followers {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GUserCardFragmentData_followers([
    void Function(GUserCardFragmentData_followersBuilder)? updates,
  ]) => (GUserCardFragmentData_followersBuilder()..update(updates))._build();

  _$GUserCardFragmentData_followers._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GUserCardFragmentData_followers rebuild(
    void Function(GUserCardFragmentData_followersBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserCardFragmentData_followersBuilder toBuilder() =>
      GUserCardFragmentData_followersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserCardFragmentData_followers &&
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
    return (newBuiltValueToStringHelper(r'GUserCardFragmentData_followers')
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GUserCardFragmentData_followersBuilder
    implements
        Builder<
          GUserCardFragmentData_followers,
          GUserCardFragmentData_followersBuilder
        > {
  _$GUserCardFragmentData_followers? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GUserCardFragmentData_followersBuilder() {
    GUserCardFragmentData_followers._initializeBuilder(this);
  }

  GUserCardFragmentData_followersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserCardFragmentData_followers other) {
    _$v = other as _$GUserCardFragmentData_followers;
  }

  @override
  void update(void Function(GUserCardFragmentData_followersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserCardFragmentData_followers build() => _build();

  _$GUserCardFragmentData_followers _build() {
    final _$result =
        _$v ??
        _$GUserCardFragmentData_followers._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GUserCardFragmentData_followers',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GUserCardFragmentData_followers',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
