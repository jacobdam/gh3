// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetFollowingVars> _$gGetFollowingVarsSerializer =
    _$GGetFollowingVarsSerializer();

class _$GGetFollowingVarsSerializer
    implements StructuredSerializer<GGetFollowingVars> {
  @override
  final Iterable<Type> types = const [GGetFollowingVars, _$GGetFollowingVars];
  @override
  final String wireName = 'GGetFollowingVars';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetFollowingVars object, {
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
    return result;
  }

  @override
  GGetFollowingVars deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetFollowingVarsBuilder();

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
      }
    }

    return result.build();
  }
}

class _$GGetFollowingVars extends GGetFollowingVars {
  @override
  final int first;
  @override
  final String? after;

  factory _$GGetFollowingVars([
    void Function(GGetFollowingVarsBuilder)? updates,
  ]) => (GGetFollowingVarsBuilder()..update(updates))._build();

  _$GGetFollowingVars._({required this.first, this.after}) : super._();
  @override
  GGetFollowingVars rebuild(void Function(GGetFollowingVarsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetFollowingVarsBuilder toBuilder() =>
      GGetFollowingVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetFollowingVars &&
        first == other.first &&
        after == other.after;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, first.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetFollowingVars')
          ..add('first', first)
          ..add('after', after))
        .toString();
  }
}

class GGetFollowingVarsBuilder
    implements Builder<GGetFollowingVars, GGetFollowingVarsBuilder> {
  _$GGetFollowingVars? _$v;

  int? _first;
  int? get first => _$this._first;
  set first(int? first) => _$this._first = first;

  String? _after;
  String? get after => _$this._after;
  set after(String? after) => _$this._after = after;

  GGetFollowingVarsBuilder();

  GGetFollowingVarsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _first = $v.first;
      _after = $v.after;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetFollowingVars other) {
    _$v = other as _$GGetFollowingVars;
  }

  @override
  void update(void Function(GGetFollowingVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetFollowingVars build() => _build();

  _$GGetFollowingVars _build() {
    final _$result =
        _$v ??
        _$GGetFollowingVars._(
          first: BuiltValueNullFieldError.checkNotNull(
            first,
            r'GGetFollowingVars',
            'first',
          ),
          after: after,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
