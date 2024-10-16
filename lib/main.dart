import 'package:diet_macro/diet_provider.dart';
import 'package:diet_macro/food_provider.dart';
import 'package:diet_macro/models/isar_data.dart';
import 'package:diet_macro/services/isar.service.dart';
import 'package:diet_macro/pages/first_intro.dart';
import 'package:diet_macro/pages/main_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // 앱 초기화 시 IsarService 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.initialize();

  final targetCalories = await IsarService().getTargetData();

  // api test
  // await fetchFoodNutrition('cheese');

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
      home: targetCalories == null ? const FirstIntro() : const MainPage(), // 조건에 따라 페이지 설정
    );
  }
}
