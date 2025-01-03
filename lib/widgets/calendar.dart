import 'package:diet_macro/services/isar.service.dart';
import 'package:diet_macro/utils/color_set.dart';
import 'package:diet_macro/widgets/nutrition_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:diet_macro/models/isar_data.dart';
import '../utils/google_text_styles.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  final DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal();
  DateTime? _selectedDay;
  DailyData? _dailyData;
  TargetData? _targetData; // TargetData 추가

  @override
  void initState() {
    super.initState();
    _loadTargetData(); // TargetData 로드
    _loadDailyDataForFocusedDay(); // initState에서 focusedDay의 데이터를 로드
  }

  // TargetData 로드 함수
  Future<void> _loadTargetData() async {
    _targetData = await IsarService().getTargetData();
  }

  // focusedDay의 DailyData 로드
  Future<void> _loadDailyDataForFocusedDay() async {
    _dailyData = await IsarService().getDailyDataByDate(_focusedDay);
    setState(() {}); // UI 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      color: mainColor,
      child: Column(
        children: [
          TableCalendar(
            // 캘린더 스타일 및 속성 설정
            calendarStyle: _calendarStyle(),
            headerStyle: _headerStyle(),
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2040, 12, 31),
            focusedDay: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal(),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'}, // Disable format button
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day).toLocal();
              });
              _dailyData = await IsarService().getDailyDataByDate(_selectedDay!);
            },
          ),

          const SizedBox(height: 8),

          // 선택한 날짜의 DailyData 표시
          if (_dailyData == null) ...[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    // 텍스트를 가운데 정렬
                    child: Text(
                      'No Data',
                      style: GoogleTextStyles.dmSerifDisplayHeader(
                        color: Colors.grey[80],
                      ),
                    ).animate().fade(duration: const Duration(milliseconds: 200)),
                  ),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    NutritionTile(
                      dividerColor: Colors.red.shade600,
                      nutrition: "Calories",
                      status: '${_dailyData?.calories} / ${_targetData?.targetCalories ?? 0} kcal',
                      percentage: (_targetData != null && _dailyData!.calories > 0)
                          ? (_dailyData!.calories / _targetData!.targetCalories * 100).toInt()
                          : 0,
                    ).animate().fade(),
                    const SizedBox(height: 12),
                    NutritionTile(
                      dividerColor: Colors.green.shade600,
                      nutrition: "Carb",
                      status: '${_dailyData!.carb} / ${_targetData?.targetCarb ?? 0} g',
                      percentage: (_targetData != null && _dailyData!.carb > 0)
                          ? (_dailyData!.carb / _targetData!.targetCarb * 100).toInt()
                          : 0,
                    ).animate().fade(),
                    const SizedBox(height: 12),
                    NutritionTile(
                      dividerColor: Colors.blue.shade800,
                      nutrition: "Protein",
                      status: '${_dailyData!.protein} / ${_targetData?.targetProtein ?? 0} g',
                      percentage: (_targetData != null && _dailyData!.protein > 0)
                          ? (_dailyData!.protein / _targetData!.targetProtein * 100).toInt()
                          : 0,
                    ).animate().fade(),
                    const SizedBox(height: 12),
                    NutritionTile(
                      dividerColor: Colors.brown.shade600,
                      nutrition: "Fat",
                      status: '${_dailyData!.fat} / ${_targetData?.targetFat ?? 0} g',
                      percentage: (_targetData != null && _dailyData!.fat > 0)
                          ? (_dailyData!.fat / _targetData!.targetFat * 100).toInt()
                          : 0,
                    ).animate().fade(),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  CalendarStyle _calendarStyle() {
    return CalendarStyle(
      tablePadding: const EdgeInsets.all(8),
      defaultTextStyle: GoogleTextStyles.dmSerifDisplayBold(), // 기본 날짜 텍스트 굵게
      weekendTextStyle: GoogleTextStyles.dmSerifDisplayBold(), // 주말 날짜 텍스트 굵게
      selectedTextStyle: GoogleTextStyles.dmSerifDisplayBold(), // 선택된 날짜 텍스트 굵게
      todayTextStyle: GoogleTextStyles.dmSerifDisplayBold(),
    );
  }

  HeaderStyle _headerStyle() {
    return HeaderStyle(
      rightChevronIcon: Icon(Icons.arrow_circle_right, color: Colors.grey[800]),
      leftChevronIcon: Icon(Icons.arrow_circle_left, color: Colors.grey[800]),
      headerPadding: const EdgeInsets.only(bottom: 12, left: 60, right: 60),
      titleTextFormatter: (date, locale) => date.month.toString(),
      titleTextStyle: GoogleTextStyles.dmSerifDisplayHeader(), // 월, 년도 텍스트 스타일
      formatButtonVisible: false, // 형식 버튼 숨기기
      titleCentered: true, // 제목 중앙 정렬
    );
  }
}
