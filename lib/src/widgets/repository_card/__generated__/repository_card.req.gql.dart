// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i6;
import 'package:gh3/src/widgets/repository_card/__generated__/repository_card.ast.gql.dart'
    as _i4;
import 'package:gh3/src/widgets/repository_card/__generated__/repository_card.data.gql.dart'
    as _i2;
import 'package:gh3/src/widgets/repository_card/__generated__/repository_card.var.gql.dart'
    as _i3;
import 'package:gql/ast.dart' as _i5;

part 'repository_card.req.gql.g.dart';

abstract class GRepositoryCardFragmentReq
    implements
        Built<GRepositoryCardFragmentReq, GRepositoryCardFragmentReqBuilder>,
        _i1.FragmentRequest<
          _i2.GRepositoryCardFragmentData,
          _i3.GRepositoryCardFragmentVars
        > {
  GRepositoryCardFragmentReq._();

  factory GRepositoryCardFragmentReq([
    void Function(GRepositoryCardFragmentReqBuilder b) updates,
  ]) = _$GRepositoryCardFragmentReq;

  static void _initializeBuilder(GRepositoryCardFragmentReqBuilder b) => b
    ..document = _i4.document
    ..fragmentName = 'RepositoryCardFragment';

  @override
  _i3.GRepositoryCardFragmentVars get vars;
  @override
  _i5.DocumentNode get document;
  @override
  String? get fragmentName;
  @override
  Map<String, dynamic> get idFields;
  @override
  _i2.GRepositoryCardFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GRepositoryCardFragmentData.fromJson(json);

  @override
  Map<String, dynamic> varsToJson() => vars.toJson();

  @override
  Map<String, dynamic> dataToJson(_i2.GRepositoryCardFragmentData data) =>
      data.toJson();

  static Serializer<GRepositoryCardFragmentReq> get serializer =>
      _$gRepositoryCardFragmentReqSerializer;

  Map<String, dynamic> toJson() =>
      (_i6.serializers.serializeWith(
            GRepositoryCardFragmentReq.serializer,
            this,
          )
          as Map<String, dynamic>);

  static GRepositoryCardFragmentReq? fromJson(Map<String, dynamic> json) => _i6
      .serializers
      .deserializeWith(GRepositoryCardFragmentReq.serializer, json);
}
