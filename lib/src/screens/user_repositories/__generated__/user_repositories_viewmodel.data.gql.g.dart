// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repositories_viewmodel.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetUserRepositoriesData> _$gGetUserRepositoriesDataSerializer =
    _$GGetUserRepositoriesDataSerializer();
Serializer<GGetUserRepositoriesData_user>
_$gGetUserRepositoriesDataUserSerializer =
    _$GGetUserRepositoriesData_userSerializer();
Serializer<GGetUserRepositoriesData_user_repositories>
_$gGetUserRepositoriesDataUserRepositoriesSerializer =
    _$GGetUserRepositoriesData_user_repositoriesSerializer();
Serializer<GGetUserRepositoriesData_user_repositories_pageInfo>
_$gGetUserRepositoriesDataUserRepositoriesPageInfoSerializer =
    _$GGetUserRepositoriesData_user_repositories_pageInfoSerializer();
Serializer<GGetUserRepositoriesData_user_repositories_nodes>
_$gGetUserRepositoriesDataUserRepositoriesNodesSerializer =
    _$GGetUserRepositoriesData_user_repositories_nodesSerializer();
Serializer<GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage>
_$gGetUserRepositoriesDataUserRepositoriesNodesPrimaryLanguageSerializer =
    _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageSerializer();
Serializer<GGetUserRepositoriesData_user_repositories_nodes_owner>
_$gGetUserRepositoriesDataUserRepositoriesNodesOwnerSerializer =
    _$GGetUserRepositoriesData_user_repositories_nodes_ownerSerializer();
Serializer<GGetViewerRepositoriesData> _$gGetViewerRepositoriesDataSerializer =
    _$GGetViewerRepositoriesDataSerializer();
Serializer<GGetViewerRepositoriesData_viewer>
_$gGetViewerRepositoriesDataViewerSerializer =
    _$GGetViewerRepositoriesData_viewerSerializer();
Serializer<GGetViewerRepositoriesData_viewer_repositories>
_$gGetViewerRepositoriesDataViewerRepositoriesSerializer =
    _$GGetViewerRepositoriesData_viewer_repositoriesSerializer();
Serializer<GGetViewerRepositoriesData_viewer_repositories_pageInfo>
_$gGetViewerRepositoriesDataViewerRepositoriesPageInfoSerializer =
    _$GGetViewerRepositoriesData_viewer_repositories_pageInfoSerializer();
Serializer<GGetViewerRepositoriesData_viewer_repositories_nodes>
_$gGetViewerRepositoriesDataViewerRepositoriesNodesSerializer =
    _$GGetViewerRepositoriesData_viewer_repositories_nodesSerializer();
Serializer<GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage>
_$gGetViewerRepositoriesDataViewerRepositoriesNodesPrimaryLanguageSerializer =
    _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageSerializer();
Serializer<GGetViewerRepositoriesData_viewer_repositories_nodes_owner>
_$gGetViewerRepositoriesDataViewerRepositoriesNodesOwnerSerializer =
    _$GGetViewerRepositoriesData_viewer_repositories_nodes_ownerSerializer();
Serializer<GUserRepositoriesFragmentData>
_$gUserRepositoriesFragmentDataSerializer =
    _$GUserRepositoriesFragmentDataSerializer();
Serializer<GUserRepositoriesFragmentData_primaryLanguage>
_$gUserRepositoriesFragmentDataPrimaryLanguageSerializer =
    _$GUserRepositoriesFragmentData_primaryLanguageSerializer();
Serializer<GUserRepositoriesFragmentData_owner>
_$gUserRepositoriesFragmentDataOwnerSerializer =
    _$GUserRepositoriesFragmentData_ownerSerializer();

