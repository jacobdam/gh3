// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_card.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GRepositoryCardFragmentData>
_$gRepositoryCardFragmentDataSerializer =
    _$GRepositoryCardFragmentDataSerializer();
Serializer<GRepositoryCardFragmentData_primaryLanguage>
_$gRepositoryCardFragmentDataPrimaryLanguageSerializer =
    _$GRepositoryCardFragmentData_primaryLanguageSerializer();

class _$GRepositoryCardFragmentDataSerializer
    implements StructuredSerializer<GRepositoryCardFragmentData> {
  @override
  final Iterable<Type> types = const [
    GRepositoryCardFragmentData,
    _$GRepositoryCardFragmentData,
  ];
  @override
  final String wireName = 'GRepositoryCardFragmentData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GRepositoryCardFragmentData object, {
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
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'nameWithOwner',
      serializers.serialize(
        object.nameWithOwner,
        specifiedType: const FullType(String),
      ),
      'stargazerCount',
      serializers.serialize(
        object.stargazerCount,
        specifiedType: const FullType(int),
      ),
      'forkCount',
      serializers.serialize(
        object.forkCount,
        specifiedType: const FullType(int),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(_i1.GDateTime),
      ),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.primaryLanguage;
    if (value != null) {
      result
        ..add('primaryLanguage')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(
              GRepositoryCardFragmentData_primaryLanguage,
            ),
          ),
        );
    }
    return result;
  }

  @override
  GRepositoryCardFragmentData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GRepositoryCardFragmentDataBuilder();

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
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'nameWithOwner':
          result.nameWithOwner =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'description':
          result.description =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'stargazerCount':
          result.stargazerCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'forkCount':
          result.forkCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'primaryLanguage':
          result.primaryLanguage.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GRepositoryCardFragmentData_primaryLanguage,
                  ),
                )!
                as GRepositoryCardFragmentData_primaryLanguage,
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

