import 'top_k.dart' as top_k;

extension TopKIterableComparableExtion<T extends Comparable> on Iterable<T> {
  /// Returns the top [k] elements of [this].
  /// [desc] controls whether elements are smallest ([desc] = [false]) or
  /// largest ([desc] = [true])
  Iterable<T> topK(int k, {bool desc = false}) =>
      top_k.topK(this, k, desc: desc);
}

extension TopKIterableExtension<T> on Iterable<T> {
  /// Returns the top [k] elements of [this] comparing elements using [compareFn].
  /// [desc] controls whether elements are smallest ([desc] = [false]) or
  /// largest ([desc] = [true])
  Iterable<T> topK(int k, Comparable Function(T t) compareFn,
          {bool desc = false}) =>
      map((a) => _Comp(a, compareFn(a))).topK(k, desc: desc).map((e) => e.t);
}

class _Comp<T> with Comparable<_Comp<T>> {
  final T t;
  final Comparable c;

  _Comp(this.t, this.c);

  @override
  int compareTo(_Comp<T> other) => c.compareTo(other.c);
}
