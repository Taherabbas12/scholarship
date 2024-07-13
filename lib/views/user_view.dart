import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../color_app.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UserView extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorApp.primryColor,
            centerTitle: true,
            title: Text('إدارة المستخدمين',
                style: TextStyle(color: ColorApp.wihteColor))),
        body: Row(children: [
          Container(
            width: 330,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: ColorApp.primryColor.withOpacity(0.1),
            child: Column(
              children: [
                const Spacer(flex: 5),
                textInput('اسم الزبون', userController.name),
                textInput('اسم الجامعه', userController.nameUniversity),
                textInput('سعر المشروع', userController.totalPrice,
                    isDigits: true),
                textInput('معرف الزبون', userController.userTele),
                textInput('اسم المشروع', userController.nameProject,
                    maxLines: 3),
                Obx(() => Column(
                      children: [
                        TextField(
                          controller: TextEditingController(
                              text: DateFormat.yMd().format(
                                  userController.selectedDateStart.value)),
                          readOnly: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'تاريخ المشروع',
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  userController.selectedDateStart.value,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null &&
                                pickedDate !=
                                    userController.selectedDateStart.value) {
                              userController.selectedDateStart.value =
                                  pickedDate;
                            }
                          },
                        ),
                        SizedBox(height: 5),
                        TextField(
                          controller: TextEditingController(
                              text: DateFormat.yMd().format(
                                  userController.selectedDateEnd.value)),
                          readOnly: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'تاريخ المشروع',
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: userController.selectedDateEnd.value,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null &&
                                pickedDate !=
                                    userController.selectedDateEnd.value) {
                              userController.selectedDateEnd.value = pickedDate;
                            }
                          },
                        )
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
                    await userController.addUserView();
                  },
                  child: Text(
                    'أضافة الحساب',
                    style: TextStyle(fontSize: 18, color: ColorApp.wihteColor),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(child: Obx(() {
            if (userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: userController.searchController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'ابحث عن اسم المستخدم',
                    ),
                    onChanged: (value) {
                      userController.searchUsers(value);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: userController.users.length,
                      itemBuilder: (context, index) {
                        final user = userController.users[index];
                        return Card(
                          margin: const EdgeInsets.all(10.0),
                          child: Padding(
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
                                    _buildTableRow('ID', user.id.toString()),
                                    _buildTableRow('Name', user.name),
                                    _buildTableRow('User Tele', user.userTele),
                                    _buildTableRow(
                                        'Project Name', user.nameProject),
                                    _buildTableRow(
                                        'University Name', user.nameUniversity),
                                    _buildTableRow('Total Price',
                                        user.totalPrice.toString()),
                                    _buildTableRow('Project Done',
                                        user.isDoneProject ? 'Yes' : 'No'),
                                    _buildTableRow('Price Done',
                                        user.isDonePrice ? 'Yes' : 'No'),
                                    _buildTableRow(
                                        'Date Start',
                                        DateFormat.yMd()
                                            .format(user.dateStart)),
                                    _buildTableRow('Date End',
                                        DateFormat.yMd().format(user.dateEnd)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showEditUserDialog(user, context);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        userController.deleteUser(user.id!);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }))
        ]));
  }

  void showEditUserDialog(UserModel user, BuildContext context) {
    userController.name.text = user.name;
    userController.userTele.text = user.userTele;
    userController.nameProject.text = user.nameProject;
    userController.nameUniversity.text = user.nameUniversity;
    userController.totalPrice.text = user.totalPrice.toString();
    userController.selectedDateStart.value = user.dateStart;
    userController.selectedDateEnd.value = user.dateEnd;

    Get.dialog(
      AlertDialog(
        title: Text('تحرير المستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            textInput('اسم الزبون', userController.name),
            textInput('اسم الجامعه', userController.nameUniversity),
            textInput('سعر المشروع', userController.totalPrice, isDigits: true),
            textInput('معرف الزبون', userController.userTele),
            textInput('اسم المشروع', userController.nameProject, maxLines: 3),
            Obx(() => Column(
                  children: [
                    TextField(
                      controller: TextEditingController(
                          text: DateFormat.yMd()
                              .format(userController.selectedDateStart.value)),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'تاريخ المشروع',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: userController.selectedDateStart.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null &&
                            pickedDate !=
                                userController.selectedDateStart.value) {
                          userController.selectedDateStart.value = pickedDate;
                        }
                      },
                    ),
                    TextField(
                      controller: TextEditingController(
                          text: DateFormat.yMd()
                              .format(userController.selectedDateStart.value)),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'تاريخ المشروع',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: userController.selectedDateEnd.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null &&
                            pickedDate !=
                                userController.selectedDateEnd.value) {
                          userController.selectedDateEnd.value = pickedDate;
                        }
                      },
                    )
                  ],
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => userController.editUser(user),
            child: Text('حفظ التعديلات'),
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
      {bool isDigits = false, maxLines = 1}) {
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
