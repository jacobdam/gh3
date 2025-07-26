// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i2;

part 'user_repositories_viewmodel.var.gql.g.dart';

abstract class GGetUserRepositoriesVars
    implements
        Built<GGetUserRepositoriesVars, GGetUserRepositoriesVarsBuilder> {
  GGetUserRepositoriesVars._();

  factory GGetUserRepositoriesVars(
          [void Function(GGetUserRepositoriesVarsBuilder b) updates]) =
      _$GGetUserRepositoriesVars;

  String get login;
  int get first;
  String? get after;
  _i1.GRepositoryOrder? get orderBy;
  BuiltList<_i1.GRepositoryAffiliation>? get affiliations;
  _i1.GRepositoryPrivacy? get privacy;
  bool? get isFork;
  bool? get isLocked;
  static Serializer<GGetUserRepositoriesVars> get serializer =>
      _$gGetUserRepositoriesVarsSerializer;

  Map<String, dynamic> toJson() => (_i2.serializers.serializeWith(
        GGetUserRepositoriesVars.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserRepositoriesVars? fromJson(Map<String, dynamic> json) =>
      _i2.serializers.deserializeWith(
        GGetUserRepositoriesVars.serializer,
        json,
      );
}

abstract class GGetViewerRepositoriesVars
    implements
        Built<GGetViewerRepositoriesVars, GGetViewerRepositoriesVarsBuilder> {
  GGetViewerRepositoriesVars._();

  factory GGetViewerRepositoriesVars(
          [void Function(GGetViewerRepositoriesVarsBuilder b) updates]) =
      _$GGetViewerRepositoriesVars;

  int get first;
  String? get after;
  _i1.GRepositoryOrder? get orderBy;
  BuiltList<_i1.GRepositoryAffiliation>? get affiliations;
  _i1.GRepositoryPrivacy? get privacy;
  bool? get isFork;
  bool? get isLocked;
  static Serializer<GGetViewerRepositoriesVars> get serializer =>
      _$gGetViewerRepositoriesVarsSerializer;

  Map<String, dynamic> toJson() => (_i2.serializers.serializeWith(
        GGetViewerRepositoriesVars.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetViewerRepositoriesVars? fromJson(Map<String, dynamic> json) =>
      _i2.serializers.deserializeWith(
        GGetViewerRepositoriesVars.serializer,
        json,
      );
}

abstract class GUserRepositoriesFragmentVars
    implements
        Built<GUserRepositoriesFragmentVars,
            GUserRepositoriesFragmentVarsBuilder> {
  GUserRepositoriesFragmentVars._();

  factory GUserRepositoriesFragmentVars(
          [void Function(GUserRepositoriesFragmentVarsBuilder b) updates]) =
      _$GUserRepositoriesFragmentVars;

  static Serializer<GUserRepositoriesFragmentVars> get serializer =>
      _$gUserRepositoriesFragmentVarsSerializer;

  Map<String, dynamic> toJson() => (_i2.serializers.serializeWith(
        GUserRepositoriesFragmentVars.serializer,
        this,
      ) as Map<String, dynamic>);

  static GUserRepositoriesFragmentVars? fromJson(Map<String, dynamic> json) =>
      _i2.serializers.deserializeWith(
        GUserRepositoriesFragmentVars.serializer,
        json,
      );
}
