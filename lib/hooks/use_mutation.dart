import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../types/use_mutation_hook_result.dart';
import '../types/graphql_hook_result.dart';
import '../tools/mutation_options_extensions.dart';

typedef _MutationFunction = Future<Map<String, dynamic>> Function({
  MutationOptions options,
});

/// This hook creates a mutation function that is bound to the state
/// being held by the hook (data, loading, error); The function is also a
/// [Future] that returns a [Map<String, dynamic>] and throws, allowing
/// imperative usage.
UseMutationHookResult<Map<String, dynamic>, _MutationFunction> useMutation(
  MutationOptions mutationOptions, {
  GraphQLClient client,
}) {
  final loading = useState(false);
  final data = useState<Map<String, dynamic>>(null);
  final error = useState<Exception>(null);

  final context = useContext();
  final graphqlClient = client ?? GraphQLProvider.of(context).value;

  final _MutationFunction mutation = useMemoized(
    () => ({MutationOptions options}) async {
      try {
        final result = await graphqlClient.mutate(
            options == null ? mutationOptions : mutationOptions.merge(options));
        if (result.hasException) throw result.exception;
        data.value = result.data;
        return result.data;
      } catch (e) {
        error.value = e;
        throw e;
      } finally {
        loading.value = false;
      }
    },
    [loading, data, error, graphqlClient, mutationOptions],
  );

  return UseMutationHookResult(
    GraphQLHookResult(
      data.value,
      loading.value,
      error.value,
    ),
    mutation,
  );
}
