extension ListExtensions<T> on List<T> {
  List<T> iadd(T newValue) {
    final copy = List<T>.from(this);
    copy.add(newValue);
    return copy;
  }

  List<T> ireplace(T oldValue, T newValue) {
    return map((e) => e == oldValue ? newValue : e).toList();
  }

  List<T> iremvoe(T value) {
    final index = indexOf(value);
    if (index == -1) {
      return this;
    }

    final copy = <T>[];
    copy.addAll(sublist(0, index));
    copy.addAll(sublist(index + 1));

    return copy;
  }
}
