/// The result of a graphql operation, represents the state
/// of a graphql hook.
class OperationResult<Data> {
  final bool loading;
  final Data data;
  final Exception error;

  const OperationResult(
    this.data,
    this.loading,
    this.error,
  );

  @override
  String toString() =>
      'OperationResult{loading:$loading, data:$data, error:$error}';
}
