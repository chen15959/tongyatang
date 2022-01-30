
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// import 'assertions.dart';
// import 'basic_types.dart';
// import 'diagnostics.dart';

typedef MyCallback = void Function(dynamic x);


abstract class MyListenable {
  const MyListenable();

  void addListener(MyCallback listener);

  void removeListener(MyCallback listener);
}


// abstract class MyValueListenable<T> extends MyListenable {
//   const MyValueListenable();
//
//   T get value;
// }


class MyChangeNotifier<T> implements MyListenable {
  int _count = 0;
  List<MyCallback?> _listeners = List<MyCallback?>.filled(0, null, growable: true);

  @protected
  bool get hasListeners {
    return _count > 0;
  }

  @override
  void addListener(MyCallback listener) {
    _listeners.add(listener);
    _count++;
  }

  @override
  void removeListener(MyCallback listener) {
    for (int i = 0; i < _listeners.length; ++i) {
      if (_listeners[i] == listener) {
        _listeners[i] = null;
        _count--;
        return;
      }
    }
  }


  @protected
  void notifyListeners(T obj) {
    if (_listeners.isEmpty) {
      return;
    }

    for (MyCallback? listener in _listeners) {
      try {
        listener?.call(obj);
      }
      catch (ex) {
        //TODO
      }
    }
  }


}



class MyValueNotifier<T> extends MyChangeNotifier<T> {

  MyValueNotifier(this._value);

  T _value;

  @override
  T get value => _value;

  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    super.notifyListeners(newValue);
  }
}


