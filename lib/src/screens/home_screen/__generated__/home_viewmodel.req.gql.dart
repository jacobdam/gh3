// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i6;
import 'package:gh3/src/screens/home_screen/__generated__/home_viewmodel.ast.gql.dart'
    as _i5;
import 'package:gh3/src/screens/home_screen/__generated__/home_viewmodel.data.gql.dart'
    as _i2;
import 'package:gh3/src/screens/home_screen/__generated__/home_viewmodel.var.gql.dart'
    as _i3;
import 'package:gql_exec/gql_exec.dart' as _i4;

part 'home_viewmodel.req.gql.g.dart';

abstract class GGetFollowingReq
    implements
        Built<GGetFollowingReq, GGetFollowingReqBuilder>,
        _i1.OperationRequest<_i2.GGetFollowingData, _i3.GGetFollowingVars> {
  GGetFollowingReq._();

  factory GGetFollowingReq([void Function(GGetFollowingReqBuilder b) updates]) =
      _$GGetFollowingReq;

  static void _initializeBuilder(GGetFollowingReqBuilder b) => b
    ..operation = _i4.Operation(
      document: _i5.document,
      operationName: 'GetFollowing',
    )
    ..executeOnListen = true;

  @override
  _i3.GGetFollowingVars get vars;
  @override
  _i4.Operation get operation;
  @override
  _i4.Request get execRequest => _i4.Request(
    operation: operation,
    variables: vars.toJson(),
    context: context ?? const _i4.Context(),
  );

  @override
  String? get requestId;
  @override
  @BuiltValueField(serialize: false)
  _i2.GGetFollowingData? Function(
    _i2.GGetFollowingData?,
    _i2.GGetFollowingData?,
  )?
  get updateResult;
  @override
  _i2.GGetFollowingData? get optimisticResponse;
  @override
  String? get updateCacheHandlerKey;
  @override
  Map<String, dynamic>? get updateCacheHandlerContext;
  @override
  _i1.FetchPolicy? get fetchPolicy;
  @override
  bool get executeOnListen;
  @override
  @BuiltValueField(serialize: false)
  _i4.Context? get context;
  @override
  _i2.GGetFollowingData? parseData(Map<String, dynamic> json) =>
      _i2.GGetFollowingData.fromJson(json);

  @override
  Map<String, dynamic> varsToJson() => vars.toJson();

  @override
  Map<String, dynamic> dataToJson(_i2.GGetFollowingData data) => data.toJson();

  @override
  _i1.OperationRequest<_i2.GGetFollowingData, _i3.GGetFollowingVars>
  transformOperation(_i4.Operation Function(_i4.Operation) transform) =>
      this.rebuild((b) => b..operation = transform(operation));

  static Serializer<GGetFollowingReq> get serializer =>
      _$gGetFollowingReqSerializer;

  Map<String, dynamic> toJson() =>
      (_i6.serializers.serializeWith(GGetFollowingReq.serializer, this)
          as Map<String, dynamic>);

  static GGetFollowingReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(GGetFollowingReq.serializer, json);
}
