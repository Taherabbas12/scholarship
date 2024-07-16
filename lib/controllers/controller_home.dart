import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/employee_view.dart';
import '../views/spending_view.dart';
import '../views/user_view.dart';

class ControllerHome extends GetxController {
  //
  int indexView = 0;

  List<Widget> views = [EmployeeView(), SpendingView(), UserView()];
  void changeView(int index) {
    indexView = index;
  }
}
