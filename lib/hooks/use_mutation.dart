import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../types/hook_options.dart';
import '../types/mutation_operation_result.dart';
import '../types/operation_result.dart';
import '../tools/mutation_options_extensions.dart';

typedef _MutationFunction = Future<Map<String, dynamic>> Function({
  MutationOptions options,
});

/// This hook creates a mutation function that is bound to the state
/// being held by the hook (data, loading, error); The function is also a
/// [Future] that returns a [Map<String, dynamic>] and throws, allowing
/// imperative usage.
///
/// You must provide mutation options at either hook input level
/// or as part of the params in the mutation function.
MutationOperationResult<Map<String, dynamic>, _MutationFunction> useMutation({
  MutationOptions mutationOptions,
  GraphQLClient client,
  HookOptions hookOptions = const HookOptions(true),
}) {
  final loading = useState(false);
  final data = useState<Map<String, dynamic>>(null);
  final error = useState<Exception>(null);

  final context = useContext();
  final graphqlClient = client ?? GraphQLProvider.of(context).value;

  final _MutationFunction mutation = useMemoized(
    () => ({
      MutationOptions options,
    }) async {
      assert(
        options != null || mutationOptions != null,
        "You must provide mutation options at either hook input level or as part of the params in the mutation function.",
      );
      loading.value = true;
      final shouldMerge = options != null && mutationOptions != null;
      try {
        final result = await graphqlClient.mutate(
          shouldMerge
              ? mutationOptions.merge(options)
              : options ?? mutationOptions,
        );
        if (result.hasException) throw result.exception;
        data.value = result.data;
        return result.data;
      } catch (e) {
        error.value = e;
        if (hookOptions.throwsOnMethodExecution) {
          throw e;
        }
        return Map<String, dynamic>();
      } finally {
        loading.value = false;
      }
    },
    [loading, data, error, graphqlClient, mutationOptions],
  );

  return MutationOperationResult(
    OperationResult(data.value, loading.value, error.value),
    mutation,
  );
}
