/// Additional behavioral options that are meant to modify the hook behavior.
/// (Different from [QueryOptions] or [MutationOptions]).
class HookOptions {
  /// Indicates that this hook throws if the related method finds an error (try-catch-throw)
  /// If left as false, the error will only be set on the hook itself.
  final bool throwsOnMethodExecution;
  const HookOptions(this.throwsOnMethodExecution);
}
