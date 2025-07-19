// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gh3/src/widgets/user_card/__generated__/user_card.ast.gql.dart'
    as _i2;
import 'package:gql/ast.dart' as _i1;

const GetFollowing = _i1.OperationDefinitionNode(
  type: _i1.OperationType.query,
  name: _i1.NameNode(value: 'GetFollowing'),
  variableDefinitions: [
    _i1.VariableDefinitionNode(
      variable: _i1.VariableNode(name: _i1.NameNode(value: 'first')),
      type: _i1.NamedTypeNode(
        name: _i1.NameNode(value: 'Int'),
        isNonNull: true,
      ),
      defaultValue: _i1.DefaultValueNode(value: null),
      directives: [],
    ),
    _i1.VariableDefinitionNode(
      variable: _i1.VariableNode(name: _i1.NameNode(value: 'after')),
      type: _i1.NamedTypeNode(
        name: _i1.NameNode(value: 'String'),
        isNonNull: false,
      ),
      defaultValue: _i1.DefaultValueNode(value: null),
      directives: [],
    ),
  ],
  directives: [],
  selectionSet: _i1.SelectionSetNode(
    selections: [
      _i1.FieldNode(
        name: _i1.NameNode(value: 'viewer'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: _i1.SelectionSetNode(
          selections: [
            _i1.FieldNode(
              name: _i1.NameNode(value: 'following'),
              alias: null,
              arguments: [
                _i1.ArgumentNode(
                  name: _i1.NameNode(value: 'first'),
                  value: _i1.VariableNode(name: _i1.NameNode(value: 'first')),
                ),
                _i1.ArgumentNode(
                  name: _i1.NameNode(value: 'after'),
                  value: _i1.VariableNode(name: _i1.NameNode(value: 'after')),
                ),
              ],
              directives: [],
              selectionSet: _i1.SelectionSetNode(
                selections: [
                  _i1.FieldNode(
                    name: _i1.NameNode(value: 'nodes'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: _i1.SelectionSetNode(
                      selections: [
                        _i1.FragmentSpreadNode(
                          name: _i1.NameNode(value: 'UserCardFragment'),
                          directives: [],
                        ),
                      ],
                    ),
                  ),
                  _i1.FieldNode(
                    name: _i1.NameNode(value: 'pageInfo'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: _i1.SelectionSetNode(
                      selections: [
                        _i1.FieldNode(
                          name: _i1.NameNode(value: 'hasNextPage'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null,
                        ),
                        _i1.FieldNode(
                          name: _i1.NameNode(value: 'endCursor'),
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
            ),
          ],
        ),
      ),
    ],
  ),
);
const document = _i1.DocumentNode(
  definitions: [GetFollowing, _i2.UserCardFragment],
);
