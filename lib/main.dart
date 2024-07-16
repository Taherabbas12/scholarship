// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/controller_home.dart';
import 'views/home_view.dart';
import 'views/user_view.dart';
import '../controllers/user_controller.dart';
import '../controllers/employee_controller.dart';
import '../controllers/spending_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      textDirection: TextDirection.rtl,
      title: 'Scholarship',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),

      getPages: [
        GetPage(
          name: '/',
          page: () => HomeView(),
          bindings: [
            BindingsBuilder(() => Get.lazyPut(() => ControllerHome())),
            BindingsBuilder(() => Get.lazyPut(() => UserController())),
            BindingsBuilder(() => Get.lazyPut(() => EmployeeController())),
            BindingsBuilder(() => Get.lazyPut(() => SpendingController())),
          ],
        ),
      ],
      // routes: {'/': () => HomeView()},
    );
  }
}

// class InitialBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ControllerHome>(() => ControllerHome());
//     Get.lazyPut<UserController>(() => UserController());
//     Get.lazyPut<EmployeeController>(() => EmployeeController());
//     Get.lazyPut<SpendingController>(() => SpendingController());
//   }
// }
