// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GUserProfileFragmentVars> _$gUserProfileFragmentVarsSerializer =
    _$GUserProfileFragmentVarsSerializer();

class _$GUserProfileFragmentVarsSerializer
    implements StructuredSerializer<GUserProfileFragmentVars> {
  @override
  final Iterable<Type> types = const [
    GUserProfileFragmentVars,
    _$GUserProfileFragmentVars,
  ];
  @override
  final String wireName = 'GUserProfileFragmentVars';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserProfileFragmentVars object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return <Object?>[];
  }

  @override
  GUserProfileFragmentVars deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return GUserProfileFragmentVarsBuilder().build();
  }
}

class _$GUserProfileFragmentVars extends GUserProfileFragmentVars {
  factory _$GUserProfileFragmentVars([
    void Function(GUserProfileFragmentVarsBuilder)? updates,
  ]) => (GUserProfileFragmentVarsBuilder()..update(updates))._build();

  _$GUserProfileFragmentVars._() : super._();
  @override
  GUserProfileFragmentVars rebuild(
    void Function(GUserProfileFragmentVarsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserProfileFragmentVarsBuilder toBuilder() =>
      GUserProfileFragmentVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserProfileFragmentVars;
  }

  @override
  int get hashCode {
    return 155781294;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper(r'GUserProfileFragmentVars').toString();
  }
}

class GUserProfileFragmentVarsBuilder
    implements
        Builder<GUserProfileFragmentVars, GUserProfileFragmentVarsBuilder> {
  _$GUserProfileFragmentVars? _$v;

  GUserProfileFragmentVarsBuilder();

  @override
  void replace(GUserProfileFragmentVars other) {
    _$v = other as _$GUserProfileFragmentVars;
  }

  @override
  void update(void Function(GUserProfileFragmentVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserProfileFragmentVars build() => _build();

  _$GUserProfileFragmentVars _build() {
    final _$result = _$v ?? _$GUserProfileFragmentVars._();
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
