// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.req.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GUserProfileFragmentReq> _$gUserProfileFragmentReqSerializer =
    _$GUserProfileFragmentReqSerializer();

class _$GUserProfileFragmentReqSerializer
    implements StructuredSerializer<GUserProfileFragmentReq> {
  @override
  final Iterable<Type> types = const [
    GUserProfileFragmentReq,
    _$GUserProfileFragmentReq,
  ];
  @override
  final String wireName = 'GUserProfileFragmentReq';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserProfileFragmentReq object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'vars',
      serializers.serialize(
        object.vars,
        specifiedType: const FullType(_i3.GUserProfileFragmentVars),
      ),
      'document',
      serializers.serialize(
        object.document,
        specifiedType: const FullType(_i5.DocumentNode),
      ),
      'idFields',
      serializers.serialize(
        object.idFields,
        specifiedType: const FullType(Map, const [
          const FullType(String),
          const FullType(dynamic),
        ]),
      ),
    ];
    Object? value;
    value = object.fragmentName;
    if (value != null) {
      result
        ..add('fragmentName')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GUserProfileFragmentReq deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserProfileFragmentReqBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'vars':
          result.vars.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i3.GUserProfileFragmentVars),
                )!
                as _i3.GUserProfileFragmentVars,
          );
          break;
        case 'document':
          result.document =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(_i5.DocumentNode),
                  )!
                  as _i5.DocumentNode;
          break;
        case 'fragmentName':
          result.fragmentName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'idFields':
          result.idFields =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Map, const [
                      const FullType(String),
                      const FullType(dynamic),
                    ]),
                  )!
                  as Map<String, dynamic>;
          break;
      }
    }

    return result.build();
  }
}

class _$GUserProfileFragmentReq extends GUserProfileFragmentReq {
  @override
  final _i3.GUserProfileFragmentVars vars;
  @override
  final _i5.DocumentNode document;
  @override
  final String? fragmentName;
  @override
  final Map<String, dynamic> idFields;

  factory _$GUserProfileFragmentReq([
    void Function(GUserProfileFragmentReqBuilder)? updates,
  ]) => (GUserProfileFragmentReqBuilder()..update(updates))._build();

  _$GUserProfileFragmentReq._({
    required this.vars,
    required this.document,
    this.fragmentName,
    required this.idFields,
  }) : super._();
  @override
  GUserProfileFragmentReq rebuild(
    void Function(GUserProfileFragmentReqBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserProfileFragmentReqBuilder toBuilder() =>
      GUserProfileFragmentReqBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserProfileFragmentReq &&
        vars == other.vars &&
        document == other.document &&
        fragmentName == other.fragmentName &&
        idFields == other.idFields;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vars.hashCode);
    _$hash = $jc(_$hash, document.hashCode);
    _$hash = $jc(_$hash, fragmentName.hashCode);
    _$hash = $jc(_$hash, idFields.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GUserProfileFragmentReq')
          ..add('vars', vars)
          ..add('document', document)
          ..add('fragmentName', fragmentName)
          ..add('idFields', idFields))
        .toString();
  }
}

class GUserProfileFragmentReqBuilder
    implements
        Builder<GUserProfileFragmentReq, GUserProfileFragmentReqBuilder> {
  _$GUserProfileFragmentReq? _$v;

  _i3.GUserProfileFragmentVarsBuilder? _vars;
  _i3.GUserProfileFragmentVarsBuilder get vars =>
      _$this._vars ??= _i3.GUserProfileFragmentVarsBuilder();
  set vars(_i3.GUserProfileFragmentVarsBuilder? vars) => _$this._vars = vars;

  _i5.DocumentNode? _document;
  _i5.DocumentNode? get document => _$this._document;
  set document(_i5.DocumentNode? document) => _$this._document = document;

  String? _fragmentName;
  String? get fragmentName => _$this._fragmentName;
  set fragmentName(String? fragmentName) => _$this._fragmentName = fragmentName;

  Map<String, dynamic>? _idFields;
  Map<String, dynamic>? get idFields => _$this._idFields;
  set idFields(Map<String, dynamic>? idFields) => _$this._idFields = idFields;

  GUserProfileFragmentReqBuilder() {
    GUserProfileFragmentReq._initializeBuilder(this);
  }

  GUserProfileFragmentReqBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vars = $v.vars.toBuilder();
      _document = $v.document;
      _fragmentName = $v.fragmentName;
      _idFields = $v.idFields;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserProfileFragmentReq other) {
    _$v = other as _$GUserProfileFragmentReq;
  }

  @override
  void update(void Function(GUserProfileFragmentReqBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserProfileFragmentReq build() => _build();

  _$GUserProfileFragmentReq _build() {
    _$GUserProfileFragmentReq _$result;
    try {
      _$result =
          _$v ??
          _$GUserProfileFragmentReq._(
            vars: vars.build(),
            document: BuiltValueNullFieldError.checkNotNull(
              document,
              r'GUserProfileFragmentReq',
              'document',
            ),
            fragmentName: fragmentName,
            idFields: BuiltValueNullFieldError.checkNotNull(
              idFields,
              r'GUserProfileFragmentReq',
              'idFields',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vars';
        vars.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GUserProfileFragmentReq',
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

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
