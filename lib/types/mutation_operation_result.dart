import 'operation_result.dart';

/// The result of a [useMutation] hook that exposes the hook inner state in the
/// [result] field, and a [Future<Map<String, dynamic>>] function in the
/// mutation field that also throws, allowing imperative usage.
class MutationOperationResult<Data, Mutation> {
  /// The result of the graphql operation
  final OperationResult<Data> result;

  /// Usually a [Future<Map<String, dynamic>>] function that will throw and
  /// allows imperative usage.
  final Mutation mutation;
  const MutationOperationResult(this.result, this.mutation);

  @override
  String toString() =>
      'MutationOperationResult{result:$result, mutation:$mutation}';
}
