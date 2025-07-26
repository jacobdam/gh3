// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/serializers.gql.dart' as _i1;

part 'repository_card.var.gql.g.dart';

abstract class GRepositoryCardFragmentVars
    implements
        Built<GRepositoryCardFragmentVars, GRepositoryCardFragmentVarsBuilder> {
  GRepositoryCardFragmentVars._();

  factory GRepositoryCardFragmentVars(
          [void Function(GRepositoryCardFragmentVarsBuilder b) updates]) =
      _$GRepositoryCardFragmentVars;

  static Serializer<GRepositoryCardFragmentVars> get serializer =>
      _$gRepositoryCardFragmentVarsSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GRepositoryCardFragmentVars.serializer,
        this,
      ) as Map<String, dynamic>);

  static GRepositoryCardFragmentVars? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GRepositoryCardFragmentVars.serializer,
        json,
      );
}
