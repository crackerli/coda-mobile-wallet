import 'package:collection/collection.dart';

/// Returns the smallest [k] elements from [inputs].
/// [desc] controls whether elements are smallest ([desc] = [false]) or
/// largest ([desc] = [true])
List<T> topK<T extends Comparable>(Iterable<T> inputs, int k,
    {bool desc = false}) {
  final q =
      HeapPriorityQueue<T>((T a, T b) => (desc ? -1 : 1) * b.compareTo(a));
  for (T item in inputs) {
    q.add(item);
    if (q.length > k) {
      q.removeFirst();
    }
  }
  return q.toList()..sort((T a, T b) => (desc ? -1 : 1) * a.compareTo(b));
}
