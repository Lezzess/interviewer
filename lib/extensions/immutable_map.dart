extension MapExtensions<TKey, TValue> on Map<TKey, TValue> {
  Map<TKey, TValue> iadd(TKey key, TValue value) {
    return ireplace(key, value);
  }

  Map<TKey, TValue> ireplace(TKey key, TValue value) {
    final copy = Map<TKey, TValue>.from(this);
    copy[key] = value;
    return copy;
  }

  Map<TKey, TValue> iremove(TKey key) {
    final copy = Map<TKey, TValue>.from(this);
    copy.remove(key);
    return copy;
  }
}
