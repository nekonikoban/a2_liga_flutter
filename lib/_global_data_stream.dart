import 'dart:async';

class GlobalDataStream {
  List<String> initialArray = [];

  List<String> get data => initialArray;

  void updateData(List<String> newArray) {
    initialArray.clear();
    initialArray.addAll(newArray);
    _controller.add(newArray);
  }

  List<String> getData() {
    return initialArray;
  }

  final _controller = StreamController<List<String>>.broadcast();

  Stream<List<String>> get stream => _controller.stream;
}
