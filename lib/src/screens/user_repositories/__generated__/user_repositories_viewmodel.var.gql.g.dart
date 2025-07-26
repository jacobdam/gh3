// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repositories_viewmodel.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetUserRepositoriesVars> _$gGetUserRepositoriesVarsSerializer =
    _$GGetUserRepositoriesVarsSerializer();
Serializer<GGetViewerRepositoriesVars> _$gGetViewerRepositoriesVarsSerializer =
    _$GGetViewerRepositoriesVarsSerializer();
Serializer<GUserRepositoriesFragmentVars>
_$gUserRepositoriesFragmentVarsSerializer =
    _$GUserRepositoriesFragmentVarsSerializer();

class _$GGetUserRepositoriesVarsSerializer
    implements StructuredSerializer<GGetUserRepositoriesVars> {
  @override
  final Iterable<Type> types = const [
    GGetUserRepositoriesVars,
    _$GGetUserRepositoriesVars,
  ];
  @override
  final String wireName = 'GGetUserRepositoriesVars';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetUserRepositoriesVars object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'login',
      serializers.serialize(
        object.login,
        specifiedType: const FullType(String),
      ),
      'first',
      serializers.serialize(object.first, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.after;
    if (value != null) {
      result
        ..add('after')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.orderBy;
    if (value != null) {
      result
        ..add('orderBy')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(_i1.GRepositoryOrder),
          ),
        );
    }
    value = object.affiliations;
    if (value != null) {
      result
        ..add('affiliations')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(_i1.GRepositoryAffiliation),
            ]),
          ),
        );
    }
    value = object.privacy;
    if (value != null) {
      result
        ..add('privacy')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(_i1.GRepositoryPrivacy),
          ),
        );
    }
    value = object.isFork;
    if (value != null) {
      result
        ..add('isFork')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(bool)),
        );
    }
    value = object.isLocked;
    if (value != null) {
      result
        ..add('isLocked')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(bool)),
        );
    }
    return result;
  }

  @override
  GGetUserRepositoriesVars deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetUserRepositoriesVarsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'login':
          result.login =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'first':
          result.first =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'after':
          result.after =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'orderBy':
          result.orderBy.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i1.GRepositoryOrder),
                )!
                as _i1.GRepositoryOrder,
          );
          break;
        case 'affiliations':
          result.affiliations.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(_i1.GRepositoryAffiliation),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'privacy':
          result.privacy =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(_i1.GRepositoryPrivacy),
                  )
                  as _i1.GRepositoryPrivacy?;
          break;
        case 'isFork':
          result.isFork =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool?;
          break;
        case 'isLocked':
          result.isLocked =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetViewerRepositoriesVarsSerializer
    implements StructuredSerializer<GGetViewerRepositoriesVars> {
  @override
  final Iterable<Type> types = const [
    GGetViewerRepositoriesVars,
    _$GGetViewerRepositoriesVars,
  ];
  @override
  final String wireName = 'GGetViewerRepositoriesVars';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetViewerRepositoriesVars object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'first',
      serializers.serialize(object.first, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.after;
    if (value != null) {
      result
        ..add('after')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.orderBy;
    if (value != null) {
      result
        ..add('orderBy')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(_i1.GRepositoryOrder),
          ),
        );
    }
    value = object.affiliations;
    if (value != null) {
      result
        ..add('affiliations')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(_i1.GRepositoryAffiliation),
            ]),
          ),
        );
    }
    value = object.privacy;
    if (value != null) {
      result
        ..add('privacy')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(_i1.GRepositoryPrivacy),
          ),
        );
    }
    value = object.isFork;
    if (value != null) {
      result
        ..add('isFork')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(bool)),
        );
    }
    value = object.isLocked;
    if (value != null) {
      result
        ..add('isLocked')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(bool)),
        );
    }
    return result;
  }

  @override
  GGetViewerRepositoriesVars deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetViewerRepositoriesVarsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'first':
          result.first =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'after':
          result.after =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'orderBy':
          result.orderBy.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i1.GRepositoryOrder),
                )!
                as _i1.GRepositoryOrder,
          );
          break;
        case 'affiliations':
          result.affiliations.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(_i1.GRepositoryAffiliation),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'privacy':
          result.privacy =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(_i1.GRepositoryPrivacy),
                  )
                  as _i1.GRepositoryPrivacy?;
          break;
        case 'isFork':
          result.isFork =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool?;
          break;
        case 'isLocked':
          result.isLocked =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$GUserRepositoriesFragmentVarsSerializer
    implements StructuredSerializer<GUserRepositoriesFragmentVars> {
  @override
  final Iterable<Type> types = const [
    GUserRepositoriesFragmentVars,
    _$GUserRepositoriesFragmentVars,
  ];
  @override
  final String wireName = 'GUserRepositoriesFragmentVars';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserRepositoriesFragmentVars object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return <Object?>[];
  }

  @override
  GUserRepositoriesFragmentVars deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return GUserRepositoriesFragmentVarsBuilder().build();
  }
}

