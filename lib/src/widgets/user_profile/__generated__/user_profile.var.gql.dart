// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/serializers.gql.dart' as _i1;

part 'user_profile.var.gql.g.dart';

abstract class GUserProfileFragmentVars
    implements
        Built<GUserProfileFragmentVars, GUserProfileFragmentVarsBuilder> {
  GUserProfileFragmentVars._();

  factory GUserProfileFragmentVars(
          [void Function(GUserProfileFragmentVarsBuilder b) updates]) =
      _$GUserProfileFragmentVars;

  static Serializer<GUserProfileFragmentVars> get serializer =>
      _$gUserProfileFragmentVarsSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUserProfileFragmentVars.serializer,
        this,
      ) as Map<String, dynamic>);

  static GUserProfileFragmentVars? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUserProfileFragmentVars.serializer,
        json,
      );
}
