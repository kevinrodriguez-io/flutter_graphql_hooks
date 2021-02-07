import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../types/operation_result.dart';

final _noop = () => {};

/// This hook is very similar to the [useQuery] but don't expose a refetch
/// function, since it's nature is the one of a [Stream].
/// It will subscribe to the given subscription and unsubscribe thanks to
/// the internal usage of [useStream].
OperationResult<Map<String, dynamic>> useSubscription(
  SubscriptionOptions subscriptionOptions, {
  GraphQLClient client,
}) {
  final loading = useState(true);
  final data = useState<Map<String, dynamic>>(null);
  final error = useState<Exception>(null);

  final context = useContext();
  final graphqlClient = GraphQLProvider.of(context).value;

  final snap = useStream(
    useMemoized(
      () => graphqlClient.subscribe(subscriptionOptions),
      [graphqlClient],
    ),
  );

  useEffect(() {
    if (snap.connectionState == ConnectionState.waiting) {
      loading.value = true;
    } else {
      loading.value = false;
    }

    if (snap.hasError) {
      error.value = snap.error;
    }

    if (snap.hasData) {
      final result = snap.data;
      try {
        if (result.hasException) throw result.exception;
        data.value = result.data;
      } catch (e) {
        error.value = e;
      }
    }
    return _noop;
  }, [loading, data, error, graphqlClient, snap]);

  return OperationResult(
    data.value,
    loading.value,
    error.value,
  );
}
