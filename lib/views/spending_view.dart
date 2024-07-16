import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../color_app.dart';
import '../controllers/spending_controller.dart';
import '../models/spending_model.dart';

class SpendingView extends StatelessWidget {
  final SpendingController spendingController = Get.put(SpendingController());

  SpendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 330,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: ColorApp.primryColor.withOpacity(0.1),
          child: Column(
            children: [
              const Spacer(flex: 5),
              textInput('المبلغ', spendingController.amount, isDigits: true),
              textInput('الملاحظة', spendingController.note, maxLines: 3),
              textInputList('نوع العمليه', spendingController.colorTile,
                  dropdownItems: spendingController.colorTileList),
              Obx(() => Column(
                    children: [
                      TextField(
                        controller: TextEditingController(
                            text: DateFormat.yMd()
                                .format(spendingController.selectedDate.value)),
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'التاريخ',
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: spendingController.selectedDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null &&
                              pickedDate !=
                                  spendingController.selectedDate.value) {
                            spendingController.selectedDate.value = pickedDate;
                          }
                        },
                      ),
                    ],
                  )),
              const Spacer(flex: 2),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 40),
                    backgroundColor: ColorApp.primryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                onPressed: () async {
                  await spendingController.addSpendingView();
                },
                child: Text(
                  'أضافة المصروف',
                  style: TextStyle(fontSize: 18, color: ColorApp.wihteColor),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (spendingController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'ابحث عن الملاحظة',
                    ),
                    onChanged: (value) {
                      spendingController.searchSpendings(value);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: spendingController.spendings.length,
                      itemBuilder: (context, index) {
                        final spending = spendingController.spendings[index];
                        return ExpansionTile(
                          title: Text(
                              'المبلغ : (${spending.amount})  الملاحظة : (${spending.note})'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(3),
                                    },
                                    children: [
                                      _buildTableRow(
                                          'ID', spending.id.toString()),
                                      _buildTableRow(
                                          'Amount', spending.amount.toString()),
                                      _buildTableRow(
                                          'Date',
                                          DateFormat.yMd().format(
                                              DateTime.parse(spending.date))),
                                      _buildTableRow('Note', spending.note),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          showEditSpendingDialog(
                                              spending, context);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          spendingController
                                              .deleteSpending(spending.id!);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  void showEditSpendingDialog(SpendingModel spending, BuildContext context) {
    spendingController.amount.text = spending.amount.toString();
    spendingController.note.text = spending.note;
    spendingController.selectedDate.value = DateTime.parse(spending.date);

    Get.dialog(
      AlertDialog(
        title: const Text('تحرير المصروف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            textInput('المبلغ', spendingController.amount, isDigits: true),
            textInput('الملاحظة', spendingController.note, maxLines: 3),
            Obx(() => TextField(
                  controller: TextEditingController(
                      text: DateFormat.yMd()
                          .format(spendingController.selectedDate.value)),
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'التاريخ',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: spendingController.selectedDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null &&
                        pickedDate != spendingController.selectedDate.value) {
                      spendingController.selectedDate.value = pickedDate;
                    }
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => spendingController.editSpending(spending),
            child: const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget textInputList(
    String name,
    TextEditingController controller, {
    bool isDigits = false,
    int maxLines = 1,
    List<String>? dropdownItems, // قائمة العناصر للاختيار منها
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: dropdownItems == null
          ? TextFormField(
              controller: controller,
              maxLines: maxLines,
              inputFormatters: [
                if (isDigits) FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: name,
              ),
            )
          : DropdownButtonFormField<String>(
              value: controller.text.isEmpty ? null : controller.text,
              items: dropdownItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                controller.text = newValue!;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: name,
              ),
            ),
    );
  }

  Widget textInput(String name, TextEditingController controller,
      {bool isDigits = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        inputFormatters: [if (isDigits) FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: name,
        ),
      ),
    );
  }
}
