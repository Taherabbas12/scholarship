import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  var users = <UserModel>[].obs;
  var isLoading = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController userTele = TextEditingController();
  TextEditingController nameProject = TextEditingController();
  TextEditingController nameUniversity = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  TextEditingController searchController =
      TextEditingController(); // خانة البحث
  Rx<DateTime> selectedDateStart = DateTime.now().obs; // حقل التاريخ
  Rx<DateTime> selectedDateEnd = DateTime.now().obs; // حقل التاريخ

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    users.value = await DatabaseHelper.getUsers();
    isLoading.value = false;
  }

  Future<void> addUserView() async {
    if (name.text.trim().isNotEmpty &&
        userTele.text.trim().isNotEmpty &&
        nameProject.text.trim().isNotEmpty &&
        nameUniversity.text.trim().isNotEmpty &&
        totalPrice.text.trim().isNotEmpty) {
      await addUser(UserModel(
        name: name.text.trim(),
        isDonePrice: false,
        isDoneProject: false,
        nameProject: nameProject.text.trim(),
        nameUniversity: nameUniversity.text.trim(),
        totalPrice: double.parse(totalPrice.text.trim()),
        userTele: userTele.text.trim(),
        dateStart: selectedDateStart.value,
        dateEnd: selectedDateEnd.value,
      )); // إضافة التاريخ
    } else {
      Get.showSnackbar(const GetSnackBar(
          backgroundColor: Colors.red,
          message: 'تأكد من ملئ كل الحقول',
          title: 'خطا في ادخال البيانات'));
    }
  }

  Future<void> editUser(UserModel user) async {
    if (name.text.trim().isNotEmpty &&
        userTele.text.trim().isNotEmpty &&
        nameProject.text.trim().isNotEmpty &&
        nameUniversity.text.trim().isNotEmpty &&
        totalPrice.text.trim().isNotEmpty) {
      user.name = name.text.trim();
      user.userTele = userTele.text.trim();
      user.nameProject = nameProject.text.trim();
      user.nameUniversity = nameUniversity.text.trim();
      user.totalPrice = double.parse(totalPrice.text.trim());
      user.dateStart = selectedDateStart.value; // تعديل التاريخ
      user.dateEnd = selectedDateEnd.value; // تعديل التاريخ

      await updateUser(user);
      Get.back();
    } else {
      Get.showSnackbar(const GetSnackBar(
          backgroundColor: Colors.red,
          message: 'تأكد من ملء كل الحقول',
          title: 'خطأ في إدخال البيانات'));
    }
  }

  Future<void> addUser(UserModel user) async {
    await DatabaseHelper.insertUser(user);
    fetchUsers();
  }

  Future<void> updateUser(UserModel user) async {
    await DatabaseHelper.updateUser(user);
    fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    await DatabaseHelper.deleteUser(id);
    fetchUsers();
  }

  void searchUsers(String query) {
    final filteredUsers = users.where((user) {
      final nameLower = user.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();
    users.value = filteredUsers;
  }
}
