import 'package:diet_macro/utils/components/calendar.dart';
import 'package:diet_macro/utils/components/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            'Welcome to',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              // color: Colors.grey[850],
            ),
          ).animate().fade(),
          Text(
            'MyMacro',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 42,
              fontWeight: FontWeight.w700,
              // color: Colors.grey[850],
            ),
          ).animate().fade(),
          const SizedBox(height: 12),
          Divider(
            color: Colors.grey[500],
            indent: 42,
            endIndent: 42,
          ),
          const Spacer(),
          const SettingCard(
            title: 'Reset',
            subtitle: 'Reset your calories goal',
            iconDir: 'lib/images/reset.json',
          ).animate().fade(),
          const SizedBox(height: 20),
          const SettingCard(
            title: 'Delete',
            subtitle: 'Delete all of daily data',
            iconDir: 'lib/images/delete.json',
          ).animate().fade(),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}