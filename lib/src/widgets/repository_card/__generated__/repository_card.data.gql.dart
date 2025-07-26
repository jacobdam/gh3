// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i2;

part 'repository_card.data.gql.g.dart';

abstract class GRepositoryCardFragment {
  String get G__typename;
  String get id;
  String get name;
  String get nameWithOwner;
  String? get description;
  int get stargazerCount;
  int get forkCount;
  GRepositoryCardFragment_primaryLanguage? get primaryLanguage;
  _i1.GDateTime get updatedAt;
  bool get isPrivate;
}

abstract class GRepositoryCardFragment_primaryLanguage {
  String get G__typename;
  String get name;
  String? get color;
}

abstract class GRepositoryCardFragmentData
    implements
        Built<GRepositoryCardFragmentData, GRepositoryCardFragmentDataBuilder>,
        GRepositoryCardFragment {
  GRepositoryCardFragmentData._();

  factory GRepositoryCardFragmentData(
          [void Function(GRepositoryCardFragmentDataBuilder b) updates]) =
      _$GRepositoryCardFragmentData;

  static void _initializeBuilder(GRepositoryCardFragmentDataBuilder b) =>
      b..G__typename = 'Repository';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get id;
  @override
  String get name;
  @override
  String get nameWithOwner;
  @override
  String? get description;
  @override
  int get stargazerCount;
  @override
  int get forkCount;
  @override
  GRepositoryCardFragmentData_primaryLanguage? get primaryLanguage;
  @override
  _i1.GDateTime get updatedAt;
  @override
  bool get isPrivate;
  static Serializer<GRepositoryCardFragmentData> get serializer =>
      _$gRepositoryCardFragmentDataSerializer;

  Map<String, dynamic> toJson() => (_i2.serializers.serializeWith(
        GRepositoryCardFragmentData.serializer,
        this,
      ) as Map<String, dynamic>);

  static GRepositoryCardFragmentData? fromJson(Map<String, dynamic> json) =>
      _i2.serializers.deserializeWith(
        GRepositoryCardFragmentData.serializer,
        json,
      );
}

abstract class GRepositoryCardFragmentData_primaryLanguage
    implements
        Built<GRepositoryCardFragmentData_primaryLanguage,
            GRepositoryCardFragmentData_primaryLanguageBuilder>,
        GRepositoryCardFragment_primaryLanguage {
  GRepositoryCardFragmentData_primaryLanguage._();

  factory GRepositoryCardFragmentData_primaryLanguage(
      [void Function(GRepositoryCardFragmentData_primaryLanguageBuilder b)
          updates]) = _$GRepositoryCardFragmentData_primaryLanguage;

  static void _initializeBuilder(
          GRepositoryCardFragmentData_primaryLanguageBuilder b) =>
      b..G__typename = 'Language';

  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  @override
  String get name;
  @override
  String? get color;
  static Serializer<GRepositoryCardFragmentData_primaryLanguage>
      get serializer => _$gRepositoryCardFragmentDataPrimaryLanguageSerializer;

  Map<String, dynamic> toJson() => (_i2.serializers.serializeWith(
        GRepositoryCardFragmentData_primaryLanguage.serializer,
        this,
      ) as Map<String, dynamic>);

  static GRepositoryCardFragmentData_primaryLanguage? fromJson(
          Map<String, dynamic> json) =>
      _i2.serializers.deserializeWith(
        GRepositoryCardFragmentData_primaryLanguage.serializer,
        json,
      );
}
