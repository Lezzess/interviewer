extension ListExtensions<T> on List<T> {
  List<T> replace(T oldValue, T newValue) {
    return map((e) => e == oldValue ? newValue : e).toList();
  }
}
