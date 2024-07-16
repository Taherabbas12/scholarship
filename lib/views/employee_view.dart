import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../color_app.dart';
import '../controllers/employee_controller.dart';
import '../models/employee_model.dart';

class EmployeeView extends StatelessWidget {
  final EmployeeController employeeController = Get.put(EmployeeController());

  EmployeeView({super.key});

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
              textInput('اسم الموظف', employeeController.name),
              textInput('رقم الهاتف', employeeController.phone),
              textInput('الوظيفة', employeeController.position),
              // textInput('الراتب', employeeController.position),
              Obx(() => Column(
                    children: [
                      TextField(
                        controller: TextEditingController(
                            text: DateFormat.yMd()
                                .format(employeeController.selectedDate.value)),
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'التاريخ',
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: employeeController.selectedDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null &&
                              pickedDate !=
                                  employeeController.selectedDate.value) {
                            employeeController.selectedDate.value = pickedDate;
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
                  await employeeController.addEmployeeView();
                },
                child: Text(
                  'أضافة الموظف',
                  style: TextStyle(fontSize: 18, color: ColorApp.wihteColor),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (employeeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'ابحث عن اسم الموظف',
                    ),
                    onChanged: (value) {
                      employeeController.searchEmployees(value);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: employeeController.employees.length,
                      itemBuilder: (context, index) {
                        final employee = employeeController.employees[index];
                        return ExpansionTile(
                          title: Text(
                              'الاسم : (${employee.name})  الوظيفة : (${employee.position})'),
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
                                          'ID', employee.id.toString()),
                                      _buildTableRow('Name', employee.name),
                                      _buildTableRow('Phone', employee.phone),
                                      _buildTableRow(
                                          'Position', employee.position),
                                      _buildTableRow(
                                          'Date',
                                          DateFormat.yMd().format(
                                              DateTime.parse(
                                                  employee.hireDate))),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          showEditEmployeeDialog(
                                              employee, context);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          employeeController
                                              .deleteEmployee(employee.id!);
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

  void showEditEmployeeDialog(EmployeeModel employee, BuildContext context) {
    employeeController.name.text = employee.name;
    employeeController.phone.text = employee.phone;
    employeeController.position.text = employee.position;
    employeeController.selectedDate.value = DateTime.parse(employee.hireDate);

    Get.dialog(
      AlertDialog(
        title: const Text('تحرير الموظف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            textInput('اسم الموظف', employeeController.name),
            textInput('رقم الهاتف', employeeController.phone),
            textInput('الوظيفة', employeeController.position),
            Obx(() => TextField(
                  controller: TextEditingController(
                      text: DateFormat.yMd()
                          .format(employeeController.selectedDate.value)),
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'التاريخ',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: employeeController.selectedDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null &&
                        pickedDate != employeeController.selectedDate.value) {
                      employeeController.selectedDate.value = pickedDate;
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
            onPressed: () => employeeController.editEmployee(employee),
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
