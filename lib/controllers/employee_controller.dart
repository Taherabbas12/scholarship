import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../database/database_helper.dart';
import '../models/employee_model.dart';

class EmployeeController extends GetxController {
  var employees = <EmployeeModel>[].obs;
  var isLoading = true.obs;
  var name = TextEditingController();
  var phone = TextEditingController();
  var position = TextEditingController();

  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    fetchEmployees();
    super.onInit();
  }

  Future<void> fetchEmployees() async {
    isLoading(true);
    try {
      var fetchedEmployees = await DatabaseHelper.getEmployees();
      employees.assignAll(fetchedEmployees);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addEmployeeView() async {
    EmployeeModel newEmployee = EmployeeModel(
      name: name.text,
      phone: phone.text,
      position: position.text,
      hireDate: selectedDate.value.toString(),
      salary: 90,
    );
    await DatabaseHelper.insertEmployee(newEmployee);
    fetchEmployees();
    Get.back();
  }

  Future<void> editEmployee(EmployeeModel employee) async {
    employee.name = name.text;
    employee.phone = phone.text;
    employee.position = position.text;
    employee.hireDate = selectedDate.value.toString();

    await DatabaseHelper.updateEmployee(employee);
    fetchEmployees();
    Get.back();
  }

  Future<void> deleteEmployee(int id) async {
    await DatabaseHelper.deleteEmployee(id);
    fetchEmployees();
  }

  void searchEmployees(String query) {
    if (query.isEmpty) {
      fetchEmployees();
    } else {
      var filteredEmployees = employees.where((employee) {
        return employee.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      employees.assignAll(filteredEmployees);
    }
  }
}
