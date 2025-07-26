// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gql/ast.dart' as _i1;

const UserCardFragment = _i1.FragmentDefinitionNode(
  name: _i1.NameNode(value: 'UserCardFragment'),
  typeCondition: _i1.TypeConditionNode(
    on: _i1.NamedTypeNode(name: _i1.NameNode(value: 'User'), isNonNull: false),
  ),
  directives: [],
  selectionSet: _i1.SelectionSetNode(
    selections: [
      _i1.FieldNode(
        name: _i1.NameNode(value: 'id'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      _i1.FieldNode(
        name: _i1.NameNode(value: 'login'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      _i1.FieldNode(
        name: _i1.NameNode(value: 'name'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      _i1.FieldNode(
        name: _i1.NameNode(value: 'avatarUrl'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      _i1.FieldNode(
        name: _i1.NameNode(value: 'bio'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      _i1.FieldNode(
        name: _i1.NameNode(value: 'repositories'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: _i1.SelectionSetNode(
          selections: [
            _i1.FieldNode(
              name: _i1.NameNode(value: 'totalCount'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      _i1.FieldNode(
        name: _i1.NameNode(value: 'followers'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: _i1.SelectionSetNode(
          selections: [
            _i1.FieldNode(
              name: _i1.NameNode(value: 'totalCount'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
    ],
  ),
);
const document = _i1.DocumentNode(definitions: [UserCardFragment]);
