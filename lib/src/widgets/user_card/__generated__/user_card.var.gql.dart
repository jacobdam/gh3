// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/serializers.gql.dart' as _i1;

part 'user_card.var.gql.g.dart';

abstract class GUserCardFragmentVars
    implements Built<GUserCardFragmentVars, GUserCardFragmentVarsBuilder> {
  GUserCardFragmentVars._();

  factory GUserCardFragmentVars(
          [void Function(GUserCardFragmentVarsBuilder b) updates]) =
      _$GUserCardFragmentVars;

  static Serializer<GUserCardFragmentVars> get serializer =>
      _$gUserCardFragmentVarsSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUserCardFragmentVars.serializer,
        this,
      ) as Map<String, dynamic>);

  static GUserCardFragmentVars? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUserCardFragmentVars.serializer,
        json,
      );
}
