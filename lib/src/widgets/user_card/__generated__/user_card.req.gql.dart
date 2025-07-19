// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i6;
import 'package:gh3/src/widgets/user_card/__generated__/user_card.ast.gql.dart'
    as _i4;
import 'package:gh3/src/widgets/user_card/__generated__/user_card.data.gql.dart'
    as _i2;
import 'package:gh3/src/widgets/user_card/__generated__/user_card.var.gql.dart'
    as _i3;
import 'package:gql/ast.dart' as _i5;

part 'user_card.req.gql.g.dart';

abstract class GUserCardFragmentReq
    implements
        Built<GUserCardFragmentReq, GUserCardFragmentReqBuilder>,
        _i1.FragmentRequest<
          _i2.GUserCardFragmentData,
          _i3.GUserCardFragmentVars
        > {
  GUserCardFragmentReq._();

  factory GUserCardFragmentReq([
    void Function(GUserCardFragmentReqBuilder b) updates,
  ]) = _$GUserCardFragmentReq;

  static void _initializeBuilder(GUserCardFragmentReqBuilder b) => b
    ..document = _i4.document
    ..fragmentName = 'UserCardFragment';

  @override
  _i3.GUserCardFragmentVars get vars;
  @override
  _i5.DocumentNode get document;
  @override
  String? get fragmentName;
  @override
  Map<String, dynamic> get idFields;
  @override
  _i2.GUserCardFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GUserCardFragmentData.fromJson(json);

  @override
  Map<String, dynamic> varsToJson() => vars.toJson();

  @override
  Map<String, dynamic> dataToJson(_i2.GUserCardFragmentData data) =>
      data.toJson();

  static Serializer<GUserCardFragmentReq> get serializer =>
      _$gUserCardFragmentReqSerializer;

  Map<String, dynamic> toJson() =>
      (_i6.serializers.serializeWith(GUserCardFragmentReq.serializer, this)
          as Map<String, dynamic>);

  static GUserCardFragmentReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(GUserCardFragmentReq.serializer, json);
}
