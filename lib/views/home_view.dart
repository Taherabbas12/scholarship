import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller_home.dart';

class HomeView extends StatelessWidget {
  ControllerHome controllerHome = Get.find<ControllerHome>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(child: Text('الموظفين')),
                Tab(child: Text('المصروفات')),
                Tab(child: Text('الطلاب')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: controllerHome.views,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ControllerHome
