import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../database/database_helper.dart';
import '../models/spending_model.dart';

class SpendingController extends GetxController {
  var spendings = <SpendingModel>[].obs;
  var isLoading = true.obs;
  var amount = TextEditingController();
  var note = TextEditingController();
  var colorTile = TextEditingController();
  var selectedDate = DateTime.now().obs;
  List<String> colorTileList = ['دفع', 'استلام'];

  @override
  void onInit() {
    fetchSpendings();
    super.onInit();
  }

  Future<void> fetchSpendings() async {
    isLoading(true);
    try {
      var fetchedSpendings = await DatabaseHelper.getSpendings();
      spendings.assignAll(fetchedSpendings);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addSpendingView() async {
    SpendingModel newSpending = SpendingModel(
      amount: double.parse(amount.text),
      date: selectedDate.value.toString(),
      note: note.text,
      colorTile: colorTile.text,
    );
    await DatabaseHelper.insertSpending(newSpending);
    fetchSpendings();
    Get.back();
  }

  Future<void> editSpending(SpendingModel spending) async {
    spending.amount = double.parse(amount.text);
    spending.date = selectedDate.value.toString();
    spending.note = note.text;

    await DatabaseHelper.updateSpending(spending);
    fetchSpendings();
    Get.back();
  }

  Future<void> deleteSpending(int id) async {
    await DatabaseHelper.deleteSpending(id);
    fetchSpendings();
  }

  void searchSpendings(String query) {
    if (query.isEmpty) {
      fetchSpendings();
    } else {
      var filteredSpendings = spendings.where((spending) {
        return spending.note.toLowerCase().contains(query.toLowerCase());
      }).toList();
      spendings.assignAll(filteredSpendings);
    }
  }
}