class _$GRepositoryCardFragmentData_primaryLanguageSerializer
    implements
        StructuredSerializer<GRepositoryCardFragmentData_primaryLanguage> {
  @override
  final Iterable<Type> types = const [
    GRepositoryCardFragmentData_primaryLanguage,
    _$GRepositoryCardFragmentData_primaryLanguage,
  ];
  @override
  final String wireName = 'GRepositoryCardFragmentData_primaryLanguage';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GRepositoryCardFragmentData_primaryLanguage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.color;
    if (value != null) {
      result
        ..add('color')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GRepositoryCardFragmentData_primaryLanguage deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GRepositoryCardFragmentData_primaryLanguageBuilder();

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
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'color':
          result.color =
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

class _$GRepositoryCardFragmentData extends GRepositoryCardFragmentData {
  @override
  final String G__typename;
  @override
  final String id;
  @override
  final String name;
  @override
  final String nameWithOwner;
  @override
  final String? description;
  @override
  final int stargazerCount;
  @override
  final int forkCount;
  @override
  final GRepositoryCardFragmentData_primaryLanguage? primaryLanguage;
  @override
  final _i1.GDateTime updatedAt;

  factory _$GRepositoryCardFragmentData([
    void Function(GRepositoryCardFragmentDataBuilder)? updates,
  ]) => (GRepositoryCardFragmentDataBuilder()..update(updates))._build();

  _$GRepositoryCardFragmentData._({
    required this.G__typename,
    required this.id,
    required this.name,
    required this.nameWithOwner,
    this.description,
    required this.stargazerCount,
    required this.forkCount,
    this.primaryLanguage,
    required this.updatedAt,
  }) : super._();
  @override
  GRepositoryCardFragmentData rebuild(
    void Function(GRepositoryCardFragmentDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GRepositoryCardFragmentDataBuilder toBuilder() =>
      GRepositoryCardFragmentDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GRepositoryCardFragmentData &&
        G__typename == other.G__typename &&
        id == other.id &&
        name == other.name &&
        nameWithOwner == other.nameWithOwner &&
        description == other.description &&
        stargazerCount == other.stargazerCount &&
        forkCount == other.forkCount &&
        primaryLanguage == other.primaryLanguage &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameWithOwner.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, stargazerCount.hashCode);
    _$hash = $jc(_$hash, forkCount.hashCode);
    _$hash = $jc(_$hash, primaryLanguage.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GRepositoryCardFragmentData')
          ..add('G__typename', G__typename)
          ..add('id', id)
          ..add('name', name)
          ..add('nameWithOwner', nameWithOwner)
          ..add('description', description)
          ..add('stargazerCount', stargazerCount)
          ..add('forkCount', forkCount)
          ..add('primaryLanguage', primaryLanguage)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class GRepositoryCardFragmentDataBuilder
    implements
        Builder<
          GRepositoryCardFragmentData,
          GRepositoryCardFragmentDataBuilder
        > {
  _$GRepositoryCardFragmentData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameWithOwner;
  String? get nameWithOwner => _$this._nameWithOwner;
  set nameWithOwner(String? nameWithOwner) =>
      _$this._nameWithOwner = nameWithOwner;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _stargazerCount;
  int? get stargazerCount => _$this._stargazerCount;
  set stargazerCount(int? stargazerCount) =>
      _$this._stargazerCount = stargazerCount;

  int? _forkCount;
  int? get forkCount => _$this._forkCount;
  set forkCount(int? forkCount) => _$this._forkCount = forkCount;

  GRepositoryCardFragmentData_primaryLanguageBuilder? _primaryLanguage;
  GRepositoryCardFragmentData_primaryLanguageBuilder get primaryLanguage =>
      _$this._primaryLanguage ??=
          GRepositoryCardFragmentData_primaryLanguageBuilder();
  set primaryLanguage(
    GRepositoryCardFragmentData_primaryLanguageBuilder? primaryLanguage,
  ) => _$this._primaryLanguage = primaryLanguage;

  _i1.GDateTimeBuilder? _updatedAt;
  _i1.GDateTimeBuilder get updatedAt =>
      _$this._updatedAt ??= _i1.GDateTimeBuilder();
  set updatedAt(_i1.GDateTimeBuilder? updatedAt) =>
      _$this._updatedAt = updatedAt;

  GRepositoryCardFragmentDataBuilder() {
    GRepositoryCardFragmentData._initializeBuilder(this);
  }

  GRepositoryCardFragmentDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _id = $v.id;
      _name = $v.name;
      _nameWithOwner = $v.nameWithOwner;
      _description = $v.description;
      _stargazerCount = $v.stargazerCount;
      _forkCount = $v.forkCount;
      _primaryLanguage = $v.primaryLanguage?.toBuilder();
      _updatedAt = $v.updatedAt.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GRepositoryCardFragmentData other) {
    _$v = other as _$GRepositoryCardFragmentData;
  }

  @override
  void update(void Function(GRepositoryCardFragmentDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GRepositoryCardFragmentData build() => _build();

  _$GRepositoryCardFragmentData _build() {
    _$GRepositoryCardFragmentData _$result;
    try {
      _$result =
          _$v ??
          _$GRepositoryCardFragmentData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GRepositoryCardFragmentData',
              'G__typename',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'GRepositoryCardFragmentData',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'GRepositoryCardFragmentData',
              'name',
            ),
            nameWithOwner: BuiltValueNullFieldError.checkNotNull(
              nameWithOwner,
              r'GRepositoryCardFragmentData',
              'nameWithOwner',
            ),
            description: description,
            stargazerCount: BuiltValueNullFieldError.checkNotNull(
              stargazerCount,
              r'GRepositoryCardFragmentData',
              'stargazerCount',
            ),
            forkCount: BuiltValueNullFieldError.checkNotNull(
              forkCount,
              r'GRepositoryCardFragmentData',
              'forkCount',
            ),
            primaryLanguage: _primaryLanguage?.build(),
            updatedAt: updatedAt.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'primaryLanguage';
        _primaryLanguage?.build();
        _$failedField = 'updatedAt';
        updatedAt.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GRepositoryCardFragmentData',
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

class _$GRepositoryCardFragmentData_primaryLanguage
    extends GRepositoryCardFragmentData_primaryLanguage {
  @override
  final String G__typename;
  @override
  final String name;
  @override
  final String? color;

  factory _$GRepositoryCardFragmentData_primaryLanguage([
    void Function(GRepositoryCardFragmentData_primaryLanguageBuilder)? updates,
  ]) => (GRepositoryCardFragmentData_primaryLanguageBuilder()..update(updates))
      ._build();

  _$GRepositoryCardFragmentData_primaryLanguage._({
    required this.G__typename,
    required this.name,
    this.color,
  }) : super._();
  @override
  GRepositoryCardFragmentData_primaryLanguage rebuild(
    void Function(GRepositoryCardFragmentData_primaryLanguageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GRepositoryCardFragmentData_primaryLanguageBuilder toBuilder() =>
      GRepositoryCardFragmentData_primaryLanguageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GRepositoryCardFragmentData_primaryLanguage &&
        G__typename == other.G__typename &&
        name == other.name &&
        color == other.color;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GRepositoryCardFragmentData_primaryLanguage',
          )
          ..add('G__typename', G__typename)
          ..add('name', name)
          ..add('color', color))
        .toString();
  }
}

class GRepositoryCardFragmentData_primaryLanguageBuilder
    implements
        Builder<
          GRepositoryCardFragmentData_primaryLanguage,
          GRepositoryCardFragmentData_primaryLanguageBuilder
        > {
  _$GRepositoryCardFragmentData_primaryLanguage? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  GRepositoryCardFragmentData_primaryLanguageBuilder() {
    GRepositoryCardFragmentData_primaryLanguage._initializeBuilder(this);
  }

  GRepositoryCardFragmentData_primaryLanguageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _name = $v.name;
      _color = $v.color;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GRepositoryCardFragmentData_primaryLanguage other) {
    _$v = other as _$GRepositoryCardFragmentData_primaryLanguage;
  }

  @override
  void update(
    void Function(GRepositoryCardFragmentData_primaryLanguageBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GRepositoryCardFragmentData_primaryLanguage build() => _build();

  _$GRepositoryCardFragmentData_primaryLanguage _build() {
    final _$result =
        _$v ??
        _$GRepositoryCardFragmentData_primaryLanguage._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GRepositoryCardFragmentData_primaryLanguage',
            'G__typename',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'GRepositoryCardFragmentData_primaryLanguage',
            'name',
          ),
          color: color,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
