
extension IterableX<T> on Iterable<T> {
  T safeFirstWhere(bool Function(T) test, {T Function() orElse}) {
    final sublist = where(test);
    return sublist.isEmpty ? (orElse != null ? orElse() : null) : sublist.first;
  }

  T safeFirst() {
    return isEmpty ? null : first;
  }
}