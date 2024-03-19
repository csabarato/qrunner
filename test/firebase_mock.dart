
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

typedef Callback = void Function(MethodCall call);



  Future<T> neverEndingFuture<T>() async {
    // ignore: literal_only_boolean_expressions
    while (true) {
      await Future.delayed(const Duration(minutes: 5));
    }
  }
