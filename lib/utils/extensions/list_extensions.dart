extension ListExtensions<T> on List<T> {
  List<T> iadd(T newValue) {
    final copy = List<T>.from(this);
    copy.add(newValue);
    return copy;
  }

  List<T> ireplace(T oldValue, T newValue) {
    return map((e) => e == oldValue ? newValue : e).toList();
  }
}
