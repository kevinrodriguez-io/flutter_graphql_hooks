import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../types/operation_result.dart';
import '../types/query_operation_result.dart';

final _noop = () => {};

typedef _RefetchFunction = Future<void> Function();

/// Runs the given query defined by the options param([QueryOptions]) immediately
/// after the Widget is built (see [useEffect] usage). The fetcher function is not meant
/// to throw errors and these are stored in the error field.
QueryOperationResult<Map<String, dynamic>, _RefetchFunction> useQuery(
  QueryOptions queryOptions, {
  GraphQLClient client,
}) {
  final loading = useState(true);
  final data = useState<Map<String, dynamic>>(null);
  final error = useState<Exception>(null);

  final context = useContext();
  final graphqlClient = GraphQLProvider.of(context).value;

  final _RefetchFunction fetcher = useMemoized(
    () => () async {
      loading.value = true;
      try {
        final result = await graphqlClient.query(queryOptions);
        if (result.hasException) throw result.exception;
        data.value = result.data;
      } catch (e) {
        error.value = e;
      } finally {
        loading.value = false;
      }
    },
    [loading, data, error, graphqlClient, queryOptions],
  );

  useEffect(() {
    fetcher();
    return _noop;
  }, const []);

  return QueryOperationResult(
    OperationResult(data.value, loading.value, error.value),
    fetcher,
  );
}
