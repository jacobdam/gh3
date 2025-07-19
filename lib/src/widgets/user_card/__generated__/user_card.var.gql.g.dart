// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_card.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GUserCardFragmentVars> _$gUserCardFragmentVarsSerializer =
    _$GUserCardFragmentVarsSerializer();

class _$GUserCardFragmentVarsSerializer
    implements StructuredSerializer<GUserCardFragmentVars> {
  @override
  final Iterable<Type> types = const [
    GUserCardFragmentVars,
    _$GUserCardFragmentVars,
  ];
  @override
  final String wireName = 'GUserCardFragmentVars';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserCardFragmentVars object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return <Object?>[];
  }

  @override
  GUserCardFragmentVars deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return GUserCardFragmentVarsBuilder().build();
  }
}

class _$GUserCardFragmentVars extends GUserCardFragmentVars {
  factory _$GUserCardFragmentVars([
    void Function(GUserCardFragmentVarsBuilder)? updates,
  ]) => (GUserCardFragmentVarsBuilder()..update(updates))._build();

  _$GUserCardFragmentVars._() : super._();
  @override
  GUserCardFragmentVars rebuild(
    void Function(GUserCardFragmentVarsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserCardFragmentVarsBuilder toBuilder() =>
      GUserCardFragmentVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserCardFragmentVars;
  }

  @override
  int get hashCode {
    return 116686241;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper(r'GUserCardFragmentVars').toString();
  }
}

class GUserCardFragmentVarsBuilder
    implements Builder<GUserCardFragmentVars, GUserCardFragmentVarsBuilder> {
  _$GUserCardFragmentVars? _$v;

  GUserCardFragmentVarsBuilder();

  @override
  void replace(GUserCardFragmentVars other) {
    _$v = other as _$GUserCardFragmentVars;
  }

  @override
  void update(void Function(GUserCardFragmentVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserCardFragmentVars build() => _build();

  _$GUserCardFragmentVars _build() {
    final _$result = _$v ?? _$GUserCardFragmentVars._();
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
