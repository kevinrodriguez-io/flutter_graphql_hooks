import 'graphql_hook_result.dart';

/// The result of either a [useQuery] or [useLazyQuery] hook,
/// always stores the inner hook state in the [result] field,
/// and exposes a refetch function for [useQuery] and a more
/// complex fetch function for [useLazyQuery] .
class UseQueryHookResult<Data, Fetch> {
  /// The result of the graphql operation
  final GraphQLHookResult<Data> result;

  /// A [Future] function; For [useQuery] will often be a
  /// function that returns [Future<void>] and doesn't throw;
  /// for [useLazyQuery] is a function that returns a [Future<Map<String, dynamic>>]
  /// that throws, allowing imperative usage.
  final Fetch fetch;
  const UseQueryHookResult(this.result, this.fetch);

  @override
  String toString() => 'UseQueryHookResult{result:$result, fetcher:$fetch}';
}