class _$GGetUserRepositoriesVars extends GGetUserRepositoriesVars {
  @override
  final String login;
  @override
  final int first;
  @override
  final String? after;
  @override
  final _i1.GRepositoryOrder? orderBy;
  @override
  final BuiltList<_i1.GRepositoryAffiliation>? affiliations;
  @override
  final _i1.GRepositoryPrivacy? privacy;
  @override
  final bool? isFork;
  @override
  final bool? isLocked;

  factory _$GGetUserRepositoriesVars([
    void Function(GGetUserRepositoriesVarsBuilder)? updates,
  ]) => (GGetUserRepositoriesVarsBuilder()..update(updates))._build();

  _$GGetUserRepositoriesVars._({
    required this.login,
    required this.first,
    this.after,
    this.orderBy,
    this.affiliations,
    this.privacy,
    this.isFork,
    this.isLocked,
  }) : super._();
  @override
  GGetUserRepositoriesVars rebuild(
    void Function(GGetUserRepositoriesVarsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetUserRepositoriesVarsBuilder toBuilder() =>
      GGetUserRepositoriesVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetUserRepositoriesVars &&
        login == other.login &&
        first == other.first &&
        after == other.after &&
        orderBy == other.orderBy &&
        affiliations == other.affiliations &&
        privacy == other.privacy &&
        isFork == other.isFork &&
        isLocked == other.isLocked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, login.hashCode);
    _$hash = $jc(_$hash, first.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jc(_$hash, orderBy.hashCode);
    _$hash = $jc(_$hash, affiliations.hashCode);
    _$hash = $jc(_$hash, privacy.hashCode);
    _$hash = $jc(_$hash, isFork.hashCode);
    _$hash = $jc(_$hash, isLocked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetUserRepositoriesVars')
          ..add('login', login)
          ..add('first', first)
          ..add('after', after)
          ..add('orderBy', orderBy)
          ..add('affiliations', affiliations)
          ..add('privacy', privacy)
          ..add('isFork', isFork)
          ..add('isLocked', isLocked))
        .toString();
  }
}

class GGetUserRepositoriesVarsBuilder
    implements
        Builder<GGetUserRepositoriesVars, GGetUserRepositoriesVarsBuilder> {
  _$GGetUserRepositoriesVars? _$v;

  String? _login;
  String? get login => _$this._login;
  set login(String? login) => _$this._login = login;

  int? _first;
  int? get first => _$this._first;
  set first(int? first) => _$this._first = first;

  String? _after;
  String? get after => _$this._after;
  set after(String? after) => _$this._after = after;

  _i1.GRepositoryOrderBuilder? _orderBy;
  _i1.GRepositoryOrderBuilder get orderBy =>
      _$this._orderBy ??= _i1.GRepositoryOrderBuilder();
  set orderBy(_i1.GRepositoryOrderBuilder? orderBy) =>
      _$this._orderBy = orderBy;

  ListBuilder<_i1.GRepositoryAffiliation>? _affiliations;
  ListBuilder<_i1.GRepositoryAffiliation> get affiliations =>
      _$this._affiliations ??= ListBuilder<_i1.GRepositoryAffiliation>();
  set affiliations(ListBuilder<_i1.GRepositoryAffiliation>? affiliations) =>
      _$this._affiliations = affiliations;

  _i1.GRepositoryPrivacy? _privacy;
  _i1.GRepositoryPrivacy? get privacy => _$this._privacy;
  set privacy(_i1.GRepositoryPrivacy? privacy) => _$this._privacy = privacy;

  bool? _isFork;
  bool? get isFork => _$this._isFork;
  set isFork(bool? isFork) => _$this._isFork = isFork;

  bool? _isLocked;
  bool? get isLocked => _$this._isLocked;
  set isLocked(bool? isLocked) => _$this._isLocked = isLocked;

  GGetUserRepositoriesVarsBuilder();

  GGetUserRepositoriesVarsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _login = $v.login;
      _first = $v.first;
      _after = $v.after;
      _orderBy = $v.orderBy?.toBuilder();
      _affiliations = $v.affiliations?.toBuilder();
      _privacy = $v.privacy;
      _isFork = $v.isFork;
      _isLocked = $v.isLocked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetUserRepositoriesVars other) {
    _$v = other as _$GGetUserRepositoriesVars;
  }

