// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gh3/__generated__/serializers.gql.dart' as _i6;
import 'package:gh3/src/screens/user_repositories/__generated__/user_repositories_viewmodel.ast.gql.dart'
    as _i5;
import 'package:gh3/src/screens/user_repositories/__generated__/user_repositories_viewmodel.data.gql.dart'
    as _i2;
import 'package:gh3/src/screens/user_repositories/__generated__/user_repositories_viewmodel.var.gql.dart'
    as _i3;
import 'package:gql/ast.dart' as _i7;
import 'package:gql_exec/gql_exec.dart' as _i4;

part 'user_repositories_viewmodel.req.gql.g.dart';

abstract class GGetUserRepositoriesReq
    implements
        Built<GGetUserRepositoriesReq, GGetUserRepositoriesReqBuilder>,
        _i1.OperationRequest<_i2.GGetUserRepositoriesData,
            _i3.GGetUserRepositoriesVars> {
  GGetUserRepositoriesReq._();

  factory GGetUserRepositoriesReq(
          [void Function(GGetUserRepositoriesReqBuilder b) updates]) =
      _$GGetUserRepositoriesReq;

  static void _initializeBuilder(GGetUserRepositoriesReqBuilder b) => b
    ..operation = _i4.Operation(
      document: _i5.document,
      operationName: 'GetUserRepositories',
    )
    ..executeOnListen = true;

  @override
  _i3.GGetUserRepositoriesVars get vars;
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
  _i2.GGetUserRepositoriesData? Function(
    _i2.GGetUserRepositoriesData?,
    _i2.GGetUserRepositoriesData?,
  )? get updateResult;
  @override
  _i2.GGetUserRepositoriesData? get optimisticResponse;
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
  _i2.GGetUserRepositoriesData? parseData(Map<String, dynamic> json) =>
      _i2.GGetUserRepositoriesData.fromJson(json);

  @override
  Map<String, dynamic> varsToJson() => vars.toJson();

  @override
  Map<String, dynamic> dataToJson(_i2.GGetUserRepositoriesData data) =>
      data.toJson();

  @override
  _i1.OperationRequest<_i2.GGetUserRepositoriesData,
      _i3.GGetUserRepositoriesVars> transformOperation(
          _i4.Operation Function(_i4.Operation) transform) =>
      this.rebuild((b) => b..operation = transform(operation));

  static Serializer<GGetUserRepositoriesReq> get serializer =>
      _$gGetUserRepositoriesReqSerializer;

  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GGetUserRepositoriesReq.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetUserRepositoriesReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GGetUserRepositoriesReq.serializer,
        json,
      );
}

abstract class GGetViewerRepositoriesReq
    implements
        Built<GGetViewerRepositoriesReq, GGetViewerRepositoriesReqBuilder>,
        _i1.OperationRequest<_i2.GGetViewerRepositoriesData,
            _i3.GGetViewerRepositoriesVars> {
  GGetViewerRepositoriesReq._();

  factory GGetViewerRepositoriesReq(
          [void Function(GGetViewerRepositoriesReqBuilder b) updates]) =
      _$GGetViewerRepositoriesReq;

  static void _initializeBuilder(GGetViewerRepositoriesReqBuilder b) => b
    ..operation = _i4.Operation(
      document: _i5.document,
      operationName: 'GetViewerRepositories',
    )
    ..executeOnListen = true;

  @override
  _i3.GGetViewerRepositoriesVars get vars;
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
  _i2.GGetViewerRepositoriesData? Function(
    _i2.GGetViewerRepositoriesData?,
    _i2.GGetViewerRepositoriesData?,
  )? get updateResult;
  @override
  _i2.GGetViewerRepositoriesData? get optimisticResponse;
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
  _i2.GGetViewerRepositoriesData? parseData(Map<String, dynamic> json) =>
      _i2.GGetViewerRepositoriesData.fromJson(json);

  @override
  Map<String, dynamic> varsToJson() => vars.toJson();

  @override
  Map<String, dynamic> dataToJson(_i2.GGetViewerRepositoriesData data) =>
      data.toJson();

  @override
  _i1.OperationRequest<_i2.GGetViewerRepositoriesData,
      _i3.GGetViewerRepositoriesVars> transformOperation(
          _i4.Operation Function(_i4.Operation) transform) =>
      this.rebuild((b) => b..operation = transform(operation));

  static Serializer<GGetViewerRepositoriesReq> get serializer =>
      _$gGetViewerRepositoriesReqSerializer;

  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GGetViewerRepositoriesReq.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetViewerRepositoriesReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GGetViewerRepositoriesReq.serializer,
        json,
      );
}

abstract class GUserRepositoriesFragmentReq
    implements
        Built<GUserRepositoriesFragmentReq,
            GUserRepositoriesFragmentReqBuilder>,
        _i1.FragmentRequest<_i2.GUserRepositoriesFragmentData,
            _i3.GUserRepositoriesFragmentVars> {
  GUserRepositoriesFragmentReq._();

  factory GUserRepositoriesFragmentReq(
          [void Function(GUserRepositoriesFragmentReqBuilder b) updates]) =
      _$GUserRepositoriesFragmentReq;

  static void _initializeBuilder(GUserRepositoriesFragmentReqBuilder b) => b
    ..document = _i5.document
    ..fragmentName = 'UserRepositoriesFragment';

  @override
  _i3.GUserRepositoriesFragmentVars get vars;
  @override
  _i7.DocumentNode get document;
  @override
  String? get fragmentName;
  @override
  Map<String, dynamic> get idFields;
  @override
  _i2.GUserRepositoriesFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GUserRepositoriesFragmentData.fromJson(json);

  @override
  Map<String, dynamic> varsToJson() => vars.toJson();

  @override
  Map<String, dynamic> dataToJson(_i2.GUserRepositoriesFragmentData data) =>
      data.toJson();

  static Serializer<GUserRepositoriesFragmentReq> get serializer =>
      _$gUserRepositoriesFragmentReqSerializer;

  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GUserRepositoriesFragmentReq.serializer,
        this,
      ) as Map<String, dynamic>);

  static GUserRepositoriesFragmentReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GUserRepositoriesFragmentReq.serializer,
        json,
      );
}
