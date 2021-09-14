<h1 align="center">Flutter GraphQL Hooks 🪝</h1>
<pre>LOOKING FOR MAINTAINERS</pre>
<p align="center">
  <a href="https://github.com/kevinrodriguez-io/flutter_graphql_hooks/watchers"><img src="https://img.shields.io/github/watchers/kevinrodriguez-io/flutter_graphql_hooks?style=social" alt="Watch on GitHub" /></a>
  <a href="https://github.com/kevinrodriguez-io/flutter_graphql_hooks/stargazers"><img src="https://img.shields.io/github/stars/kevinrodriguez-io/flutter_graphql_hooks?style=social" alt="Star on GitHub" /></a>
  <a href="https://twitter.com/intent/tweet?text=Check out flutter_graphql_hooks 🪝, an apollo-like set of hooks for flutter. https://github.com/kevinrodriguez-io/flutter_graphql_hooks"><img src="https://img.shields.io/twitter/url/https/github.com/kevinrodriguez-io/flutter_graphql_hooks.svg?style=social" alt="Tweet!" /></a>
</p>

# Introduction

This package exposes an apollo-like set of hooks to be used with flutter,
it's meant to be used together with the `graphql_flutter` package and it's
based on it's latest implementation.

It can be used along with `artemis` to provide strongly typed hooks, example:

```dart
final query = GetRoomsQuery(variables: GetRoomsArguments(limit: 10, offset: 0));

final rooms = useQuery(QueryOptions(
  document: query.document,
  variables: query.getVariablesMap(),
));

final loading = rooms.result.loading;
final error = rooms.result.error;
final data = query.parse(rooms.result.data);
// Data will no longer be a [Map<String, dynamic>] and will have proper typings! 
```

# Installing

```yml
dependencies:
  flutter_graphql_hooks:
```

# Notes

In order to use the hooks, a `GraphqlProvider` must exist on the build context.
Otherwise you'll need to manually pass the client in the hook as a parameter like:

```dart
final rooms = useQuery(QueryOptions(
  document: query.document,
  variables: query.getVariablesMap(),
), client: myGraphqlClient);
```
