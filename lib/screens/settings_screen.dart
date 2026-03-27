import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC),
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.outfit(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.build_circle_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Settings Under Construction',
              style: GoogleFonts.outfit(fontSize: 20, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
