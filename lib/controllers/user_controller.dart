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
    //
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
          userTele: userTele.text.trim()));
      //
    } else {
      Get.showSnackbar(const GetSnackBar(
          backgroundColor: Colors.red,
          message: 'تأكد من ملئ كل الحقول',
          title: 'خطا في ادخال البيانات'));
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
}
