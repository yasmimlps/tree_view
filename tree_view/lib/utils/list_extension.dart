extension SafeAccess<T> on List<T> {
  T? safeGet(int index) {
    if (index >= 0 && index < this.length) {
      return this[index];
    } else {
      return null;
    }
  }
}
