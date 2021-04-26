import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../types/hook_options.dart';
import '../types/operation_result.dart';
import '../types/query_operation_result.dart';
import '../tools/query_options_extensions.dart';

typedef _FetchFunction = Future<Map<String, dynamic>> Function({
  QueryOptions options,
});

/// Similar to [useQuery], however, this hook won't run immediately,
/// making it more similar to the [useMutation] hook,
/// which returns a function that is bound to the hook internal state.
/// The fetch function returns a [Future<Map<String, dynamic>>] that will
/// also throw an [Exception], allowing imperative usage.
///
/// You must provide query options at either hook input level
/// or as part of the params in the fetcher function.
QueryOperationResult<Map<String, dynamic>, _FetchFunction> useLazyQuery({
  QueryOptions queryOptions,
  GraphQLClient client,
  HookOptions hookOptions = const HookOptions(true),
}) {
  final loading = useState(false);
  final data = useState<Map<String, dynamic>>(null);
  final error = useState<Exception>(null);

  final context = useContext();
  final graphqlClient = client ?? GraphQLProvider.of(context).value;

  final _FetchFunction fetcher = useMemoized(
    () => ({QueryOptions options}) async {
      assert(
        options != null || queryOptions != null,
        "You must provide query options at either hook input level or as part of the params in the fetcher function.",
      );
      loading.value = true;
      final shouldMerge = options != null && queryOptions != null;
      try {
        final result = await graphqlClient.query(
          shouldMerge ? queryOptions.merge(options) : options ?? queryOptions,
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
    [loading, data, error, graphqlClient, queryOptions],
  );

  return QueryOperationResult(
    OperationResult(data.value, loading.value, error.value),
    fetcher,
  );
}