class _$GGetUserRepositoriesDataSerializer
    implements StructuredSerializer<GGetUserRepositoriesData> {
  @override
  final Iterable<Type> types = const [
    GGetUserRepositoriesData,
    _$GGetUserRepositoriesData,
  ];
  @override
  final String wireName = 'GGetUserRepositoriesData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetUserRepositoriesData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
    ];
    Object? value;
    value = object.user;
    if (value != null) {
      result
        ..add('user')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(GGetUserRepositoriesData_user),
          ),
        );
    }
    return result;
  }

  @override
  GGetUserRepositoriesData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetUserRepositoriesDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'user':
          result.user.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(GGetUserRepositoriesData_user),
                )!
                as GGetUserRepositoriesData_user,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetUserRepositoriesData_userSerializer
    implements StructuredSerializer<GGetUserRepositoriesData_user> {
  @override
  final Iterable<Type> types = const [
    GGetUserRepositoriesData_user,
    _$GGetUserRepositoriesData_user,
  ];
  @override
  final String wireName = 'GGetUserRepositoriesData_user';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetUserRepositoriesData_user object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'repositories',
      serializers.serialize(
        object.repositories,
        specifiedType: const FullType(
          GGetUserRepositoriesData_user_repositories,
        ),
      ),
    ];

    return result;
  }

  @override
  GGetUserRepositoriesData_user deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetUserRepositoriesData_userBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'repositories':
          result.repositories.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetUserRepositoriesData_user_repositories,
                  ),
                )!
                as GGetUserRepositoriesData_user_repositories,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetUserRepositoriesData_user_repositoriesSerializer
    implements
        StructuredSerializer<GGetUserRepositoriesData_user_repositories> {
  @override
  final Iterable<Type> types = const [
    GGetUserRepositoriesData_user_repositories,
    _$GGetUserRepositoriesData_user_repositories,
  ];
  @override
  final String wireName = 'GGetUserRepositoriesData_user_repositories';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetUserRepositoriesData_user_repositories object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'totalCount',
      serializers.serialize(
        object.totalCount,
        specifiedType: const FullType(int),
      ),
      'pageInfo',
      serializers.serialize(
        object.pageInfo,
        specifiedType: const FullType(
          GGetUserRepositoriesData_user_repositories_pageInfo,
        ),
      ),
    ];
    Object? value;
    value = object.nodes;
    if (value != null) {
      result
        ..add('nodes')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType.nullable(
                GGetUserRepositoriesData_user_repositories_nodes,
              ),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  GGetUserRepositoriesData_user_repositories deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetUserRepositoriesData_user_repositoriesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'totalCount':
          result.totalCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'pageInfo':
          result.pageInfo.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetUserRepositoriesData_user_repositories_pageInfo,
                  ),
                )!
                as GGetUserRepositoriesData_user_repositories_pageInfo,
          );
          break;
        case 'nodes':
          result.nodes.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType.nullable(
                      GGetUserRepositoriesData_user_repositories_nodes,
                    ),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetUserRepositoriesData_user_repositories_pageInfoSerializer
    implements
        StructuredSerializer<
          GGetUserRepositoriesData_user_repositories_pageInfo
        > {
  @override
  final Iterable<Type> types = const [
    GGetUserRepositoriesData_user_repositories_pageInfo,
    _$GGetUserRepositoriesData_user_repositories_pageInfo,
  ];
  @override
  final String wireName = 'GGetUserRepositoriesData_user_repositories_pageInfo';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetUserRepositoriesData_user_repositories_pageInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'hasNextPage',
      serializers.serialize(
        object.hasNextPage,
        specifiedType: const FullType(bool),
      ),
      'hasPreviousPage',
      serializers.serialize(
        object.hasPreviousPage,
        specifiedType: const FullType(bool),
      ),
    ];
    Object? value;
    value = object.startCursor;
    if (value != null) {
      result
        ..add('startCursor')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.endCursor;
    if (value != null) {
      result
        ..add('endCursor')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GGetUserRepositoriesData_user_repositories_pageInfo deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetUserRepositoriesData_user_repositories_pageInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'hasNextPage':
          result.hasNextPage =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'hasPreviousPage':
          result.hasPreviousPage =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'startCursor':
          result.startCursor =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'endCursor':
          result.endCursor =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetUserRepositoriesData_user_repositories_nodesSerializer
    implements
        StructuredSerializer<GGetUserRepositoriesData_user_repositories_nodes> {
  @override
  final Iterable<Type> types = const [
    GGetUserRepositoriesData_user_repositories_nodes,
    _$GGetUserRepositoriesData_user_repositories_nodes,
  ];
  @override
  final String wireName = 'GGetUserRepositoriesData_user_repositories_nodes';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetUserRepositoriesData_user_repositories_nodes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'nameWithOwner',
      serializers.serialize(
        object.nameWithOwner,
        specifiedType: const FullType(String),
      ),
      'url',
      serializers.serialize(
        object.url,
        specifiedType: const FullType(_i2.GURI),
      ),
      'isPrivate',
      serializers.serialize(
        object.isPrivate,
        specifiedType: const FullType(bool),
      ),
      'isFork',
      serializers.serialize(object.isFork, specifiedType: const FullType(bool)),
      'isTemplate',
      serializers.serialize(
        object.isTemplate,
        specifiedType: const FullType(bool),
      ),
      'isArchived',
      serializers.serialize(
        object.isArchived,
        specifiedType: const FullType(bool),
      ),
      'isMirror',
      serializers.serialize(
        object.isMirror,
        specifiedType: const FullType(bool),
      ),
      'stargazerCount',
      serializers.serialize(
        object.stargazerCount,
        specifiedType: const FullType(int),
      ),
      'forkCount',
      serializers.serialize(
        object.forkCount,
        specifiedType: const FullType(int),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(_i2.GDateTime),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(_i2.GDateTime),
      ),
      'owner',
      serializers.serialize(
        object.owner,
        specifiedType: const FullType(
          GGetUserRepositoriesData_user_repositories_nodes_owner,
        ),
      ),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.primaryLanguage;
    if (value != null) {
      result
        ..add('primaryLanguage')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(
              GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage,
            ),
          ),
        );
    }
    value = object.pushedAt;
    if (value != null) {
      result
        ..add('pushedAt')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(_i2.GDateTime),
          ),
        );
    }
    return result;
  }

  @override
  GGetUserRepositoriesData_user_repositories_nodes deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetUserRepositoriesData_user_repositories_nodesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'nameWithOwner':
          result.nameWithOwner =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'description':
          result.description =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'url':
          result.url.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GURI),
                )!
                as _i2.GURI,
          );
          break;
        case 'isPrivate':
          result.isPrivate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isFork':
          result.isFork =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isTemplate':
          result.isTemplate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isArchived':
          result.isArchived =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isMirror':
          result.isMirror =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'primaryLanguage':
          result.primaryLanguage.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage,
                  ),
                )!
                as GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage,
          );
          break;
        case 'stargazerCount':
          result.stargazerCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'forkCount':
          result.forkCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'updatedAt':
          result.updatedAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'pushedAt':
          result.pushedAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'createdAt':
          result.createdAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'owner':
          result.owner.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetUserRepositoriesData_user_repositories_nodes_owner,
                  ),
                )!
                as GGetUserRepositoriesData_user_repositories_nodes_owner,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageSerializer
    implements
        StructuredSerializer<
          GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage
        > {
  @override
  final Iterable<Type> types = const [
    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage,
    _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage,
  ];
  @override
  final String wireName =
      'GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.color;
    if (value != null) {
      result
        ..add('color')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'color':
          result.color =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetUserRepositoriesData_user_repositories_nodes_ownerSerializer
    implements
        StructuredSerializer<
          GGetUserRepositoriesData_user_repositories_nodes_owner
        > {
  @override
  final Iterable<Type> types = const [
    GGetUserRepositoriesData_user_repositories_nodes_owner,
    _$GGetUserRepositoriesData_user_repositories_nodes_owner,
  ];
  @override
  final String wireName =
      'GGetUserRepositoriesData_user_repositories_nodes_owner';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetUserRepositoriesData_user_repositories_nodes_owner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'login',
      serializers.serialize(
        object.login,
        specifiedType: const FullType(String),
      ),
      'avatarUrl',
      serializers.serialize(
        object.avatarUrl,
        specifiedType: const FullType(_i2.GURI),
      ),
    ];

    return result;
  }

  @override
  GGetUserRepositoriesData_user_repositories_nodes_owner deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'login':
          result.login =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'avatarUrl':
          result.avatarUrl.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GURI),
                )!
                as _i2.GURI,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetViewerRepositoriesDataSerializer
    implements StructuredSerializer<GGetViewerRepositoriesData> {
  @override
  final Iterable<Type> types = const [
    GGetViewerRepositoriesData,
    _$GGetViewerRepositoriesData,
  ];
  @override
  final String wireName = 'GGetViewerRepositoriesData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetViewerRepositoriesData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'viewer',
      serializers.serialize(
        object.viewer,
        specifiedType: const FullType(GGetViewerRepositoriesData_viewer),
      ),
    ];

    return result;
  }

  @override
  GGetViewerRepositoriesData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetViewerRepositoriesDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'viewer':
          result.viewer.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetViewerRepositoriesData_viewer,
                  ),
                )!
                as GGetViewerRepositoriesData_viewer,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetViewerRepositoriesData_viewerSerializer
    implements StructuredSerializer<GGetViewerRepositoriesData_viewer> {
  @override
  final Iterable<Type> types = const [
    GGetViewerRepositoriesData_viewer,
    _$GGetViewerRepositoriesData_viewer,
  ];
  @override
  final String wireName = 'GGetViewerRepositoriesData_viewer';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetViewerRepositoriesData_viewer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'repositories',
      serializers.serialize(
        object.repositories,
        specifiedType: const FullType(
          GGetViewerRepositoriesData_viewer_repositories,
        ),
      ),
    ];

    return result;
  }

  @override
  GGetViewerRepositoriesData_viewer deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetViewerRepositoriesData_viewerBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'repositories':
          result.repositories.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetViewerRepositoriesData_viewer_repositories,
                  ),
                )!
                as GGetViewerRepositoriesData_viewer_repositories,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetViewerRepositoriesData_viewer_repositoriesSerializer
    implements
        StructuredSerializer<GGetViewerRepositoriesData_viewer_repositories> {
  @override
  final Iterable<Type> types = const [
    GGetViewerRepositoriesData_viewer_repositories,
    _$GGetViewerRepositoriesData_viewer_repositories,
  ];
  @override
  final String wireName = 'GGetViewerRepositoriesData_viewer_repositories';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetViewerRepositoriesData_viewer_repositories object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'totalCount',
      serializers.serialize(
        object.totalCount,
        specifiedType: const FullType(int),
      ),
      'pageInfo',
      serializers.serialize(
        object.pageInfo,
        specifiedType: const FullType(
          GGetViewerRepositoriesData_viewer_repositories_pageInfo,
        ),
      ),
    ];
    Object? value;
    value = object.nodes;
    if (value != null) {
      result
        ..add('nodes')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType.nullable(
                GGetViewerRepositoriesData_viewer_repositories_nodes,
              ),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GGetViewerRepositoriesData_viewer_repositoriesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'totalCount':
          result.totalCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'pageInfo':
          result.pageInfo.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetViewerRepositoriesData_viewer_repositories_pageInfo,
                  ),
                )!
                as GGetViewerRepositoriesData_viewer_repositories_pageInfo,
          );
          break;
        case 'nodes':
          result.nodes.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType.nullable(
                      GGetViewerRepositoriesData_viewer_repositories_nodes,
                    ),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories_pageInfoSerializer
    implements
        StructuredSerializer<
          GGetViewerRepositoriesData_viewer_repositories_pageInfo
        > {
  @override
  final Iterable<Type> types = const [
    GGetViewerRepositoriesData_viewer_repositories_pageInfo,
    _$GGetViewerRepositoriesData_viewer_repositories_pageInfo,
  ];
  @override
  final String wireName =
      'GGetViewerRepositoriesData_viewer_repositories_pageInfo';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetViewerRepositoriesData_viewer_repositories_pageInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'hasNextPage',
      serializers.serialize(
        object.hasNextPage,
        specifiedType: const FullType(bool),
      ),
      'hasPreviousPage',
      serializers.serialize(
        object.hasPreviousPage,
        specifiedType: const FullType(bool),
      ),
    ];
    Object? value;
    value = object.startCursor;
    if (value != null) {
      result
        ..add('startCursor')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.endCursor;
    if (value != null) {
      result
        ..add('endCursor')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories_pageInfo deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'hasNextPage':
          result.hasNextPage =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'hasPreviousPage':
          result.hasPreviousPage =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'startCursor':
          result.startCursor =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'endCursor':
          result.endCursor =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories_nodesSerializer
    implements
        StructuredSerializer<
          GGetViewerRepositoriesData_viewer_repositories_nodes
        > {
  @override
  final Iterable<Type> types = const [
    GGetViewerRepositoriesData_viewer_repositories_nodes,
    _$GGetViewerRepositoriesData_viewer_repositories_nodes,
  ];
  @override
  final String wireName =
      'GGetViewerRepositoriesData_viewer_repositories_nodes';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetViewerRepositoriesData_viewer_repositories_nodes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'nameWithOwner',
      serializers.serialize(
        object.nameWithOwner,
        specifiedType: const FullType(String),
      ),
      'url',
      serializers.serialize(
        object.url,
        specifiedType: const FullType(_i2.GURI),
      ),
      'isPrivate',
      serializers.serialize(
        object.isPrivate,
        specifiedType: const FullType(bool),
      ),
      'isFork',
      serializers.serialize(object.isFork, specifiedType: const FullType(bool)),
      'isTemplate',
      serializers.serialize(
        object.isTemplate,
        specifiedType: const FullType(bool),
      ),
      'isArchived',
      serializers.serialize(
        object.isArchived,
        specifiedType: const FullType(bool),
      ),
      'isMirror',
      serializers.serialize(
        object.isMirror,
        specifiedType: const FullType(bool),
      ),
      'stargazerCount',
      serializers.serialize(
        object.stargazerCount,
        specifiedType: const FullType(int),
      ),
      'forkCount',
      serializers.serialize(
        object.forkCount,
        specifiedType: const FullType(int),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(_i2.GDateTime),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(_i2.GDateTime),
      ),
      'owner',
      serializers.serialize(
        object.owner,
        specifiedType: const FullType(
          GGetViewerRepositoriesData_viewer_repositories_nodes_owner,
        ),
      ),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.primaryLanguage;
    if (value != null) {
      result
        ..add('primaryLanguage')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(
              GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage,
            ),
          ),
        );
    }
    value = object.pushedAt;
    if (value != null) {
      result
        ..add('pushedAt')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(_i2.GDateTime),
          ),
        );
    }
    return result;
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        GGetViewerRepositoriesData_viewer_repositories_nodesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'nameWithOwner':
          result.nameWithOwner =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'description':
          result.description =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'url':
          result.url.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GURI),
                )!
                as _i2.GURI,
          );
          break;
        case 'isPrivate':
          result.isPrivate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isFork':
          result.isFork =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isTemplate':
          result.isTemplate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isArchived':
          result.isArchived =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isMirror':
          result.isMirror =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'primaryLanguage':
          result.primaryLanguage.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage,
                  ),
                )!
                as GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage,
          );
          break;
        case 'stargazerCount':
          result.stargazerCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'forkCount':
          result.forkCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'updatedAt':
          result.updatedAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'pushedAt':
          result.pushedAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'createdAt':
          result.createdAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'owner':
          result.owner.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GGetViewerRepositoriesData_viewer_repositories_nodes_owner,
                  ),
                )!
                as GGetViewerRepositoriesData_viewer_repositories_nodes_owner,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageSerializer
    implements
        StructuredSerializer<
          GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
        > {
  @override
  final Iterable<Type> types = const [
    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage,
    _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage,
  ];
  @override
  final String wireName =
      'GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
    object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.color;
    if (value != null) {
      result
        ..add('color')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
  deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'color':
          result.color =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories_nodes_ownerSerializer
    implements
        StructuredSerializer<
          GGetViewerRepositoriesData_viewer_repositories_nodes_owner
        > {
  @override
  final Iterable<Type> types = const [
    GGetViewerRepositoriesData_viewer_repositories_nodes_owner,
    _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner,
  ];
  @override
  final String wireName =
      'GGetViewerRepositoriesData_viewer_repositories_nodes_owner';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GGetViewerRepositoriesData_viewer_repositories_nodes_owner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'login',
      serializers.serialize(
        object.login,
        specifiedType: const FullType(String),
      ),
      'avatarUrl',
      serializers.serialize(
        object.avatarUrl,
        specifiedType: const FullType(_i2.GURI),
      ),
    ];

    return result;
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_owner deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'login':
          result.login =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'avatarUrl':
          result.avatarUrl.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GURI),
                )!
                as _i2.GURI,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GUserRepositoriesFragmentDataSerializer
    implements StructuredSerializer<GUserRepositoriesFragmentData> {
  @override
  final Iterable<Type> types = const [
    GUserRepositoriesFragmentData,
    _$GUserRepositoriesFragmentData,
  ];
  @override
  final String wireName = 'GUserRepositoriesFragmentData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserRepositoriesFragmentData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'nameWithOwner',
      serializers.serialize(
        object.nameWithOwner,
        specifiedType: const FullType(String),
      ),
      'url',
      serializers.serialize(
        object.url,
        specifiedType: const FullType(_i2.GURI),
      ),
      'isPrivate',
      serializers.serialize(
        object.isPrivate,
        specifiedType: const FullType(bool),
      ),
      'isFork',
      serializers.serialize(object.isFork, specifiedType: const FullType(bool)),
      'isTemplate',
      serializers.serialize(
        object.isTemplate,
        specifiedType: const FullType(bool),
      ),
      'isArchived',
      serializers.serialize(
        object.isArchived,
        specifiedType: const FullType(bool),
      ),
      'isMirror',
      serializers.serialize(
        object.isMirror,
        specifiedType: const FullType(bool),
      ),
      'stargazerCount',
      serializers.serialize(
        object.stargazerCount,
        specifiedType: const FullType(int),
      ),
      'forkCount',
      serializers.serialize(
        object.forkCount,
        specifiedType: const FullType(int),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(_i2.GDateTime),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(_i2.GDateTime),
      ),
      'owner',
      serializers.serialize(
        object.owner,
        specifiedType: const FullType(GUserRepositoriesFragmentData_owner),
      ),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.primaryLanguage;
    if (value != null) {
      result
        ..add('primaryLanguage')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(
              GUserRepositoriesFragmentData_primaryLanguage,
            ),
          ),
        );
    }
    value = object.pushedAt;
    if (value != null) {
      result
        ..add('pushedAt')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(_i2.GDateTime),
          ),
        );
    }
    return result;
  }

  @override
  GUserRepositoriesFragmentData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserRepositoriesFragmentDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'nameWithOwner':
          result.nameWithOwner =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'description':
          result.description =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'url':
          result.url.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GURI),
                )!
                as _i2.GURI,
          );
          break;
        case 'isPrivate':
          result.isPrivate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isFork':
          result.isFork =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isTemplate':
          result.isTemplate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isArchived':
          result.isArchived =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isMirror':
          result.isMirror =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'primaryLanguage':
          result.primaryLanguage.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GUserRepositoriesFragmentData_primaryLanguage,
                  ),
                )!
                as GUserRepositoriesFragmentData_primaryLanguage,
          );
          break;
        case 'stargazerCount':
          result.stargazerCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'forkCount':
          result.forkCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'updatedAt':
          result.updatedAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'pushedAt':
          result.pushedAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'createdAt':
          result.createdAt.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GDateTime),
                )!
                as _i2.GDateTime,
          );
          break;
        case 'owner':
          result.owner.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                    GUserRepositoriesFragmentData_owner,
                  ),
                )!
                as GUserRepositoriesFragmentData_owner,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GUserRepositoriesFragmentData_primaryLanguageSerializer
    implements
        StructuredSerializer<GUserRepositoriesFragmentData_primaryLanguage> {
  @override
  final Iterable<Type> types = const [
    GUserRepositoriesFragmentData_primaryLanguage,
    _$GUserRepositoriesFragmentData_primaryLanguage,
  ];
  @override
  final String wireName = 'GUserRepositoriesFragmentData_primaryLanguage';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserRepositoriesFragmentData_primaryLanguage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.color;
    if (value != null) {
      result
        ..add('color')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  GUserRepositoriesFragmentData_primaryLanguage deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserRepositoriesFragmentData_primaryLanguageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'color':
          result.color =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GUserRepositoriesFragmentData_ownerSerializer
    implements StructuredSerializer<GUserRepositoriesFragmentData_owner> {
  @override
  final Iterable<Type> types = const [
    GUserRepositoriesFragmentData_owner,
    _$GUserRepositoriesFragmentData_owner,
  ];
  @override
  final String wireName = 'GUserRepositoriesFragmentData_owner';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GUserRepositoriesFragmentData_owner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(
        object.G__typename,
        specifiedType: const FullType(String),
      ),
      'login',
      serializers.serialize(
        object.login,
        specifiedType: const FullType(String),
      ),
      'avatarUrl',
      serializers.serialize(
        object.avatarUrl,
        specifiedType: const FullType(_i2.GURI),
      ),
    ];

    return result;
  }

  @override
  GUserRepositoriesFragmentData_owner deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GUserRepositoriesFragmentData_ownerBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'login':
          result.login =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'avatarUrl':
          result.avatarUrl.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(_i2.GURI),
                )!
                as _i2.GURI,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$GGetUserRepositoriesData extends GGetUserRepositoriesData {
  @override
  final String G__typename;
  @override
  final GGetUserRepositoriesData_user? user;

  factory _$GGetUserRepositoriesData([
    void Function(GGetUserRepositoriesDataBuilder)? updates,
  ]) => (GGetUserRepositoriesDataBuilder()..update(updates))._build();

  _$GGetUserRepositoriesData._({required this.G__typename, this.user})
    : super._();
  @override
  GGetUserRepositoriesData rebuild(
    void Function(GGetUserRepositoriesDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetUserRepositoriesDataBuilder toBuilder() =>
      GGetUserRepositoriesDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetUserRepositoriesData &&
        G__typename == other.G__typename &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetUserRepositoriesData')
          ..add('G__typename', G__typename)
          ..add('user', user))
        .toString();
  }
}

