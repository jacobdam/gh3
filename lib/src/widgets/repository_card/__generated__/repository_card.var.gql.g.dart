// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_card.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GRepositoryCardFragmentVars>
_$gRepositoryCardFragmentVarsSerializer =
    _$GRepositoryCardFragmentVarsSerializer();

class _$GRepositoryCardFragmentVarsSerializer
    implements StructuredSerializer<GRepositoryCardFragmentVars> {
  @override
  final Iterable<Type> types = const [
    GRepositoryCardFragmentVars,
    _$GRepositoryCardFragmentVars,
  ];
  @override
  final String wireName = 'GRepositoryCardFragmentVars';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GRepositoryCardFragmentVars object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return <Object?>[];
  }

  @override
  GRepositoryCardFragmentVars deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return GRepositoryCardFragmentVarsBuilder().build();
  }
}

class _$GRepositoryCardFragmentVars extends GRepositoryCardFragmentVars {
  factory _$GRepositoryCardFragmentVars([
    void Function(GRepositoryCardFragmentVarsBuilder)? updates,
  ]) => (GRepositoryCardFragmentVarsBuilder()..update(updates))._build();

  _$GRepositoryCardFragmentVars._() : super._();
  @override
  GRepositoryCardFragmentVars rebuild(
    void Function(GRepositoryCardFragmentVarsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GRepositoryCardFragmentVarsBuilder toBuilder() =>
      GRepositoryCardFragmentVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GRepositoryCardFragmentVars;
  }

  @override
  int get hashCode {
    return 47258965;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper(
      r'GRepositoryCardFragmentVars',
    ).toString();
  }
}

class GRepositoryCardFragmentVarsBuilder
    implements
        Builder<
          GRepositoryCardFragmentVars,
          GRepositoryCardFragmentVarsBuilder
        > {
  _$GRepositoryCardFragmentVars? _$v;

  GRepositoryCardFragmentVarsBuilder();

  @override
  void replace(GRepositoryCardFragmentVars other) {
    _$v = other as _$GRepositoryCardFragmentVars;
  }

  @override
  void update(void Function(GRepositoryCardFragmentVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GRepositoryCardFragmentVars build() => _build();

  _$GRepositoryCardFragmentVars _build() {
    final _$result = _$v ?? _$GRepositoryCardFragmentVars._();
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
