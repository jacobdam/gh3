// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GUserProfileFragmentData> _$gUserProfileFragmentDataSerializer =
    _$GUserProfileFragmentDataSerializer();
Serializer<GUserProfileFragmentData_repositories>
_$gUserProfileFragmentDataRepositoriesSerializer =
    _$GUserProfileFragmentData_repositoriesSerializer();
Serializer<GUserProfileFragmentData_followers>
_$gUserProfileFragmentDataFollowersSerializer =
    _$GUserProfileFragmentData_followersSerializer();
Serializer<GUserProfileFragmentData_following>
_$gUserProfileFragmentDataFollowingSerializer =
    _$GUserProfileFragmentData_followingSerializer();

class _$GUserProfileFragmentDataSerializer
    implements StructuredSerializer<GUserProfileFragmentData> {
  @override
  final Iterable<Type> types = const [
    GUserProfileFragmentData,
    _$GUserProfileFragmentData,
  ];
  @override
  final String wireName = 'GUserProfileFragmentData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserProfileFragmentData object, {
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
      'email',
      serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      ),
      'avatarUrl',
      serializers.serialize(
        object.avatarUrl,
        specifiedType: const FullType(_i1.GURI),
      ),
      'url',
      serializers.serialize(
        object.url,
        specifiedType: const FullType(_i1.GURI),
      ),
      'repositories',
      serializers.serialize(
        object.repositories,
        specifiedType: const FullType(GUserProfileFragmentData_repositories),
      ),
      'followers',
      serializers.serialize(
        object.followers,
        specifiedType: const FullType(GUserProfileFragmentData_followers),
      ),
      'following',
      serializers.serialize(
        object.following,
        specifiedType: const FullType(GUserProfileFragmentData_following),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(_i1.GDateTime),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(_i1.GDateTime),
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
    value = object.location;
    if (value != null) {
      result
        ..add('location')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.company;
    if (value != null) {
      result
        ..add('company')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.websiteUrl;
    if (value != null) {
      result
        ..add('websiteUrl')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(_i1.GURI)),
        );
    }
    return result;
  }

  @override
  GUserProfileFragmentData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserProfileFragmentDataBuilder();

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
        case 'email':
          result.email =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'bio':
          result.bio =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'location':
          result.location =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'company':
          result.company =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'websiteUrl':
          result.websiteUrl.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i1.GURI),
                )!
                as _i1.GURI,
          );
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
        case 'url':
          result.url.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i1.GURI),
                )!
                as _i1.GURI,
          );
          break;
        case 'repositories':
          result.repositories.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GUserProfileFragmentData_repositories,
                  ),
                )!
                as GUserProfileFragmentData_repositories,
          );
          break;
        case 'followers':
          result.followers.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GUserProfileFragmentData_followers,
                  ),
                )!
                as GUserProfileFragmentData_followers,
          );
          break;
        case 'following':
          result.following.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GUserProfileFragmentData_following,
                  ),
                )!
                as GUserProfileFragmentData_following,
          );
          break;
        case 'createdAt':
          result.createdAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i1.GDateTime),
                )!
                as _i1.GDateTime,
          );
          break;
        case 'updatedAt':
          result.updatedAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i1.GDateTime),
                )!
                as _i1.GDateTime,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GUserProfileFragmentData_repositoriesSerializer
    implements StructuredSerializer<GUserProfileFragmentData_repositories> {
  @override
  final Iterable<Type> types = const [
    GUserProfileFragmentData_repositories,
    _$GUserProfileFragmentData_repositories,
  ];
  @override
  final String wireName = 'GUserProfileFragmentData_repositories';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserProfileFragmentData_repositories object, {
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
  GUserProfileFragmentData_repositories deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserProfileFragmentData_repositoriesBuilder();

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

class _$GUserProfileFragmentData_followersSerializer
    implements StructuredSerializer<GUserProfileFragmentData_followers> {
  @override
  final Iterable<Type> types = const [
    GUserProfileFragmentData_followers,
    _$GUserProfileFragmentData_followers,
  ];
  @override
  final String wireName = 'GUserProfileFragmentData_followers';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserProfileFragmentData_followers object, {
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
  GUserProfileFragmentData_followers deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserProfileFragmentData_followersBuilder();

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

class _$GUserProfileFragmentData_followingSerializer
    implements StructuredSerializer<GUserProfileFragmentData_following> {
  @override
  final Iterable<Type> types = const [
    GUserProfileFragmentData_following,
    _$GUserProfileFragmentData_following,
  ];
  @override
  final String wireName = 'GUserProfileFragmentData_following';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserProfileFragmentData_following object, {
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
  GUserProfileFragmentData_following deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserProfileFragmentData_followingBuilder();

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

class _$GUserProfileFragmentData extends GUserProfileFragmentData {
  @override
  final String G__typename;
  @override
  final String id;
  @override
  final String login;
  @override
  final String? name;
  @override
  final String email;
  @override
  final String? bio;
  @override
  final String? location;
  @override
  final String? company;
  @override
  final _i1.GURI? websiteUrl;
  @override
  final _i1.GURI avatarUrl;
  @override
  final _i1.GURI url;
  @override
  final GUserProfileFragmentData_repositories repositories;
  @override
  final GUserProfileFragmentData_followers followers;
  @override
  final GUserProfileFragmentData_following following;
  @override
  final _i1.GDateTime createdAt;
  @override
  final _i1.GDateTime updatedAt;

  factory _$GUserProfileFragmentData([
    void Function(GUserProfileFragmentDataBuilder)? updates,
  ]) => (GUserProfileFragmentDataBuilder()..update(updates))._build();

  _$GUserProfileFragmentData._({
    required this.G__typename,
    required this.id,
    required this.login,
    this.name,
    required this.email,
    this.bio,
    this.location,
    this.company,
    this.websiteUrl,
    required this.avatarUrl,
    required this.url,
    required this.repositories,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();
  @override
  GUserProfileFragmentData rebuild(
    void Function(GUserProfileFragmentDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserProfileFragmentDataBuilder toBuilder() =>
      GUserProfileFragmentDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserProfileFragmentData &&
        G__typename == other.G__typename &&
        id == other.id &&
        login == other.login &&
        name == other.name &&
        email == other.email &&
        bio == other.bio &&
        location == other.location &&
        company == other.company &&
        websiteUrl == other.websiteUrl &&
        avatarUrl == other.avatarUrl &&
        url == other.url &&
        repositories == other.repositories &&
        followers == other.followers &&
        following == other.following &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, login.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, company.hashCode);
    _$hash = $jc(_$hash, websiteUrl.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, repositories.hashCode);
    _$hash = $jc(_$hash, followers.hashCode);
    _$hash = $jc(_$hash, following.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GUserProfileFragmentData')
          ..add('G__typename', G__typename)
          ..add('id', id)
          ..add('login', login)
          ..add('name', name)
          ..add('email', email)
          ..add('bio', bio)
          ..add('location', location)
          ..add('company', company)
          ..add('websiteUrl', websiteUrl)
          ..add('avatarUrl', avatarUrl)
          ..add('url', url)
          ..add('repositories', repositories)
          ..add('followers', followers)
          ..add('following', following)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class GUserProfileFragmentDataBuilder
    implements
        Builder<GUserProfileFragmentData, GUserProfileFragmentDataBuilder> {
  _$GUserProfileFragmentData? _$v;

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

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  String? _company;
  String? get company => _$this._company;
  set company(String? company) => _$this._company = company;

  _i1.GURIBuilder? _websiteUrl;
  _i1.GURIBuilder get websiteUrl => _$this._websiteUrl ??= _i1.GURIBuilder();
  set websiteUrl(_i1.GURIBuilder? websiteUrl) =>
      _$this._websiteUrl = websiteUrl;

  _i1.GURIBuilder? _avatarUrl;
  _i1.GURIBuilder get avatarUrl => _$this._avatarUrl ??= _i1.GURIBuilder();
  set avatarUrl(_i1.GURIBuilder? avatarUrl) => _$this._avatarUrl = avatarUrl;

  _i1.GURIBuilder? _url;
  _i1.GURIBuilder get url => _$this._url ??= _i1.GURIBuilder();
  set url(_i1.GURIBuilder? url) => _$this._url = url;

  GUserProfileFragmentData_repositoriesBuilder? _repositories;
  GUserProfileFragmentData_repositoriesBuilder get repositories =>
      _$this._repositories ??= GUserProfileFragmentData_repositoriesBuilder();
  set repositories(
    GUserProfileFragmentData_repositoriesBuilder? repositories,
  ) => _$this._repositories = repositories;

  GUserProfileFragmentData_followersBuilder? _followers;
  GUserProfileFragmentData_followersBuilder get followers =>
      _$this._followers ??= GUserProfileFragmentData_followersBuilder();
  set followers(GUserProfileFragmentData_followersBuilder? followers) =>
      _$this._followers = followers;

  GUserProfileFragmentData_followingBuilder? _following;
  GUserProfileFragmentData_followingBuilder get following =>
      _$this._following ??= GUserProfileFragmentData_followingBuilder();
  set following(GUserProfileFragmentData_followingBuilder? following) =>
      _$this._following = following;

  _i1.GDateTimeBuilder? _createdAt;
  _i1.GDateTimeBuilder get createdAt =>
      _$this._createdAt ??= _i1.GDateTimeBuilder();
  set createdAt(_i1.GDateTimeBuilder? createdAt) =>
      _$this._createdAt = createdAt;

  _i1.GDateTimeBuilder? _updatedAt;
  _i1.GDateTimeBuilder get updatedAt =>
      _$this._updatedAt ??= _i1.GDateTimeBuilder();
  set updatedAt(_i1.GDateTimeBuilder? updatedAt) =>
      _$this._updatedAt = updatedAt;

  GUserProfileFragmentDataBuilder() {
    GUserProfileFragmentData._initializeBuilder(this);
  }

  GUserProfileFragmentDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _id = $v.id;
      _login = $v.login;
      _name = $v.name;
      _email = $v.email;
      _bio = $v.bio;
      _location = $v.location;
      _company = $v.company;
      _websiteUrl = $v.websiteUrl?.toBuilder();
      _avatarUrl = $v.avatarUrl.toBuilder();
      _url = $v.url.toBuilder();
      _repositories = $v.repositories.toBuilder();
      _followers = $v.followers.toBuilder();
      _following = $v.following.toBuilder();
      _createdAt = $v.createdAt.toBuilder();
      _updatedAt = $v.updatedAt.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserProfileFragmentData other) {
    _$v = other as _$GUserProfileFragmentData;
  }

  @override
  void update(void Function(GUserProfileFragmentDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserProfileFragmentData build() => _build();

  _$GUserProfileFragmentData _build() {
    _$GUserProfileFragmentData _$result;
    try {
      _$result =
          _$v ??
          _$GUserProfileFragmentData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GUserProfileFragmentData',
              'G__typename',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'GUserProfileFragmentData',
              'id',
            ),
            login: BuiltValueNullFieldError.checkNotNull(
              login,
              r'GUserProfileFragmentData',
              'login',
            ),
            name: name,
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'GUserProfileFragmentData',
              'email',
            ),
            bio: bio,
            location: location,
            company: company,
            websiteUrl: _websiteUrl?.build(),
            avatarUrl: avatarUrl.build(),
            url: url.build(),
            repositories: repositories.build(),
            followers: followers.build(),
            following: following.build(),
            createdAt: createdAt.build(),
            updatedAt: updatedAt.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'websiteUrl';
        _websiteUrl?.build();
        _$failedField = 'avatarUrl';
        avatarUrl.build();
        _$failedField = 'url';
        url.build();
        _$failedField = 'repositories';
        repositories.build();
        _$failedField = 'followers';
        followers.build();
        _$failedField = 'following';
        following.build();
        _$failedField = 'createdAt';
        createdAt.build();
        _$failedField = 'updatedAt';
        updatedAt.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GUserProfileFragmentData',
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

class _$GUserProfileFragmentData_repositories
    extends GUserProfileFragmentData_repositories {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GUserProfileFragmentData_repositories([
    void Function(GUserProfileFragmentData_repositoriesBuilder)? updates,
  ]) => (GUserProfileFragmentData_repositoriesBuilder()..update(updates))
      ._build();

  _$GUserProfileFragmentData_repositories._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GUserProfileFragmentData_repositories rebuild(
    void Function(GUserProfileFragmentData_repositoriesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserProfileFragmentData_repositoriesBuilder toBuilder() =>
      GUserProfileFragmentData_repositoriesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserProfileFragmentData_repositories &&
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
            r'GUserProfileFragmentData_repositories',
          )
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GUserProfileFragmentData_repositoriesBuilder
    implements
        Builder<
          GUserProfileFragmentData_repositories,
          GUserProfileFragmentData_repositoriesBuilder
        > {
  _$GUserProfileFragmentData_repositories? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GUserProfileFragmentData_repositoriesBuilder() {
    GUserProfileFragmentData_repositories._initializeBuilder(this);
  }

  GUserProfileFragmentData_repositoriesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserProfileFragmentData_repositories other) {
    _$v = other as _$GUserProfileFragmentData_repositories;
  }

  @override
  void update(
    void Function(GUserProfileFragmentData_repositoriesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GUserProfileFragmentData_repositories build() => _build();

  _$GUserProfileFragmentData_repositories _build() {
    final _$result =
        _$v ??
        _$GUserProfileFragmentData_repositories._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GUserProfileFragmentData_repositories',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GUserProfileFragmentData_repositories',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

class _$GUserProfileFragmentData_followers
    extends GUserProfileFragmentData_followers {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GUserProfileFragmentData_followers([
    void Function(GUserProfileFragmentData_followersBuilder)? updates,
  ]) => (GUserProfileFragmentData_followersBuilder()..update(updates))._build();

  _$GUserProfileFragmentData_followers._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GUserProfileFragmentData_followers rebuild(
    void Function(GUserProfileFragmentData_followersBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserProfileFragmentData_followersBuilder toBuilder() =>
      GUserProfileFragmentData_followersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserProfileFragmentData_followers &&
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
    return (newBuiltValueToStringHelper(r'GUserProfileFragmentData_followers')
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GUserProfileFragmentData_followersBuilder
    implements
        Builder<
          GUserProfileFragmentData_followers,
          GUserProfileFragmentData_followersBuilder
        > {
  _$GUserProfileFragmentData_followers? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GUserProfileFragmentData_followersBuilder() {
    GUserProfileFragmentData_followers._initializeBuilder(this);
  }

  GUserProfileFragmentData_followersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserProfileFragmentData_followers other) {
    _$v = other as _$GUserProfileFragmentData_followers;
  }

  @override
  void update(
    void Function(GUserProfileFragmentData_followersBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GUserProfileFragmentData_followers build() => _build();

  _$GUserProfileFragmentData_followers _build() {
    final _$result =
        _$v ??
        _$GUserProfileFragmentData_followers._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GUserProfileFragmentData_followers',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GUserProfileFragmentData_followers',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

class _$GUserProfileFragmentData_following
    extends GUserProfileFragmentData_following {
  @override
  final String G__typename;
  @override
  final int totalCount;

  factory _$GUserProfileFragmentData_following([
    void Function(GUserProfileFragmentData_followingBuilder)? updates,
  ]) => (GUserProfileFragmentData_followingBuilder()..update(updates))._build();

  _$GUserProfileFragmentData_following._({
    required this.G__typename,
    required this.totalCount,
  }) : super._();
  @override
  GUserProfileFragmentData_following rebuild(
    void Function(GUserProfileFragmentData_followingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserProfileFragmentData_followingBuilder toBuilder() =>
      GUserProfileFragmentData_followingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserProfileFragmentData_following &&
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
    return (newBuiltValueToStringHelper(r'GUserProfileFragmentData_following')
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount))
        .toString();
  }
}

class GUserProfileFragmentData_followingBuilder
    implements
        Builder<
          GUserProfileFragmentData_following,
          GUserProfileFragmentData_followingBuilder
        > {
  _$GUserProfileFragmentData_following? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GUserProfileFragmentData_followingBuilder() {
    GUserProfileFragmentData_following._initializeBuilder(this);
  }

  GUserProfileFragmentData_followingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserProfileFragmentData_following other) {
    _$v = other as _$GUserProfileFragmentData_following;
  }

  @override
  void update(
    void Function(GUserProfileFragmentData_followingBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GUserProfileFragmentData_following build() => _build();

  _$GUserProfileFragmentData_following _build() {
    final _$result =
        _$v ??
        _$GUserProfileFragmentData_following._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GUserProfileFragmentData_following',
            'G__typename',
          ),
          totalCount: BuiltValueNullFieldError.checkNotNull(
            totalCount,
            r'GUserProfileFragmentData_following',
            'totalCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
