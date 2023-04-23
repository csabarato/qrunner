
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

showLoadingIndicator(String status) async {

  EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.dualRing
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..progressColor = Colors.blueAccent;

  await EasyLoading.show(status: status);
}