// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/serializers.gql.dart' as _i1;

part 'home_viewmodel.var.gql.g.dart';

abstract class GGetFollowingVars
    implements Built<GGetFollowingVars, GGetFollowingVarsBuilder> {
  GGetFollowingVars._();

  factory GGetFollowingVars([
    void Function(GGetFollowingVarsBuilder b) updates,
  ]) = _$GGetFollowingVars;

  int get first;
  String? get after;
  static Serializer<GGetFollowingVars> get serializer =>
      _$gGetFollowingVarsSerializer;

  Map<String, dynamic> toJson() =>
      (_i1.serializers.serializeWith(GGetFollowingVars.serializer, this)
          as Map<String, dynamic>);

  static GGetFollowingVars? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(GGetFollowingVars.serializer, json);
}
