import 'graphql_hook_result.dart';

/// The result of a [useMutation] hook that exposes the hook inner state in the
/// [result] field, and a [Future<Map<String, dynamic>>] function in the
/// mutation field that also throws, allowing imperative usage.
class UseMutationHookResult<Data, Mutation> {
  /// The result of the graphql operation
  final GraphQLHookResult<Data> result;

  /// Usually a [Future<Map<String, dynamic>>] function that will throw and
  /// allows imperative usage.
  final Mutation mutation;
  const UseMutationHookResult(this.result, this.mutation);

  @override
  String toString() =>
      'UseMutationHookResult{result:$result, mutation:$mutation}';
}
