// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i6;
import 'package:gh3/src/widgets/user_profile/__generated__/user_profile.ast.gql.dart'
    as _i4;
import 'package:gh3/src/widgets/user_profile/__generated__/user_profile.data.gql.dart'
    as _i2;
import 'package:gh3/src/widgets/user_profile/__generated__/user_profile.var.gql.dart'
    as _i3;
import 'package:gql/ast.dart' as _i5;

part 'user_profile.req.gql.g.dart';

abstract class GUserProfileFragmentReq
    implements
        Built<GUserProfileFragmentReq, GUserProfileFragmentReqBuilder>,
        _i1.FragmentRequest<_i2.GUserProfileFragmentData,
            _i3.GUserProfileFragmentVars> {
  GUserProfileFragmentReq._();

  factory GUserProfileFragmentReq(
          [void Function(GUserProfileFragmentReqBuilder b) updates]) =
      _$GUserProfileFragmentReq;

  static void _initializeBuilder(GUserProfileFragmentReqBuilder b) => b
    ..document = _i4.document
    ..fragmentName = 'UserProfileFragment';

  @override
  _i3.GUserProfileFragmentVars get vars;
  @override
  _i5.DocumentNode get document;
  @override
  String? get fragmentName;
  @override
  Map<String, dynamic> get idFields;
  @override
  _i2.GUserProfileFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GUserProfileFragmentData.fromJson(json);

  @override
  Map<String, dynamic> varsToJson() => vars.toJson();

  @override
  Map<String, dynamic> dataToJson(_i2.GUserProfileFragmentData data) =>
      data.toJson();

  static Serializer<GUserProfileFragmentReq> get serializer =>
      _$gUserProfileFragmentReqSerializer;

  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GUserProfileFragmentReq.serializer,
        this,
      ) as Map<String, dynamic>);

  static GUserProfileFragmentReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GUserProfileFragmentReq.serializer,
        json,
      );
}
