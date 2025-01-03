import 'package:diet_macro/providers/diet_provider.dart';
import 'package:diet_macro/providers/food_provider.dart';
import 'package:diet_macro/models/isar_data.dart';
import 'package:diet_macro/services/isar.service.dart';
import 'package:diet_macro/screens/intro_screens/first_intro.dart';
import 'package:diet_macro/page_router.dart';
import 'package:diet_macro/services/noti.service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // 앱 초기화 시 IsarService 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await IsarService.initialize();

  final targetCalories = await IsarService().getTargetData();

  // local noti test
  Future.delayed(const Duration(seconds: 3), () {
    // print('알람 테스트');
    // NotificationService().showTestNotification("title", "body test");
    NotificationService().scheduleDailyNotification();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => DietProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => FoodProvider()),
      ],
      child: MyApp(targetCalories: targetCalories),
    ),
  ); // targetCalories 전달
}

class MyApp extends StatelessWidget {
  final TargetData? targetCalories; // targetCalories 받기

  const MyApp({super.key, required this.targetCalories});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: targetCalories == null ? const FirstIntro() : const PageRouter(), // 조건에 따라 페이지 설정
    );
  }
}
