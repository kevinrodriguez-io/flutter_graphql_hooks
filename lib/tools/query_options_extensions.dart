import 'package:graphql_flutter/graphql_flutter.dart';

extension QueryOptionsMerger on QueryOptions {
  QueryOptions merge(QueryOptions b) => new QueryOptions(
        document: b.document ?? this.document,
        operationName: b.operationName ?? this.operationName,
        variables: b.variables ?? this.variables,
        fetchPolicy: b.fetchPolicy ?? this.fetchPolicy,
        errorPolicy: b.errorPolicy ?? this.errorPolicy,
        cacheRereadPolicy: b.cacheRereadPolicy ?? this.cacheRereadPolicy,
        optimisticResult: b.optimisticResult ?? this.optimisticResult,
        pollInterval: b.pollInterval ?? this.pollInterval,
        context: b.context ?? this.context,
      );
}
