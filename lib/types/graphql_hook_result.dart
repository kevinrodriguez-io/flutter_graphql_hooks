/// The result of a graphql operation, represents the state
/// of a graphql hook.
class GraphQLHookResult<Data> {
  final bool loading;
  final Data data;
  final Exception error;

  const GraphQLHookResult(
    this.data,
    this.loading,
    this.error,
  );

  @override
  String toString() =>
      'GraphQLHookResult{loading:$loading, data:$data, error:$error}';
}
