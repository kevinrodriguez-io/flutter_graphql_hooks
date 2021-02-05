import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../types/graphql_hook_result.dart';
import '../types/use_query_hook_result.dart';
import '../tools/query_options_extensions.dart';

typedef _FetchFunction = Future<Map<String, dynamic>> Function({
  QueryOptions options,
});

/// Similar to [useQuery], however, this hook won't run immediately,
/// making it more similar to the [useMutation] hook,
/// which returns a function that is bound to the hook internal state.
/// The fetch function returns a [Future<Map<String, dynamic>>] that will
/// also throw an [Exception], allowing imperative usage.
UseQueryHookResult<Map<String, dynamic>, _FetchFunction> useLazyQuery(
  QueryOptions queryOptions, {
  GraphQLClient client,
}) {
  final loading = useState(false);
  final data = useState<Map<String, dynamic>>(null);
  final error = useState<Exception>(null);

  final context = useContext();
  final graphqlClient = client ?? GraphQLProvider.of(context).value;

  final _FetchFunction fetcher = useMemoized(
    () => ({QueryOptions options}) async {
      loading.value = true;
      try {
        final result = await graphqlClient.query(
          options == null ? queryOptions : queryOptions.merge(options),
        );
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
    [loading, data, error, graphqlClient, queryOptions],
  );

  return UseQueryHookResult(
    GraphQLHookResult(
      data.value,
      loading.value,
      error.value,
    ),
    fetcher,
  );
}