class GGetUserRepositoriesDataBuilder
    implements
        Builder<GGetUserRepositoriesData, GGetUserRepositoriesDataBuilder> {
  _$GGetUserRepositoriesData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GGetUserRepositoriesData_userBuilder? _user;
  GGetUserRepositoriesData_userBuilder get user =>
      _$this._user ??= GGetUserRepositoriesData_userBuilder();
  set user(GGetUserRepositoriesData_userBuilder? user) => _$this._user = user;

  GGetUserRepositoriesDataBuilder() {
    GGetUserRepositoriesData._initializeBuilder(this);
  }

  GGetUserRepositoriesDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetUserRepositoriesData other) {
    _$v = other as _$GGetUserRepositoriesData;
  }

  @override
  void update(void Function(GGetUserRepositoriesDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetUserRepositoriesData build() => _build();

  _$GGetUserRepositoriesData _build() {
    _$GGetUserRepositoriesData _$result;
    try {
      _$result =
          _$v ??
          _$GGetUserRepositoriesData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetUserRepositoriesData',
              'G__typename',
            ),
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetUserRepositoriesData',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetUserRepositoriesData_user extends GGetUserRepositoriesData_user {
  @override
  final String G__typename;
  @override
  final GGetUserRepositoriesData_user_repositories repositories;

  factory _$GGetUserRepositoriesData_user([
    void Function(GGetUserRepositoriesData_userBuilder)? updates,
  ]) => (GGetUserRepositoriesData_userBuilder()..update(updates))._build();

  _$GGetUserRepositoriesData_user._({
    required this.G__typename,
    required this.repositories,
  }) : super._();
  @override
  GGetUserRepositoriesData_user rebuild(
    void Function(GGetUserRepositoriesData_userBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetUserRepositoriesData_userBuilder toBuilder() =>
      GGetUserRepositoriesData_userBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetUserRepositoriesData_user &&
        G__typename == other.G__typename &&
        repositories == other.repositories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, repositories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetUserRepositoriesData_user')
          ..add('G__typename', G__typename)
          ..add('repositories', repositories))
        .toString();
  }
}

class GGetUserRepositoriesData_userBuilder
    implements
        Builder<
          GGetUserRepositoriesData_user,
          GGetUserRepositoriesData_userBuilder
        > {
  _$GGetUserRepositoriesData_user? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GGetUserRepositoriesData_user_repositoriesBuilder? _repositories;
  GGetUserRepositoriesData_user_repositoriesBuilder get repositories =>
      _$this._repositories ??=
          GGetUserRepositoriesData_user_repositoriesBuilder();
  set repositories(
    GGetUserRepositoriesData_user_repositoriesBuilder? repositories,
  ) => _$this._repositories = repositories;

  GGetUserRepositoriesData_userBuilder() {
    GGetUserRepositoriesData_user._initializeBuilder(this);
  }

  GGetUserRepositoriesData_userBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _repositories = $v.repositories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetUserRepositoriesData_user other) {
    _$v = other as _$GGetUserRepositoriesData_user;
  }

  @override
  void update(void Function(GGetUserRepositoriesData_userBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetUserRepositoriesData_user build() => _build();

  _$GGetUserRepositoriesData_user _build() {
    _$GGetUserRepositoriesData_user _$result;
    try {
      _$result =
          _$v ??
          _$GGetUserRepositoriesData_user._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetUserRepositoriesData_user',
              'G__typename',
            ),
            repositories: repositories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'repositories';
        repositories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetUserRepositoriesData_user',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetUserRepositoriesData_user_repositories
    extends GGetUserRepositoriesData_user_repositories {
  @override
  final String G__typename;
  @override
  final int totalCount;
  @override
  final GGetUserRepositoriesData_user_repositories_pageInfo pageInfo;
  @override
  final BuiltList<GGetUserRepositoriesData_user_repositories_nodes?>? nodes;

  factory _$GGetUserRepositoriesData_user_repositories([
    void Function(GGetUserRepositoriesData_user_repositoriesBuilder)? updates,
  ]) => (GGetUserRepositoriesData_user_repositoriesBuilder()..update(updates))
      ._build();

  _$GGetUserRepositoriesData_user_repositories._({
    required this.G__typename,
    required this.totalCount,
    required this.pageInfo,
    this.nodes,
  }) : super._();
  @override
  GGetUserRepositoriesData_user_repositories rebuild(
    void Function(GGetUserRepositoriesData_user_repositoriesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetUserRepositoriesData_user_repositoriesBuilder toBuilder() =>
      GGetUserRepositoriesData_user_repositoriesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetUserRepositoriesData_user_repositories &&
        G__typename == other.G__typename &&
        totalCount == other.totalCount &&
        pageInfo == other.pageInfo &&
        nodes == other.nodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, totalCount.hashCode);
    _$hash = $jc(_$hash, pageInfo.hashCode);
    _$hash = $jc(_$hash, nodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetUserRepositoriesData_user_repositories',
          )
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount)
          ..add('pageInfo', pageInfo)
          ..add('nodes', nodes))
        .toString();
  }
}

class GGetUserRepositoriesData_user_repositoriesBuilder
    implements
        Builder<
          GGetUserRepositoriesData_user_repositories,
          GGetUserRepositoriesData_user_repositoriesBuilder
        > {
  _$GGetUserRepositoriesData_user_repositories? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GGetUserRepositoriesData_user_repositories_pageInfoBuilder? _pageInfo;
  GGetUserRepositoriesData_user_repositories_pageInfoBuilder get pageInfo =>
      _$this._pageInfo ??=
          GGetUserRepositoriesData_user_repositories_pageInfoBuilder();
  set pageInfo(
    GGetUserRepositoriesData_user_repositories_pageInfoBuilder? pageInfo,
  ) => _$this._pageInfo = pageInfo;

  ListBuilder<GGetUserRepositoriesData_user_repositories_nodes?>? _nodes;
  ListBuilder<GGetUserRepositoriesData_user_repositories_nodes?> get nodes =>
      _$this._nodes ??=
          ListBuilder<GGetUserRepositoriesData_user_repositories_nodes?>();
  set nodes(
    ListBuilder<GGetUserRepositoriesData_user_repositories_nodes?>? nodes,
  ) => _$this._nodes = nodes;

  GGetUserRepositoriesData_user_repositoriesBuilder() {
    GGetUserRepositoriesData_user_repositories._initializeBuilder(this);
  }

  GGetUserRepositoriesData_user_repositoriesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _pageInfo = $v.pageInfo.toBuilder();
      _nodes = $v.nodes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetUserRepositoriesData_user_repositories other) {
    _$v = other as _$GGetUserRepositoriesData_user_repositories;
  }

  @override
  void update(
    void Function(GGetUserRepositoriesData_user_repositoriesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetUserRepositoriesData_user_repositories build() => _build();

  _$GGetUserRepositoriesData_user_repositories _build() {
    _$GGetUserRepositoriesData_user_repositories _$result;
    try {
      _$result =
          _$v ??
          _$GGetUserRepositoriesData_user_repositories._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetUserRepositoriesData_user_repositories',
              'G__typename',
            ),
            totalCount: BuiltValueNullFieldError.checkNotNull(
              totalCount,
              r'GGetUserRepositoriesData_user_repositories',
              'totalCount',
            ),
            pageInfo: pageInfo.build(),
            nodes: _nodes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pageInfo';
        pageInfo.build();
        _$failedField = 'nodes';
        _nodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetUserRepositoriesData_user_repositories',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetUserRepositoriesData_user_repositories_pageInfo
    extends GGetUserRepositoriesData_user_repositories_pageInfo {
  @override
  final String G__typename;
  @override
  final bool hasNextPage;
  @override
  final bool hasPreviousPage;
  @override
  final String? startCursor;
  @override
  final String? endCursor;

  factory _$GGetUserRepositoriesData_user_repositories_pageInfo([
    void Function(GGetUserRepositoriesData_user_repositories_pageInfoBuilder)?
    updates,
  ]) =>
      (GGetUserRepositoriesData_user_repositories_pageInfoBuilder()
            ..update(updates))
          ._build();

  _$GGetUserRepositoriesData_user_repositories_pageInfo._({
    required this.G__typename,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  }) : super._();
  @override
  GGetUserRepositoriesData_user_repositories_pageInfo rebuild(
    void Function(GGetUserRepositoriesData_user_repositories_pageInfoBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetUserRepositoriesData_user_repositories_pageInfoBuilder toBuilder() =>
      GGetUserRepositoriesData_user_repositories_pageInfoBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetUserRepositoriesData_user_repositories_pageInfo &&
        G__typename == other.G__typename &&
        hasNextPage == other.hasNextPage &&
        hasPreviousPage == other.hasPreviousPage &&
        startCursor == other.startCursor &&
        endCursor == other.endCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, hasNextPage.hashCode);
    _$hash = $jc(_$hash, hasPreviousPage.hashCode);
    _$hash = $jc(_$hash, startCursor.hashCode);
    _$hash = $jc(_$hash, endCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetUserRepositoriesData_user_repositories_pageInfo',
          )
          ..add('G__typename', G__typename)
          ..add('hasNextPage', hasNextPage)
          ..add('hasPreviousPage', hasPreviousPage)
          ..add('startCursor', startCursor)
          ..add('endCursor', endCursor))
        .toString();
  }
}

class GGetUserRepositoriesData_user_repositories_pageInfoBuilder
    implements
        Builder<
          GGetUserRepositoriesData_user_repositories_pageInfo,
          GGetUserRepositoriesData_user_repositories_pageInfoBuilder
        > {
  _$GGetUserRepositoriesData_user_repositories_pageInfo? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  bool? _hasNextPage;
  bool? get hasNextPage => _$this._hasNextPage;
  set hasNextPage(bool? hasNextPage) => _$this._hasNextPage = hasNextPage;

  bool? _hasPreviousPage;
  bool? get hasPreviousPage => _$this._hasPreviousPage;
  set hasPreviousPage(bool? hasPreviousPage) =>
      _$this._hasPreviousPage = hasPreviousPage;

  String? _startCursor;
  String? get startCursor => _$this._startCursor;
  set startCursor(String? startCursor) => _$this._startCursor = startCursor;

  String? _endCursor;
  String? get endCursor => _$this._endCursor;
  set endCursor(String? endCursor) => _$this._endCursor = endCursor;

  GGetUserRepositoriesData_user_repositories_pageInfoBuilder() {
    GGetUserRepositoriesData_user_repositories_pageInfo._initializeBuilder(
      this,
    );
  }

  GGetUserRepositoriesData_user_repositories_pageInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _hasNextPage = $v.hasNextPage;
      _hasPreviousPage = $v.hasPreviousPage;
      _startCursor = $v.startCursor;
      _endCursor = $v.endCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetUserRepositoriesData_user_repositories_pageInfo other) {
    _$v = other as _$GGetUserRepositoriesData_user_repositories_pageInfo;
  }

  @override
  void update(
    void Function(GGetUserRepositoriesData_user_repositories_pageInfoBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetUserRepositoriesData_user_repositories_pageInfo build() => _build();

  _$GGetUserRepositoriesData_user_repositories_pageInfo _build() {
    final _$result =
        _$v ??
        _$GGetUserRepositoriesData_user_repositories_pageInfo._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetUserRepositoriesData_user_repositories_pageInfo',
            'G__typename',
          ),
          hasNextPage: BuiltValueNullFieldError.checkNotNull(
            hasNextPage,
            r'GGetUserRepositoriesData_user_repositories_pageInfo',
            'hasNextPage',
          ),
          hasPreviousPage: BuiltValueNullFieldError.checkNotNull(
            hasPreviousPage,
            r'GGetUserRepositoriesData_user_repositories_pageInfo',
            'hasPreviousPage',
          ),
          startCursor: startCursor,
          endCursor: endCursor,
        );
    replace(_$result);
    return _$result;
  }
}

class _$GGetUserRepositoriesData_user_repositories_nodes
    extends GGetUserRepositoriesData_user_repositories_nodes {
  @override
  final String G__typename;
  @override
  final String id;
  @override
  final String name;
  @override
  final String nameWithOwner;
  @override
  final String? description;
  @override
  final _i2.GURI url;
  @override
  final bool isPrivate;
  @override
  final bool isFork;
  @override
  final bool isTemplate;
  @override
  final bool isArchived;
  @override
  final bool isMirror;
  @override
  final GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage?
  primaryLanguage;
  @override
  final int stargazerCount;
  @override
  final int forkCount;
  @override
  final _i2.GDateTime updatedAt;
  @override
  final _i2.GDateTime? pushedAt;
  @override
  final _i2.GDateTime createdAt;
  @override
  final GGetUserRepositoriesData_user_repositories_nodes_owner owner;

  factory _$GGetUserRepositoriesData_user_repositories_nodes([
    void Function(GGetUserRepositoriesData_user_repositories_nodesBuilder)?
    updates,
  ]) =>
      (GGetUserRepositoriesData_user_repositories_nodesBuilder()
            ..update(updates))
          ._build();

  _$GGetUserRepositoriesData_user_repositories_nodes._({
    required this.G__typename,
    required this.id,
    required this.name,
    required this.nameWithOwner,
    this.description,
    required this.url,
    required this.isPrivate,
    required this.isFork,
    required this.isTemplate,
    required this.isArchived,
    required this.isMirror,
    this.primaryLanguage,
    required this.stargazerCount,
    required this.forkCount,
    required this.updatedAt,
    this.pushedAt,
    required this.createdAt,
    required this.owner,
  }) : super._();
  @override
  GGetUserRepositoriesData_user_repositories_nodes rebuild(
    void Function(GGetUserRepositoriesData_user_repositories_nodesBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetUserRepositoriesData_user_repositories_nodesBuilder toBuilder() =>
      GGetUserRepositoriesData_user_repositories_nodesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetUserRepositoriesData_user_repositories_nodes &&
        G__typename == other.G__typename &&
        id == other.id &&
        name == other.name &&
        nameWithOwner == other.nameWithOwner &&
        description == other.description &&
        url == other.url &&
        isPrivate == other.isPrivate &&
        isFork == other.isFork &&
        isTemplate == other.isTemplate &&
        isArchived == other.isArchived &&
        isMirror == other.isMirror &&
        primaryLanguage == other.primaryLanguage &&
        stargazerCount == other.stargazerCount &&
        forkCount == other.forkCount &&
        updatedAt == other.updatedAt &&
        pushedAt == other.pushedAt &&
        createdAt == other.createdAt &&
        owner == other.owner;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameWithOwner.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, isPrivate.hashCode);
    _$hash = $jc(_$hash, isFork.hashCode);
    _$hash = $jc(_$hash, isTemplate.hashCode);
    _$hash = $jc(_$hash, isArchived.hashCode);
    _$hash = $jc(_$hash, isMirror.hashCode);
    _$hash = $jc(_$hash, primaryLanguage.hashCode);
    _$hash = $jc(_$hash, stargazerCount.hashCode);
    _$hash = $jc(_$hash, forkCount.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, pushedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetUserRepositoriesData_user_repositories_nodes',
          )
          ..add('G__typename', G__typename)
          ..add('id', id)
          ..add('name', name)
          ..add('nameWithOwner', nameWithOwner)
          ..add('description', description)
          ..add('url', url)
          ..add('isPrivate', isPrivate)
          ..add('isFork', isFork)
          ..add('isTemplate', isTemplate)
          ..add('isArchived', isArchived)
          ..add('isMirror', isMirror)
          ..add('primaryLanguage', primaryLanguage)
          ..add('stargazerCount', stargazerCount)
          ..add('forkCount', forkCount)
          ..add('updatedAt', updatedAt)
          ..add('pushedAt', pushedAt)
          ..add('createdAt', createdAt)
          ..add('owner', owner))
        .toString();
  }
}

class GGetUserRepositoriesData_user_repositories_nodesBuilder
    implements
        Builder<
          GGetUserRepositoriesData_user_repositories_nodes,
          GGetUserRepositoriesData_user_repositories_nodesBuilder
        > {
  _$GGetUserRepositoriesData_user_repositories_nodes? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameWithOwner;
  String? get nameWithOwner => _$this._nameWithOwner;
  set nameWithOwner(String? nameWithOwner) =>
      _$this._nameWithOwner = nameWithOwner;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  _i2.GURIBuilder? _url;
  _i2.GURIBuilder get url => _$this._url ??= _i2.GURIBuilder();
  set url(_i2.GURIBuilder? url) => _$this._url = url;

  bool? _isPrivate;
  bool? get isPrivate => _$this._isPrivate;
  set isPrivate(bool? isPrivate) => _$this._isPrivate = isPrivate;

  bool? _isFork;
  bool? get isFork => _$this._isFork;
  set isFork(bool? isFork) => _$this._isFork = isFork;

  bool? _isTemplate;
  bool? get isTemplate => _$this._isTemplate;
  set isTemplate(bool? isTemplate) => _$this._isTemplate = isTemplate;

  bool? _isArchived;
  bool? get isArchived => _$this._isArchived;
  set isArchived(bool? isArchived) => _$this._isArchived = isArchived;

  bool? _isMirror;
  bool? get isMirror => _$this._isMirror;
  set isMirror(bool? isMirror) => _$this._isMirror = isMirror;

  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder?
  _primaryLanguage;
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder
  get primaryLanguage => _$this._primaryLanguage ??=
      GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder();
  set primaryLanguage(
    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder?
    primaryLanguage,
  ) => _$this._primaryLanguage = primaryLanguage;

  int? _stargazerCount;
  int? get stargazerCount => _$this._stargazerCount;
  set stargazerCount(int? stargazerCount) =>
      _$this._stargazerCount = stargazerCount;

  int? _forkCount;
  int? get forkCount => _$this._forkCount;
  set forkCount(int? forkCount) => _$this._forkCount = forkCount;

  _i2.GDateTimeBuilder? _updatedAt;
  _i2.GDateTimeBuilder get updatedAt =>
      _$this._updatedAt ??= _i2.GDateTimeBuilder();
  set updatedAt(_i2.GDateTimeBuilder? updatedAt) =>
      _$this._updatedAt = updatedAt;

  _i2.GDateTimeBuilder? _pushedAt;
  _i2.GDateTimeBuilder get pushedAt =>
      _$this._pushedAt ??= _i2.GDateTimeBuilder();
  set pushedAt(_i2.GDateTimeBuilder? pushedAt) => _$this._pushedAt = pushedAt;

  _i2.GDateTimeBuilder? _createdAt;
  _i2.GDateTimeBuilder get createdAt =>
      _$this._createdAt ??= _i2.GDateTimeBuilder();
  set createdAt(_i2.GDateTimeBuilder? createdAt) =>
      _$this._createdAt = createdAt;

  GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder? _owner;
  GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder get owner =>
      _$this._owner ??=
          GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder();
  set owner(
    GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder? owner,
  ) => _$this._owner = owner;

  GGetUserRepositoriesData_user_repositories_nodesBuilder() {
    GGetUserRepositoriesData_user_repositories_nodes._initializeBuilder(this);
  }

  GGetUserRepositoriesData_user_repositories_nodesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _id = $v.id;
      _name = $v.name;
      _nameWithOwner = $v.nameWithOwner;
      _description = $v.description;
      _url = $v.url.toBuilder();
      _isPrivate = $v.isPrivate;
      _isFork = $v.isFork;
      _isTemplate = $v.isTemplate;
      _isArchived = $v.isArchived;
      _isMirror = $v.isMirror;
      _primaryLanguage = $v.primaryLanguage?.toBuilder();
      _stargazerCount = $v.stargazerCount;
      _forkCount = $v.forkCount;
      _updatedAt = $v.updatedAt.toBuilder();
      _pushedAt = $v.pushedAt?.toBuilder();
      _createdAt = $v.createdAt.toBuilder();
      _owner = $v.owner.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetUserRepositoriesData_user_repositories_nodes other) {
    _$v = other as _$GGetUserRepositoriesData_user_repositories_nodes;
  }

  @override
  void update(
    void Function(GGetUserRepositoriesData_user_repositories_nodesBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetUserRepositoriesData_user_repositories_nodes build() => _build();

  _$GGetUserRepositoriesData_user_repositories_nodes _build() {
    _$GGetUserRepositoriesData_user_repositories_nodes _$result;
    try {
      _$result =
          _$v ??
          _$GGetUserRepositoriesData_user_repositories_nodes._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'G__typename',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'name',
            ),
            nameWithOwner: BuiltValueNullFieldError.checkNotNull(
              nameWithOwner,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'nameWithOwner',
            ),
            description: description,
            url: url.build(),
            isPrivate: BuiltValueNullFieldError.checkNotNull(
              isPrivate,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'isPrivate',
            ),
            isFork: BuiltValueNullFieldError.checkNotNull(
              isFork,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'isFork',
            ),
            isTemplate: BuiltValueNullFieldError.checkNotNull(
              isTemplate,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'isTemplate',
            ),
            isArchived: BuiltValueNullFieldError.checkNotNull(
              isArchived,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'isArchived',
            ),
            isMirror: BuiltValueNullFieldError.checkNotNull(
              isMirror,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'isMirror',
            ),
            primaryLanguage: _primaryLanguage?.build(),
            stargazerCount: BuiltValueNullFieldError.checkNotNull(
              stargazerCount,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'stargazerCount',
            ),
            forkCount: BuiltValueNullFieldError.checkNotNull(
              forkCount,
              r'GGetUserRepositoriesData_user_repositories_nodes',
              'forkCount',
            ),
            updatedAt: updatedAt.build(),
            pushedAt: _pushedAt?.build(),
            createdAt: createdAt.build(),
            owner: owner.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'url';
        url.build();

        _$failedField = 'primaryLanguage';
        _primaryLanguage?.build();

        _$failedField = 'updatedAt';
        updatedAt.build();
        _$failedField = 'pushedAt';
        _pushedAt?.build();
        _$failedField = 'createdAt';
        createdAt.build();
        _$failedField = 'owner';
        owner.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetUserRepositoriesData_user_repositories_nodes',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage
    extends GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage {
  @override
  final String G__typename;
  @override
  final String name;
  @override
  final String? color;

  factory _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage([
    void Function(
      GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder,
    )?
    updates,
  ]) =>
      (GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder()
            ..update(updates))
          ._build();

  _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage._({
    required this.G__typename,
    required this.name,
    this.color,
  }) : super._();
  @override
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage rebuild(
    void Function(
      GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder
  toBuilder() =>
      GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage &&
        G__typename == other.G__typename &&
        name == other.name &&
        color == other.color;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage',
          )
          ..add('G__typename', G__typename)
          ..add('name', name)
          ..add('color', color))
        .toString();
  }
}

class GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder
    implements
        Builder<
          GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage,
          GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder
        > {
  _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder() {
    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage._initializeBuilder(
      this,
    );
  }

  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _name = $v.name;
      _color = $v.color;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage other,
  ) {
    _$v =
        other
            as _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage;
  }

  @override
  void update(
    void Function(
      GGetUserRepositoriesData_user_repositories_nodes_primaryLanguageBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage build() =>
      _build();

  _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage _build() {
    final _$result =
        _$v ??
        _$GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage',
            'G__typename',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'GGetUserRepositoriesData_user_repositories_nodes_primaryLanguage',
            'name',
          ),
          color: color,
        );
    replace(_$result);
    return _$result;
  }
}

class _$GGetUserRepositoriesData_user_repositories_nodes_owner
    extends GGetUserRepositoriesData_user_repositories_nodes_owner {
  @override
  final String G__typename;
  @override
  final String login;
  @override
  final _i2.GURI avatarUrl;

  factory _$GGetUserRepositoriesData_user_repositories_nodes_owner([
    void Function(
      GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder,
    )?
    updates,
  ]) =>
      (GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder()
            ..update(updates))
          ._build();

  _$GGetUserRepositoriesData_user_repositories_nodes_owner._({
    required this.G__typename,
    required this.login,
    required this.avatarUrl,
  }) : super._();
  @override
  GGetUserRepositoriesData_user_repositories_nodes_owner rebuild(
    void Function(GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder toBuilder() =>
      GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetUserRepositoriesData_user_repositories_nodes_owner &&
        G__typename == other.G__typename &&
        login == other.login &&
        avatarUrl == other.avatarUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, login.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetUserRepositoriesData_user_repositories_nodes_owner',
          )
          ..add('G__typename', G__typename)
          ..add('login', login)
          ..add('avatarUrl', avatarUrl))
        .toString();
  }
}

class GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder
    implements
        Builder<
          GGetUserRepositoriesData_user_repositories_nodes_owner,
          GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder
        > {
  _$GGetUserRepositoriesData_user_repositories_nodes_owner? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _login;
  String? get login => _$this._login;
  set login(String? login) => _$this._login = login;

  _i2.GURIBuilder? _avatarUrl;
  _i2.GURIBuilder get avatarUrl => _$this._avatarUrl ??= _i2.GURIBuilder();
  set avatarUrl(_i2.GURIBuilder? avatarUrl) => _$this._avatarUrl = avatarUrl;

  GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder() {
    GGetUserRepositoriesData_user_repositories_nodes_owner._initializeBuilder(
      this,
    );
  }

  GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _login = $v.login;
      _avatarUrl = $v.avatarUrl.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetUserRepositoriesData_user_repositories_nodes_owner other) {
    _$v = other as _$GGetUserRepositoriesData_user_repositories_nodes_owner;
  }

  @override
  void update(
    void Function(
      GGetUserRepositoriesData_user_repositories_nodes_ownerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetUserRepositoriesData_user_repositories_nodes_owner build() => _build();

  _$GGetUserRepositoriesData_user_repositories_nodes_owner _build() {
    _$GGetUserRepositoriesData_user_repositories_nodes_owner _$result;
    try {
      _$result =
          _$v ??
          _$GGetUserRepositoriesData_user_repositories_nodes_owner._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetUserRepositoriesData_user_repositories_nodes_owner',
              'G__typename',
            ),
            login: BuiltValueNullFieldError.checkNotNull(
              login,
              r'GGetUserRepositoriesData_user_repositories_nodes_owner',
              'login',
            ),
            avatarUrl: avatarUrl.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'avatarUrl';
        avatarUrl.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetUserRepositoriesData_user_repositories_nodes_owner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetViewerRepositoriesData extends GGetViewerRepositoriesData {
  @override
  final String G__typename;
  @override
  final GGetViewerRepositoriesData_viewer viewer;

  factory _$GGetViewerRepositoriesData([
    void Function(GGetViewerRepositoriesDataBuilder)? updates,
  ]) => (GGetViewerRepositoriesDataBuilder()..update(updates))._build();

  _$GGetViewerRepositoriesData._({
    required this.G__typename,
    required this.viewer,
  }) : super._();
  @override
  GGetViewerRepositoriesData rebuild(
    void Function(GGetViewerRepositoriesDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetViewerRepositoriesDataBuilder toBuilder() =>
      GGetViewerRepositoriesDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetViewerRepositoriesData &&
        G__typename == other.G__typename &&
        viewer == other.viewer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, viewer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetViewerRepositoriesData')
          ..add('G__typename', G__typename)
          ..add('viewer', viewer))
        .toString();
  }
}

class GGetViewerRepositoriesDataBuilder
    implements
        Builder<GGetViewerRepositoriesData, GGetViewerRepositoriesDataBuilder> {
  _$GGetViewerRepositoriesData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GGetViewerRepositoriesData_viewerBuilder? _viewer;
  GGetViewerRepositoriesData_viewerBuilder get viewer =>
      _$this._viewer ??= GGetViewerRepositoriesData_viewerBuilder();
  set viewer(GGetViewerRepositoriesData_viewerBuilder? viewer) =>
      _$this._viewer = viewer;

  GGetViewerRepositoriesDataBuilder() {
    GGetViewerRepositoriesData._initializeBuilder(this);
  }

  GGetViewerRepositoriesDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _viewer = $v.viewer.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetViewerRepositoriesData other) {
    _$v = other as _$GGetViewerRepositoriesData;
  }

  @override
  void update(void Function(GGetViewerRepositoriesDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetViewerRepositoriesData build() => _build();

  _$GGetViewerRepositoriesData _build() {
    _$GGetViewerRepositoriesData _$result;
    try {
      _$result =
          _$v ??
          _$GGetViewerRepositoriesData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetViewerRepositoriesData',
              'G__typename',
            ),
            viewer: viewer.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'viewer';
        viewer.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetViewerRepositoriesData',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetViewerRepositoriesData_viewer
    extends GGetViewerRepositoriesData_viewer {
  @override
  final String G__typename;
  @override
  final GGetViewerRepositoriesData_viewer_repositories repositories;

  factory _$GGetViewerRepositoriesData_viewer([
    void Function(GGetViewerRepositoriesData_viewerBuilder)? updates,
  ]) => (GGetViewerRepositoriesData_viewerBuilder()..update(updates))._build();

  _$GGetViewerRepositoriesData_viewer._({
    required this.G__typename,
    required this.repositories,
  }) : super._();
  @override
  GGetViewerRepositoriesData_viewer rebuild(
    void Function(GGetViewerRepositoriesData_viewerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetViewerRepositoriesData_viewerBuilder toBuilder() =>
      GGetViewerRepositoriesData_viewerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetViewerRepositoriesData_viewer &&
        G__typename == other.G__typename &&
        repositories == other.repositories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, repositories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetViewerRepositoriesData_viewer')
          ..add('G__typename', G__typename)
          ..add('repositories', repositories))
        .toString();
  }
}

class GGetViewerRepositoriesData_viewerBuilder
    implements
        Builder<
          GGetViewerRepositoriesData_viewer,
          GGetViewerRepositoriesData_viewerBuilder
        > {
  _$GGetViewerRepositoriesData_viewer? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GGetViewerRepositoriesData_viewer_repositoriesBuilder? _repositories;
  GGetViewerRepositoriesData_viewer_repositoriesBuilder get repositories =>
      _$this._repositories ??=
          GGetViewerRepositoriesData_viewer_repositoriesBuilder();
  set repositories(
    GGetViewerRepositoriesData_viewer_repositoriesBuilder? repositories,
  ) => _$this._repositories = repositories;

  GGetViewerRepositoriesData_viewerBuilder() {
    GGetViewerRepositoriesData_viewer._initializeBuilder(this);
  }

  GGetViewerRepositoriesData_viewerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _repositories = $v.repositories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetViewerRepositoriesData_viewer other) {
    _$v = other as _$GGetViewerRepositoriesData_viewer;
  }

  @override
  void update(
    void Function(GGetViewerRepositoriesData_viewerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetViewerRepositoriesData_viewer build() => _build();

  _$GGetViewerRepositoriesData_viewer _build() {
    _$GGetViewerRepositoriesData_viewer _$result;
    try {
      _$result =
          _$v ??
          _$GGetViewerRepositoriesData_viewer._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetViewerRepositoriesData_viewer',
              'G__typename',
            ),
            repositories: repositories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'repositories';
        repositories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetViewerRepositoriesData_viewer',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories
    extends GGetViewerRepositoriesData_viewer_repositories {
  @override
  final String G__typename;
  @override
  final int totalCount;
  @override
  final GGetViewerRepositoriesData_viewer_repositories_pageInfo pageInfo;
  @override
  final BuiltList<GGetViewerRepositoriesData_viewer_repositories_nodes?>? nodes;

  factory _$GGetViewerRepositoriesData_viewer_repositories([
    void Function(GGetViewerRepositoriesData_viewer_repositoriesBuilder)?
    updates,
  ]) =>
      (GGetViewerRepositoriesData_viewer_repositoriesBuilder()..update(updates))
          ._build();

  _$GGetViewerRepositoriesData_viewer_repositories._({
    required this.G__typename,
    required this.totalCount,
    required this.pageInfo,
    this.nodes,
  }) : super._();
  @override
  GGetViewerRepositoriesData_viewer_repositories rebuild(
    void Function(GGetViewerRepositoriesData_viewer_repositoriesBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetViewerRepositoriesData_viewer_repositoriesBuilder toBuilder() =>
      GGetViewerRepositoriesData_viewer_repositoriesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetViewerRepositoriesData_viewer_repositories &&
        G__typename == other.G__typename &&
        totalCount == other.totalCount &&
        pageInfo == other.pageInfo &&
        nodes == other.nodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, totalCount.hashCode);
    _$hash = $jc(_$hash, pageInfo.hashCode);
    _$hash = $jc(_$hash, nodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetViewerRepositoriesData_viewer_repositories',
          )
          ..add('G__typename', G__typename)
          ..add('totalCount', totalCount)
          ..add('pageInfo', pageInfo)
          ..add('nodes', nodes))
        .toString();
  }
}

class GGetViewerRepositoriesData_viewer_repositoriesBuilder
    implements
        Builder<
          GGetViewerRepositoriesData_viewer_repositories,
          GGetViewerRepositoriesData_viewer_repositoriesBuilder
        > {
  _$GGetViewerRepositoriesData_viewer_repositories? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder? _pageInfo;
  GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder get pageInfo =>
      _$this._pageInfo ??=
          GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder();
  set pageInfo(
    GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder? pageInfo,
  ) => _$this._pageInfo = pageInfo;

  ListBuilder<GGetViewerRepositoriesData_viewer_repositories_nodes?>? _nodes;
  ListBuilder<GGetViewerRepositoriesData_viewer_repositories_nodes?>
  get nodes => _$this._nodes ??=
      ListBuilder<GGetViewerRepositoriesData_viewer_repositories_nodes?>();
  set nodes(
    ListBuilder<GGetViewerRepositoriesData_viewer_repositories_nodes?>? nodes,
  ) => _$this._nodes = nodes;

  GGetViewerRepositoriesData_viewer_repositoriesBuilder() {
    GGetViewerRepositoriesData_viewer_repositories._initializeBuilder(this);
  }

  GGetViewerRepositoriesData_viewer_repositoriesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _totalCount = $v.totalCount;
      _pageInfo = $v.pageInfo.toBuilder();
      _nodes = $v.nodes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetViewerRepositoriesData_viewer_repositories other) {
    _$v = other as _$GGetViewerRepositoriesData_viewer_repositories;
  }

  @override
  void update(
    void Function(GGetViewerRepositoriesData_viewer_repositoriesBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories build() => _build();

  _$GGetViewerRepositoriesData_viewer_repositories _build() {
    _$GGetViewerRepositoriesData_viewer_repositories _$result;
    try {
      _$result =
          _$v ??
          _$GGetViewerRepositoriesData_viewer_repositories._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetViewerRepositoriesData_viewer_repositories',
              'G__typename',
            ),
            totalCount: BuiltValueNullFieldError.checkNotNull(
              totalCount,
              r'GGetViewerRepositoriesData_viewer_repositories',
              'totalCount',
            ),
            pageInfo: pageInfo.build(),
            nodes: _nodes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pageInfo';
        pageInfo.build();
        _$failedField = 'nodes';
        _nodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetViewerRepositoriesData_viewer_repositories',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories_pageInfo
    extends GGetViewerRepositoriesData_viewer_repositories_pageInfo {
  @override
  final String G__typename;
  @override
  final bool hasNextPage;
  @override
  final bool hasPreviousPage;
  @override
  final String? startCursor;
  @override
  final String? endCursor;

  factory _$GGetViewerRepositoriesData_viewer_repositories_pageInfo([
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder,
    )?
    updates,
  ]) =>
      (GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder()
            ..update(updates))
          ._build();

  _$GGetViewerRepositoriesData_viewer_repositories_pageInfo._({
    required this.G__typename,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  }) : super._();
  @override
  GGetViewerRepositoriesData_viewer_repositories_pageInfo rebuild(
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder toBuilder() =>
      GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetViewerRepositoriesData_viewer_repositories_pageInfo &&
        G__typename == other.G__typename &&
        hasNextPage == other.hasNextPage &&
        hasPreviousPage == other.hasPreviousPage &&
        startCursor == other.startCursor &&
        endCursor == other.endCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, hasNextPage.hashCode);
    _$hash = $jc(_$hash, hasPreviousPage.hashCode);
    _$hash = $jc(_$hash, startCursor.hashCode);
    _$hash = $jc(_$hash, endCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetViewerRepositoriesData_viewer_repositories_pageInfo',
          )
          ..add('G__typename', G__typename)
          ..add('hasNextPage', hasNextPage)
          ..add('hasPreviousPage', hasPreviousPage)
          ..add('startCursor', startCursor)
          ..add('endCursor', endCursor))
        .toString();
  }
}

class GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder
    implements
        Builder<
          GGetViewerRepositoriesData_viewer_repositories_pageInfo,
          GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder
        > {
  _$GGetViewerRepositoriesData_viewer_repositories_pageInfo? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  bool? _hasNextPage;
  bool? get hasNextPage => _$this._hasNextPage;
  set hasNextPage(bool? hasNextPage) => _$this._hasNextPage = hasNextPage;

  bool? _hasPreviousPage;
  bool? get hasPreviousPage => _$this._hasPreviousPage;
  set hasPreviousPage(bool? hasPreviousPage) =>
      _$this._hasPreviousPage = hasPreviousPage;

  String? _startCursor;
  String? get startCursor => _$this._startCursor;
  set startCursor(String? startCursor) => _$this._startCursor = startCursor;

  String? _endCursor;
  String? get endCursor => _$this._endCursor;
  set endCursor(String? endCursor) => _$this._endCursor = endCursor;

  GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder() {
    GGetViewerRepositoriesData_viewer_repositories_pageInfo._initializeBuilder(
      this,
    );
  }

  GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _hasNextPage = $v.hasNextPage;
      _hasPreviousPage = $v.hasPreviousPage;
      _startCursor = $v.startCursor;
      _endCursor = $v.endCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetViewerRepositoriesData_viewer_repositories_pageInfo other) {
    _$v = other as _$GGetViewerRepositoriesData_viewer_repositories_pageInfo;
  }

  @override
  void update(
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_pageInfoBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories_pageInfo build() => _build();

  _$GGetViewerRepositoriesData_viewer_repositories_pageInfo _build() {
    final _$result =
        _$v ??
        _$GGetViewerRepositoriesData_viewer_repositories_pageInfo._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetViewerRepositoriesData_viewer_repositories_pageInfo',
            'G__typename',
          ),
          hasNextPage: BuiltValueNullFieldError.checkNotNull(
            hasNextPage,
            r'GGetViewerRepositoriesData_viewer_repositories_pageInfo',
            'hasNextPage',
          ),
          hasPreviousPage: BuiltValueNullFieldError.checkNotNull(
            hasPreviousPage,
            r'GGetViewerRepositoriesData_viewer_repositories_pageInfo',
            'hasPreviousPage',
          ),
          startCursor: startCursor,
          endCursor: endCursor,
        );
    replace(_$result);
    return _$result;
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories_nodes
    extends GGetViewerRepositoriesData_viewer_repositories_nodes {
  @override
  final String G__typename;
  @override
  final String id;
  @override
  final String name;
  @override
  final String nameWithOwner;
  @override
  final String? description;
  @override
  final _i2.GURI url;
  @override
  final bool isPrivate;
  @override
  final bool isFork;
  @override
  final bool isTemplate;
  @override
  final bool isArchived;
  @override
  final bool isMirror;
  @override
  final GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage?
  primaryLanguage;
  @override
  final int stargazerCount;
  @override
  final int forkCount;
  @override
  final _i2.GDateTime updatedAt;
  @override
  final _i2.GDateTime? pushedAt;
  @override
  final _i2.GDateTime createdAt;
  @override
  final GGetViewerRepositoriesData_viewer_repositories_nodes_owner owner;

  factory _$GGetViewerRepositoriesData_viewer_repositories_nodes([
    void Function(GGetViewerRepositoriesData_viewer_repositories_nodesBuilder)?
    updates,
  ]) =>
      (GGetViewerRepositoriesData_viewer_repositories_nodesBuilder()
            ..update(updates))
          ._build();

  _$GGetViewerRepositoriesData_viewer_repositories_nodes._({
    required this.G__typename,
    required this.id,
    required this.name,
    required this.nameWithOwner,
    this.description,
    required this.url,
    required this.isPrivate,
    required this.isFork,
    required this.isTemplate,
    required this.isArchived,
    required this.isMirror,
    this.primaryLanguage,
    required this.stargazerCount,
    required this.forkCount,
    required this.updatedAt,
    this.pushedAt,
    required this.createdAt,
    required this.owner,
  }) : super._();
  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes rebuild(
    void Function(GGetViewerRepositoriesData_viewer_repositories_nodesBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodesBuilder toBuilder() =>
      GGetViewerRepositoriesData_viewer_repositories_nodesBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetViewerRepositoriesData_viewer_repositories_nodes &&
        G__typename == other.G__typename &&
        id == other.id &&
        name == other.name &&
        nameWithOwner == other.nameWithOwner &&
        description == other.description &&
        url == other.url &&
        isPrivate == other.isPrivate &&
        isFork == other.isFork &&
        isTemplate == other.isTemplate &&
        isArchived == other.isArchived &&
        isMirror == other.isMirror &&
        primaryLanguage == other.primaryLanguage &&
        stargazerCount == other.stargazerCount &&
        forkCount == other.forkCount &&
        updatedAt == other.updatedAt &&
        pushedAt == other.pushedAt &&
        createdAt == other.createdAt &&
        owner == other.owner;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameWithOwner.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, isPrivate.hashCode);
    _$hash = $jc(_$hash, isFork.hashCode);
    _$hash = $jc(_$hash, isTemplate.hashCode);
    _$hash = $jc(_$hash, isArchived.hashCode);
    _$hash = $jc(_$hash, isMirror.hashCode);
    _$hash = $jc(_$hash, primaryLanguage.hashCode);
    _$hash = $jc(_$hash, stargazerCount.hashCode);
    _$hash = $jc(_$hash, forkCount.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, pushedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetViewerRepositoriesData_viewer_repositories_nodes',
          )
          ..add('G__typename', G__typename)
          ..add('id', id)
          ..add('name', name)
          ..add('nameWithOwner', nameWithOwner)
          ..add('description', description)
          ..add('url', url)
          ..add('isPrivate', isPrivate)
          ..add('isFork', isFork)
          ..add('isTemplate', isTemplate)
          ..add('isArchived', isArchived)
          ..add('isMirror', isMirror)
          ..add('primaryLanguage', primaryLanguage)
          ..add('stargazerCount', stargazerCount)
          ..add('forkCount', forkCount)
          ..add('updatedAt', updatedAt)
          ..add('pushedAt', pushedAt)
          ..add('createdAt', createdAt)
          ..add('owner', owner))
        .toString();
  }
}

class GGetViewerRepositoriesData_viewer_repositories_nodesBuilder
    implements
        Builder<
          GGetViewerRepositoriesData_viewer_repositories_nodes,
          GGetViewerRepositoriesData_viewer_repositories_nodesBuilder
        > {
  _$GGetViewerRepositoriesData_viewer_repositories_nodes? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameWithOwner;
  String? get nameWithOwner => _$this._nameWithOwner;
  set nameWithOwner(String? nameWithOwner) =>
      _$this._nameWithOwner = nameWithOwner;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  _i2.GURIBuilder? _url;
  _i2.GURIBuilder get url => _$this._url ??= _i2.GURIBuilder();
  set url(_i2.GURIBuilder? url) => _$this._url = url;

  bool? _isPrivate;
  bool? get isPrivate => _$this._isPrivate;
  set isPrivate(bool? isPrivate) => _$this._isPrivate = isPrivate;

  bool? _isFork;
  bool? get isFork => _$this._isFork;
  set isFork(bool? isFork) => _$this._isFork = isFork;

  bool? _isTemplate;
  bool? get isTemplate => _$this._isTemplate;
  set isTemplate(bool? isTemplate) => _$this._isTemplate = isTemplate;

  bool? _isArchived;
  bool? get isArchived => _$this._isArchived;
  set isArchived(bool? isArchived) => _$this._isArchived = isArchived;

  bool? _isMirror;
  bool? get isMirror => _$this._isMirror;
  set isMirror(bool? isMirror) => _$this._isMirror = isMirror;

  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder?
  _primaryLanguage;
  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder
  get primaryLanguage => _$this._primaryLanguage ??=
      GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder();
  set primaryLanguage(
    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder?
    primaryLanguage,
  ) => _$this._primaryLanguage = primaryLanguage;

  int? _stargazerCount;
  int? get stargazerCount => _$this._stargazerCount;
  set stargazerCount(int? stargazerCount) =>
      _$this._stargazerCount = stargazerCount;

  int? _forkCount;
  int? get forkCount => _$this._forkCount;
  set forkCount(int? forkCount) => _$this._forkCount = forkCount;

  _i2.GDateTimeBuilder? _updatedAt;
  _i2.GDateTimeBuilder get updatedAt =>
      _$this._updatedAt ??= _i2.GDateTimeBuilder();
  set updatedAt(_i2.GDateTimeBuilder? updatedAt) =>
      _$this._updatedAt = updatedAt;

  _i2.GDateTimeBuilder? _pushedAt;
  _i2.GDateTimeBuilder get pushedAt =>
      _$this._pushedAt ??= _i2.GDateTimeBuilder();
  set pushedAt(_i2.GDateTimeBuilder? pushedAt) => _$this._pushedAt = pushedAt;

  _i2.GDateTimeBuilder? _createdAt;
  _i2.GDateTimeBuilder get createdAt =>
      _$this._createdAt ??= _i2.GDateTimeBuilder();
  set createdAt(_i2.GDateTimeBuilder? createdAt) =>
      _$this._createdAt = createdAt;

  GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder? _owner;
  GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder get owner =>
      _$this._owner ??=
          GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder();
  set owner(
    GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder? owner,
  ) => _$this._owner = owner;

  GGetViewerRepositoriesData_viewer_repositories_nodesBuilder() {
    GGetViewerRepositoriesData_viewer_repositories_nodes._initializeBuilder(
      this,
    );
  }

  GGetViewerRepositoriesData_viewer_repositories_nodesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _id = $v.id;
      _name = $v.name;
      _nameWithOwner = $v.nameWithOwner;
      _description = $v.description;
      _url = $v.url.toBuilder();
      _isPrivate = $v.isPrivate;
      _isFork = $v.isFork;
      _isTemplate = $v.isTemplate;
      _isArchived = $v.isArchived;
      _isMirror = $v.isMirror;
      _primaryLanguage = $v.primaryLanguage?.toBuilder();
      _stargazerCount = $v.stargazerCount;
      _forkCount = $v.forkCount;
      _updatedAt = $v.updatedAt.toBuilder();
      _pushedAt = $v.pushedAt?.toBuilder();
      _createdAt = $v.createdAt.toBuilder();
      _owner = $v.owner.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetViewerRepositoriesData_viewer_repositories_nodes other) {
    _$v = other as _$GGetViewerRepositoriesData_viewer_repositories_nodes;
  }

  @override
  void update(
    void Function(GGetViewerRepositoriesData_viewer_repositories_nodesBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes build() => _build();

  _$GGetViewerRepositoriesData_viewer_repositories_nodes _build() {
    _$GGetViewerRepositoriesData_viewer_repositories_nodes _$result;
    try {
      _$result =
          _$v ??
          _$GGetViewerRepositoriesData_viewer_repositories_nodes._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'G__typename',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'name',
            ),
            nameWithOwner: BuiltValueNullFieldError.checkNotNull(
              nameWithOwner,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'nameWithOwner',
            ),
            description: description,
            url: url.build(),
            isPrivate: BuiltValueNullFieldError.checkNotNull(
              isPrivate,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'isPrivate',
            ),
            isFork: BuiltValueNullFieldError.checkNotNull(
              isFork,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'isFork',
            ),
            isTemplate: BuiltValueNullFieldError.checkNotNull(
              isTemplate,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'isTemplate',
            ),
            isArchived: BuiltValueNullFieldError.checkNotNull(
              isArchived,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'isArchived',
            ),
            isMirror: BuiltValueNullFieldError.checkNotNull(
              isMirror,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'isMirror',
            ),
            primaryLanguage: _primaryLanguage?.build(),
            stargazerCount: BuiltValueNullFieldError.checkNotNull(
              stargazerCount,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'stargazerCount',
            ),
            forkCount: BuiltValueNullFieldError.checkNotNull(
              forkCount,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes',
              'forkCount',
            ),
            updatedAt: updatedAt.build(),
            pushedAt: _pushedAt?.build(),
            createdAt: createdAt.build(),
            owner: owner.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'url';
        url.build();

        _$failedField = 'primaryLanguage';
        _primaryLanguage?.build();

        _$failedField = 'updatedAt';
        updatedAt.build();
        _$failedField = 'pushedAt';
        _pushedAt?.build();
        _$failedField = 'createdAt';
        createdAt.build();
        _$failedField = 'owner';
        owner.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetViewerRepositoriesData_viewer_repositories_nodes',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
    extends
        GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage {
  @override
  final String G__typename;
  @override
  final String name;
  @override
  final String? color;

  factory _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage([
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder,
    )?
    updates,
  ]) =>
      (GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder()
            ..update(updates))
          ._build();

  _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage._({
    required this.G__typename,
    required this.name,
    this.color,
  }) : super._();
  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage rebuild(
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder
  toBuilder() =>
      GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage &&
        G__typename == other.G__typename &&
        name == other.name &&
        color == other.color;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage',
          )
          ..add('G__typename', G__typename)
          ..add('name', name)
          ..add('color', color))
        .toString();
  }
}

class GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder
    implements
        Builder<
          GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage,
          GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder
        > {
  _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder() {
    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage._initializeBuilder(
      this,
    );
  }

  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _name = $v.name;
      _color = $v.color;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage other,
  ) {
    _$v =
        other
            as _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage;
  }

  @override
  void update(
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguageBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
  build() => _build();

  _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage
  _build() {
    final _$result =
        _$v ??
        _$GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage',
            'G__typename',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'GGetViewerRepositoriesData_viewer_repositories_nodes_primaryLanguage',
            'name',
          ),
          color: color,
        );
    replace(_$result);
    return _$result;
  }
}

class _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner
    extends GGetViewerRepositoriesData_viewer_repositories_nodes_owner {
  @override
  final String G__typename;
  @override
  final String login;
  @override
  final _i2.GURI avatarUrl;

  factory _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner([
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder,
    )?
    updates,
  ]) =>
      (GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder()
            ..update(updates))
          ._build();

  _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner._({
    required this.G__typename,
    required this.login,
    required this.avatarUrl,
  }) : super._();
  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_owner rebuild(
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder
  toBuilder() =>
      GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is GGetViewerRepositoriesData_viewer_repositories_nodes_owner &&
        G__typename == other.G__typename &&
        login == other.login &&
        avatarUrl == other.avatarUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, login.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetViewerRepositoriesData_viewer_repositories_nodes_owner',
          )
          ..add('G__typename', G__typename)
          ..add('login', login)
          ..add('avatarUrl', avatarUrl))
        .toString();
  }
}

class GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder
    implements
        Builder<
          GGetViewerRepositoriesData_viewer_repositories_nodes_owner,
          GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder
        > {
  _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _login;
  String? get login => _$this._login;
  set login(String? login) => _$this._login = login;

  _i2.GURIBuilder? _avatarUrl;
  _i2.GURIBuilder get avatarUrl => _$this._avatarUrl ??= _i2.GURIBuilder();
  set avatarUrl(_i2.GURIBuilder? avatarUrl) => _$this._avatarUrl = avatarUrl;

  GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder() {
    GGetViewerRepositoriesData_viewer_repositories_nodes_owner._initializeBuilder(
      this,
    );
  }

  GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _login = $v.login;
      _avatarUrl = $v.avatarUrl.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    GGetViewerRepositoriesData_viewer_repositories_nodes_owner other,
  ) {
    _$v = other as _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner;
  }

  @override
  void update(
    void Function(
      GGetViewerRepositoriesData_viewer_repositories_nodes_ownerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GGetViewerRepositoriesData_viewer_repositories_nodes_owner build() =>
      _build();

  _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner _build() {
    _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner _$result;
    try {
      _$result =
          _$v ??
          _$GGetViewerRepositoriesData_viewer_repositories_nodes_owner._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes_owner',
              'G__typename',
            ),
            login: BuiltValueNullFieldError.checkNotNull(
              login,
              r'GGetViewerRepositoriesData_viewer_repositories_nodes_owner',
              'login',
            ),
            avatarUrl: avatarUrl.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'avatarUrl';
        avatarUrl.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GGetViewerRepositoriesData_viewer_repositories_nodes_owner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GUserRepositoriesFragmentData extends GUserRepositoriesFragmentData {
  @override
  final String G__typename;
  @override
  final String id;
  @override
  final String name;
  @override
  final String nameWithOwner;
  @override
  final String? description;
  @override
  final _i2.GURI url;
  @override
  final bool isPrivate;
  @override
  final bool isFork;
  @override
  final bool isTemplate;
  @override
  final bool isArchived;
  @override
  final bool isMirror;
  @override
  final GUserRepositoriesFragmentData_primaryLanguage? primaryLanguage;
  @override
  final int stargazerCount;
  @override
  final int forkCount;
  @override
  final _i2.GDateTime updatedAt;
  @override
  final _i2.GDateTime? pushedAt;
  @override
  final _i2.GDateTime createdAt;
  @override
  final GUserRepositoriesFragmentData_owner owner;

  factory _$GUserRepositoriesFragmentData([
    void Function(GUserRepositoriesFragmentDataBuilder)? updates,
  ]) => (GUserRepositoriesFragmentDataBuilder()..update(updates))._build();

  _$GUserRepositoriesFragmentData._({
    required this.G__typename,
    required this.id,
    required this.name,
    required this.nameWithOwner,
    this.description,
    required this.url,
    required this.isPrivate,
    required this.isFork,
    required this.isTemplate,
    required this.isArchived,
    required this.isMirror,
    this.primaryLanguage,
    required this.stargazerCount,
    required this.forkCount,
    required this.updatedAt,
    this.pushedAt,
    required this.createdAt,
    required this.owner,
  }) : super._();
  @override
  GUserRepositoriesFragmentData rebuild(
    void Function(GUserRepositoriesFragmentDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserRepositoriesFragmentDataBuilder toBuilder() =>
      GUserRepositoriesFragmentDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserRepositoriesFragmentData &&
        G__typename == other.G__typename &&
        id == other.id &&
        name == other.name &&
        nameWithOwner == other.nameWithOwner &&
        description == other.description &&
        url == other.url &&
        isPrivate == other.isPrivate &&
        isFork == other.isFork &&
        isTemplate == other.isTemplate &&
        isArchived == other.isArchived &&
        isMirror == other.isMirror &&
        primaryLanguage == other.primaryLanguage &&
        stargazerCount == other.stargazerCount &&
        forkCount == other.forkCount &&
        updatedAt == other.updatedAt &&
        pushedAt == other.pushedAt &&
        createdAt == other.createdAt &&
        owner == other.owner;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameWithOwner.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, isPrivate.hashCode);
    _$hash = $jc(_$hash, isFork.hashCode);
    _$hash = $jc(_$hash, isTemplate.hashCode);
    _$hash = $jc(_$hash, isArchived.hashCode);
    _$hash = $jc(_$hash, isMirror.hashCode);
    _$hash = $jc(_$hash, primaryLanguage.hashCode);
    _$hash = $jc(_$hash, stargazerCount.hashCode);
    _$hash = $jc(_$hash, forkCount.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, pushedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GUserRepositoriesFragmentData')
          ..add('G__typename', G__typename)
          ..add('id', id)
          ..add('name', name)
          ..add('nameWithOwner', nameWithOwner)
          ..add('description', description)
          ..add('url', url)
          ..add('isPrivate', isPrivate)
          ..add('isFork', isFork)
          ..add('isTemplate', isTemplate)
          ..add('isArchived', isArchived)
          ..add('isMirror', isMirror)
          ..add('primaryLanguage', primaryLanguage)
          ..add('stargazerCount', stargazerCount)
          ..add('forkCount', forkCount)
          ..add('updatedAt', updatedAt)
          ..add('pushedAt', pushedAt)
          ..add('createdAt', createdAt)
          ..add('owner', owner))
        .toString();
  }
}

class GUserRepositoriesFragmentDataBuilder
    implements
        Builder<
          GUserRepositoriesFragmentData,
          GUserRepositoriesFragmentDataBuilder
        > {
  _$GUserRepositoriesFragmentData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameWithOwner;
  String? get nameWithOwner => _$this._nameWithOwner;
  set nameWithOwner(String? nameWithOwner) =>
      _$this._nameWithOwner = nameWithOwner;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  _i2.GURIBuilder? _url;
  _i2.GURIBuilder get url => _$this._url ??= _i2.GURIBuilder();
  set url(_i2.GURIBuilder? url) => _$this._url = url;

  bool? _isPrivate;
  bool? get isPrivate => _$this._isPrivate;
  set isPrivate(bool? isPrivate) => _$this._isPrivate = isPrivate;

  bool? _isFork;
  bool? get isFork => _$this._isFork;
  set isFork(bool? isFork) => _$this._isFork = isFork;

  bool? _isTemplate;
  bool? get isTemplate => _$this._isTemplate;
  set isTemplate(bool? isTemplate) => _$this._isTemplate = isTemplate;

  bool? _isArchived;
  bool? get isArchived => _$this._isArchived;
  set isArchived(bool? isArchived) => _$this._isArchived = isArchived;

  bool? _isMirror;
  bool? get isMirror => _$this._isMirror;
  set isMirror(bool? isMirror) => _$this._isMirror = isMirror;

  GUserRepositoriesFragmentData_primaryLanguageBuilder? _primaryLanguage;
  GUserRepositoriesFragmentData_primaryLanguageBuilder get primaryLanguage =>
      _$this._primaryLanguage ??=
          GUserRepositoriesFragmentData_primaryLanguageBuilder();
  set primaryLanguage(
    GUserRepositoriesFragmentData_primaryLanguageBuilder? primaryLanguage,
  ) => _$this._primaryLanguage = primaryLanguage;

  int? _stargazerCount;
  int? get stargazerCount => _$this._stargazerCount;
  set stargazerCount(int? stargazerCount) =>
      _$this._stargazerCount = stargazerCount;

  int? _forkCount;
  int? get forkCount => _$this._forkCount;
  set forkCount(int? forkCount) => _$this._forkCount = forkCount;

  _i2.GDateTimeBuilder? _updatedAt;
  _i2.GDateTimeBuilder get updatedAt =>
      _$this._updatedAt ??= _i2.GDateTimeBuilder();
  set updatedAt(_i2.GDateTimeBuilder? updatedAt) =>
      _$this._updatedAt = updatedAt;

  _i2.GDateTimeBuilder? _pushedAt;
  _i2.GDateTimeBuilder get pushedAt =>
      _$this._pushedAt ??= _i2.GDateTimeBuilder();
  set pushedAt(_i2.GDateTimeBuilder? pushedAt) => _$this._pushedAt = pushedAt;

  _i2.GDateTimeBuilder? _createdAt;
  _i2.GDateTimeBuilder get createdAt =>
      _$this._createdAt ??= _i2.GDateTimeBuilder();
  set createdAt(_i2.GDateTimeBuilder? createdAt) =>
      _$this._createdAt = createdAt;

  GUserRepositoriesFragmentData_ownerBuilder? _owner;
  GUserRepositoriesFragmentData_ownerBuilder get owner =>
      _$this._owner ??= GUserRepositoriesFragmentData_ownerBuilder();
  set owner(GUserRepositoriesFragmentData_ownerBuilder? owner) =>
      _$this._owner = owner;

  GUserRepositoriesFragmentDataBuilder() {
    GUserRepositoriesFragmentData._initializeBuilder(this);
  }

  GUserRepositoriesFragmentDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _id = $v.id;
      _name = $v.name;
      _nameWithOwner = $v.nameWithOwner;
      _description = $v.description;
      _url = $v.url.toBuilder();
      _isPrivate = $v.isPrivate;
      _isFork = $v.isFork;
      _isTemplate = $v.isTemplate;
      _isArchived = $v.isArchived;
      _isMirror = $v.isMirror;
      _primaryLanguage = $v.primaryLanguage?.toBuilder();
      _stargazerCount = $v.stargazerCount;
      _forkCount = $v.forkCount;
      _updatedAt = $v.updatedAt.toBuilder();
      _pushedAt = $v.pushedAt?.toBuilder();
      _createdAt = $v.createdAt.toBuilder();
      _owner = $v.owner.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserRepositoriesFragmentData other) {
    _$v = other as _$GUserRepositoriesFragmentData;
  }

  @override
  void update(void Function(GUserRepositoriesFragmentDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GUserRepositoriesFragmentData build() => _build();

  _$GUserRepositoriesFragmentData _build() {
    _$GUserRepositoriesFragmentData _$result;
    try {
      _$result =
          _$v ??
          _$GUserRepositoriesFragmentData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GUserRepositoriesFragmentData',
              'G__typename',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'GUserRepositoriesFragmentData',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'GUserRepositoriesFragmentData',
              'name',
            ),
            nameWithOwner: BuiltValueNullFieldError.checkNotNull(
              nameWithOwner,
              r'GUserRepositoriesFragmentData',
              'nameWithOwner',
            ),
            description: description,
            url: url.build(),
            isPrivate: BuiltValueNullFieldError.checkNotNull(
              isPrivate,
              r'GUserRepositoriesFragmentData',
              'isPrivate',
            ),
            isFork: BuiltValueNullFieldError.checkNotNull(
              isFork,
              r'GUserRepositoriesFragmentData',
              'isFork',
            ),
            isTemplate: BuiltValueNullFieldError.checkNotNull(
              isTemplate,
              r'GUserRepositoriesFragmentData',
              'isTemplate',
            ),
            isArchived: BuiltValueNullFieldError.checkNotNull(
              isArchived,
              r'GUserRepositoriesFragmentData',
              'isArchived',
            ),
            isMirror: BuiltValueNullFieldError.checkNotNull(
              isMirror,
              r'GUserRepositoriesFragmentData',
              'isMirror',
            ),
            primaryLanguage: _primaryLanguage?.build(),
            stargazerCount: BuiltValueNullFieldError.checkNotNull(
              stargazerCount,
              r'GUserRepositoriesFragmentData',
              'stargazerCount',
            ),
            forkCount: BuiltValueNullFieldError.checkNotNull(
              forkCount,
              r'GUserRepositoriesFragmentData',
              'forkCount',
            ),
            updatedAt: updatedAt.build(),
            pushedAt: _pushedAt?.build(),
            createdAt: createdAt.build(),
            owner: owner.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'url';
        url.build();

        _$failedField = 'primaryLanguage';
        _primaryLanguage?.build();

        _$failedField = 'updatedAt';
        updatedAt.build();
        _$failedField = 'pushedAt';
        _pushedAt?.build();
        _$failedField = 'createdAt';
        createdAt.build();
        _$failedField = 'owner';
        owner.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GUserRepositoriesFragmentData',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GUserRepositoriesFragmentData_primaryLanguage
    extends GUserRepositoriesFragmentData_primaryLanguage {
  @override
  final String G__typename;
  @override
  final String name;
  @override
  final String? color;

  factory _$GUserRepositoriesFragmentData_primaryLanguage([
    void Function(GUserRepositoriesFragmentData_primaryLanguageBuilder)?
    updates,
  ]) =>
      (GUserRepositoriesFragmentData_primaryLanguageBuilder()..update(updates))
          ._build();

  _$GUserRepositoriesFragmentData_primaryLanguage._({
    required this.G__typename,
    required this.name,
    this.color,
  }) : super._();
  @override
  GUserRepositoriesFragmentData_primaryLanguage rebuild(
    void Function(GUserRepositoriesFragmentData_primaryLanguageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserRepositoriesFragmentData_primaryLanguageBuilder toBuilder() =>
      GUserRepositoriesFragmentData_primaryLanguageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserRepositoriesFragmentData_primaryLanguage &&
        G__typename == other.G__typename &&
        name == other.name &&
        color == other.color;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GUserRepositoriesFragmentData_primaryLanguage',
          )
          ..add('G__typename', G__typename)
          ..add('name', name)
          ..add('color', color))
        .toString();
  }
}

class GUserRepositoriesFragmentData_primaryLanguageBuilder
    implements
        Builder<
          GUserRepositoriesFragmentData_primaryLanguage,
          GUserRepositoriesFragmentData_primaryLanguageBuilder
        > {
  _$GUserRepositoriesFragmentData_primaryLanguage? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  GUserRepositoriesFragmentData_primaryLanguageBuilder() {
    GUserRepositoriesFragmentData_primaryLanguage._initializeBuilder(this);
  }

  GUserRepositoriesFragmentData_primaryLanguageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _name = $v.name;
      _color = $v.color;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserRepositoriesFragmentData_primaryLanguage other) {
    _$v = other as _$GUserRepositoriesFragmentData_primaryLanguage;
  }

  @override
  void update(
    void Function(GUserRepositoriesFragmentData_primaryLanguageBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GUserRepositoriesFragmentData_primaryLanguage build() => _build();

  _$GUserRepositoriesFragmentData_primaryLanguage _build() {
    final _$result =
        _$v ??
        _$GUserRepositoriesFragmentData_primaryLanguage._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
            G__typename,
            r'GUserRepositoriesFragmentData_primaryLanguage',
            'G__typename',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'GUserRepositoriesFragmentData_primaryLanguage',
            'name',
          ),
          color: color,
        );
    replace(_$result);
    return _$result;
  }
}

class _$GUserRepositoriesFragmentData_owner
    extends GUserRepositoriesFragmentData_owner {
  @override
  final String G__typename;
  @override
  final String login;
  @override
  final _i2.GURI avatarUrl;

  factory _$GUserRepositoriesFragmentData_owner([
    void Function(GUserRepositoriesFragmentData_ownerBuilder)? updates,
  ]) =>
      (GUserRepositoriesFragmentData_ownerBuilder()..update(updates))._build();

  _$GUserRepositoriesFragmentData_owner._({
    required this.G__typename,
    required this.login,
    required this.avatarUrl,
  }) : super._();
  @override
  GUserRepositoriesFragmentData_owner rebuild(
    void Function(GUserRepositoriesFragmentData_ownerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GUserRepositoriesFragmentData_ownerBuilder toBuilder() =>
      GUserRepositoriesFragmentData_ownerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GUserRepositoriesFragmentData_owner &&
        G__typename == other.G__typename &&
        login == other.login &&
        avatarUrl == other.avatarUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, login.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GUserRepositoriesFragmentData_owner')
          ..add('G__typename', G__typename)
          ..add('login', login)
          ..add('avatarUrl', avatarUrl))
        .toString();
  }
}

class GUserRepositoriesFragmentData_ownerBuilder
    implements
        Builder<
          GUserRepositoriesFragmentData_owner,
          GUserRepositoriesFragmentData_ownerBuilder
        > {
  _$GUserRepositoriesFragmentData_owner? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _login;
  String? get login => _$this._login;
  set login(String? login) => _$this._login = login;

  _i2.GURIBuilder? _avatarUrl;
  _i2.GURIBuilder get avatarUrl => _$this._avatarUrl ??= _i2.GURIBuilder();
  set avatarUrl(_i2.GURIBuilder? avatarUrl) => _$this._avatarUrl = avatarUrl;

  GUserRepositoriesFragmentData_ownerBuilder() {
    GUserRepositoriesFragmentData_owner._initializeBuilder(this);
  }

  GUserRepositoriesFragmentData_ownerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _login = $v.login;
      _avatarUrl = $v.avatarUrl.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GUserRepositoriesFragmentData_owner other) {
    _$v = other as _$GUserRepositoriesFragmentData_owner;
  }

  @override
  void update(
    void Function(GUserRepositoriesFragmentData_ownerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  GUserRepositoriesFragmentData_owner build() => _build();

  _$GUserRepositoriesFragmentData_owner _build() {
    _$GUserRepositoriesFragmentData_owner _$result;
    try {
      _$result =
          _$v ??
          _$GUserRepositoriesFragmentData_owner._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename,
              r'GUserRepositoriesFragmentData_owner',
              'G__typename',
            ),
            login: BuiltValueNullFieldError.checkNotNull(
              login,
              r'GUserRepositoriesFragmentData_owner',
              'login',
            ),
            avatarUrl: avatarUrl.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'avatarUrl';
        avatarUrl.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GUserRepositoriesFragmentData_owner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