  @override
  void update(void Function(GGetUserRepositoriesVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetUserRepositoriesVars build() => _build();

  _$GGetUserRepositoriesVars _build() {
    _$GGetUserRepositoriesVars _$result;
    try {
      _$result =
          _$v ??
          _$GGetUserRepositoriesVars._(
            login: BuiltValueNullFieldError.checkNotNull(
              login,
              r'GGetUserRepositoriesVars',
              'login',
            ),
            first: BuiltValueNullFieldError.checkNotNull(
              first,
              r'GGetUserRepositoriesVars',
              'first',
            ),
            after: after,
            orderBy: _orderBy?.build(),
            affiliations: _affiliations?.build(),
            privacy: privacy,
            isFork: isFork,
            isLocked: isLocked,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orderBy';
        _orderBy?.build();
        _$failedField = 'affiliations';
        _affiliations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetUserRepositoriesVars',
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

class _$GGetViewerRepositoriesVars extends GGetViewerRepositoriesVars {
  @override
  final int first;
  @override
  final String? after;
  @override
  final _i1.GRepositoryOrder? orderBy;
  @override
  final BuiltList<_i1.GRepositoryAffiliation>? affiliations;
  @override
  final _i1.GRepositoryPrivacy? privacy;
  @override
  final bool? isFork;
  @override
  final bool? isLocked;

  factory _$GGetViewerRepositoriesVars([
    void Function(GGetViewerRepositoriesVarsBuilder)? updates,
  ]) => (GGetViewerRepositoriesVarsBuilder()..update(updates))._build();

  _$GGetViewerRepositoriesVars._({
    required this.first,
    this.after,
    this.orderBy,
    this.affiliations,
    this.privacy,
    this.isFork,
    this.isLocked,
  }) : super._();
  @override
  GGetViewerRepositoriesVars rebuild(
    void Function(GGetViewerRepositoriesVarsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetViewerRepositoriesVarsBuilder toBuilder() =>
      GGetViewerRepositoriesVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetViewerRepositoriesVars &&
        first == other.first &&
        after == other.after &&
        orderBy == other.orderBy &&
        affiliations == other.affiliations &&
        privacy == other.privacy &&
        isFork == other.isFork &&
        isLocked == other.isLocked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, first.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jc(_$hash, orderBy.hashCode);
    _$hash = $jc(_$hash, affiliations.hashCode);
    _$hash = $jc(_$hash, privacy.hashCode);
    _$hash = $jc(_$hash, isFork.hashCode);
    _$hash = $jc(_$hash, isLocked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetViewerRepositoriesVars')
          ..add('first', first)
          ..add('after', after)
          ..add('orderBy', orderBy)
          ..add('affiliations', affiliations)
          ..add('privacy', privacy)
          ..add('isFork', isFork)
          ..add('isLocked', isLocked))
        .toString();
  }
}

class GGetViewerRepositoriesVarsBuilder
    implements
        Builder<GGetViewerRepositoriesVars, GGetViewerRepositoriesVarsBuilder> {
  _$GGetViewerRepositoriesVars? _$v;

  int? _first;
  int? get first => _$this._first;
  set first(int? first) => _$this._first = first;

  String? _after;
  String? get after => _$this._after;
  set after(String? after) => _$this._after = after;

  _i1.GRepositoryOrderBuilder? _orderBy;
  _i1.GRepositoryOrderBuilder get orderBy =>
      _$this._orderBy ??= _i1.GRepositoryOrderBuilder();
  set orderBy(_i1.GRepositoryOrderBuilder? orderBy) =>
      _$this._orderBy = orderBy;

  ListBuilder<_i1.GRepositoryAffiliation>? _affiliations;
  ListBuilder<_i1.GRepositoryAffiliation> get affiliations =>
      _$this._affiliations ??= ListBuilder<_i1.GRepositoryAffiliation>();
  set affiliations(ListBuilder<_i1.GRepositoryAffiliation>? affiliations) =>
      _$this._affiliations = affiliations;

  _i1.GRepositoryPrivacy? _privacy;
  _i1.GRepositoryPrivacy? get privacy => _$this._privacy;
  set privacy(_i1.GRepositoryPrivacy? privacy) => _$this._privacy = privacy;

  bool? _isFork;
  bool? get isFork => _$this._isFork;
  set isFork(bool? isFork) => _$this._isFork = isFork;

  bool? _isLocked;
  bool? get isLocked => _$this._isLocked;
  set isLocked(bool? isLocked) => _$this._isLocked = isLocked;

  GGetViewerRepositoriesVarsBuilder();

  GGetViewerRepositoriesVarsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _first = $v.first;
      _after = $v.after;
      _orderBy = $v.orderBy?.toBuilder();
      _affiliations = $v.affiliations?.toBuilder();
      _privacy = $v.privacy;
      _isFork = $v.isFork;
      _isLocked = $v.isLocked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetViewerRepositoriesVars other) {
    _$v = other as _$GGetViewerRepositoriesVars;
  }

  @override
  void update(void Function(GGetViewerRepositoriesVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetViewerRepositoriesVars build() => _build();

  _$GGetViewerRepositoriesVars _build() {
    _$GGetViewerRepositoriesVars _$result;
    try {
      _$result =
          _$v ??
          _$GGetViewerRepositoriesVars._(
            first: BuiltValueNullFieldError.checkNotNull(
              first,
              r'GGetViewerRepositoriesVars',
              'first',
            ),
            after: after,
            orderBy: _orderBy?.build(),
            affiliations: _affiliations?.build(),
            privacy: privacy,
            isFork: isFork,
            isLocked: isLocked,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orderBy';
        _orderBy?.build();
        _$failedField = 'affiliations';
        _affiliations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetViewerRepositoriesVars',
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

class _$GUserRepositoriesFragmentVars extends GUserRepositoriesFragmentVars {
  factory _$GUserRepositoriesFragmentVars([
    void Function(GUserRepositoriesFragmentVarsBuilder)? updates,
  ]) => (GUserRepositoriesFragmentVarsBuilder()..update(updates))._build();

  _$GUserRepositoriesFragmentVars._() : super._();
  @override
  GUserRepositoriesFragmentVars rebuild(
    void Function(GUserRepositoriesFragmentVarsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserRepositoriesFragmentVarsBuilder toBuilder() =>
      GUserRepositoriesFragmentVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserRepositoriesFragmentVars;
  }

  @override
  int get hashCode {
    return 219564551;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper(
      r'GUserRepositoriesFragmentVars',
    ).toString();
  }
}

class GUserRepositoriesFragmentVarsBuilder
    implements
        Builder<
          GUserRepositoriesFragmentVars,
          GUserRepositoriesFragmentVarsBuilder
        > {
  _$GUserRepositoriesFragmentVars? _$v;

  GUserRepositoriesFragmentVarsBuilder();

  @override
  void replace(GUserRepositoriesFragmentVars other) {
    _$v = other as _$GUserRepositoriesFragmentVars;
  }

  @override
  void update(void Function(GUserRepositoriesFragmentVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserRepositoriesFragmentVars build() => _build();

  _$GUserRepositoriesFragmentVars _build() {
    final _$result = _$v ?? _$GUserRepositoriesFragmentVars._();
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
