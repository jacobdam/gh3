// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_card.req.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GUserCardFragmentReq> _$gUserCardFragmentReqSerializer =
    _$GUserCardFragmentReqSerializer();

class _$GUserCardFragmentReqSerializer
    implements StructuredSerializer<GUserCardFragmentReq> {
  @override
  final Iterable<Type> types = const [
    GUserCardFragmentReq,
    _$GUserCardFragmentReq,
  ];
  @override
  final String wireName = 'GUserCardFragmentReq';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserCardFragmentReq object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'vars',
      serializers.serialize(
        object.vars,
        specifiedType: const FullType(_i3.GUserCardFragmentVars),
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
  GUserCardFragmentReq deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserCardFragmentReqBuilder();

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
                  specifiedType: const FullType(_i3.GUserCardFragmentVars),
                )!
                as _i3.GUserCardFragmentVars,
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

class _$GUserCardFragmentReq extends GUserCardFragmentReq {
  @override
  final _i3.GUserCardFragmentVars vars;
  @override
  final _i5.DocumentNode document;
  @override
  final String? fragmentName;
  @override
  final Map<String, dynamic> idFields;

  factory _$GUserCardFragmentReq([
    void Function(GUserCardFragmentReqBuilder)? updates,
  ]) => (GUserCardFragmentReqBuilder()..update(updates))._build();

  _$GUserCardFragmentReq._({
    required this.vars,
    required this.document,
    this.fragmentName,
    required this.idFields,
  }) : super._();
  @override
  GUserCardFragmentReq rebuild(
    void Function(GUserCardFragmentReqBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserCardFragmentReqBuilder toBuilder() =>
      GUserCardFragmentReqBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserCardFragmentReq &&
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
    return (newBuiltValueToStringHelper(r'GUserCardFragmentReq')
          ..add('vars', vars)
          ..add('document', document)
          ..add('fragmentName', fragmentName)
          ..add('idFields', idFields))
        .toString();
  }
}

class GUserCardFragmentReqBuilder
    implements Builder<GUserCardFragmentReq, GUserCardFragmentReqBuilder> {
  _$GUserCardFragmentReq? _$v;

  _i3.GUserCardFragmentVarsBuilder? _vars;
  _i3.GUserCardFragmentVarsBuilder get vars =>
      _$this._vars ??= _i3.GUserCardFragmentVarsBuilder();
  set vars(_i3.GUserCardFragmentVarsBuilder? vars) => _$this._vars = vars;

  _i5.DocumentNode? _document;
  _i5.DocumentNode? get document => _$this._document;
  set document(_i5.DocumentNode? document) => _$this._document = document;

  String? _fragmentName;
  String? get fragmentName => _$this._fragmentName;
  set fragmentName(String? fragmentName) => _$this._fragmentName = fragmentName;

  Map<String, dynamic>? _idFields;
  Map<String, dynamic>? get idFields => _$this._idFields;
  set idFields(Map<String, dynamic>? idFields) => _$this._idFields = idFields;

  GUserCardFragmentReqBuilder() {
    GUserCardFragmentReq._initializeBuilder(this);
  }

  GUserCardFragmentReqBuilder get _$this {
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
  void replace(GUserCardFragmentReq other) {
    _$v = other as _$GUserCardFragmentReq;
  }

  @override
  void update(void Function(GUserCardFragmentReqBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserCardFragmentReq build() => _build();

  _$GUserCardFragmentReq _build() {
    _$GUserCardFragmentReq _$result;
    try {
      _$result =
          _$v ??
          _$GUserCardFragmentReq._(
            vars: vars.build(),
            document: BuiltValueNullFieldError.checkNotNull(
              document,
              r'GUserCardFragmentReq',
              'document',
            ),
            fragmentName: fragmentName,
            idFields: BuiltValueNullFieldError.checkNotNull(
              idFields,
              r'GUserCardFragmentReq',
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
          r'GUserCardFragmentReq',
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
