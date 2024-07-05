import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../color_app.dart';
import '../controllers/user_controller.dart';

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
                const Spacer(flex: 2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: ColorApp.primryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () async {
                    //
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
            return ListView.builder(
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
                        Text('ID: ${user.id}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Name: ${user.name}',
                            style: const TextStyle(fontSize: 16)),
                        Text('User Tele: ${user.userTele}',
                            style: const TextStyle(fontSize: 16)),
                        Text('Project Name: ${user.nameProject}',
                            style: const TextStyle(fontSize: 16)),
                        Text('University Name: ${user.nameUniversity}',
                            style: const TextStyle(fontSize: 16)),
                        Text('Total Price: ${user.totalPrice}',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Project Done: ${user.isDoneProject ? 'Yes' : 'No'}',
                            style: const TextStyle(fontSize: 16)),
                        Text('Price Done: ${user.isDonePrice ? 'Yes' : 'No'}',
                            style: const TextStyle(fontSize: 16)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // تعديل المستخدم
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
              },
            );
          }))
        ]));
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
