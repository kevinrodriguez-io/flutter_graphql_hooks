import 'package:graphql_flutter/graphql_flutter.dart';

extension MutationOptionsMerger on MutationOptions {
  MutationOptions merge(MutationOptions b) => new MutationOptions(
        fetchPolicy: b.fetchPolicy ?? this.fetchPolicy,
        errorPolicy: b.errorPolicy ?? this.errorPolicy,
        cacheRereadPolicy: b.cacheRereadPolicy ?? this.cacheRereadPolicy,
        context: b.context ?? this.context,
        optimisticResult: b.optimisticResult ?? this.optimisticResult,
        onCompleted: b.onCompleted ?? this.onCompleted,
        update: b.update ?? this.update,
        onError: b.onError ?? this.onError,
        document: b.document ?? this.document,
        variables: b.variables ?? this.variables,
      );
}
