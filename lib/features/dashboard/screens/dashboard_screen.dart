import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../health/screens/health_input_screen.dart';
import '../../health/screens/history_screen.dart';
import '../../health/screens/chart_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../auth/screens/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  /// 🔥 nút đẹp
  Widget quickButton(
      BuildContext context, String title, IconData icon, Widget screen) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Colors.grey.shade300,
              )
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.blue),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 logout
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 👋 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Xin chào 👋"),
                    Text(
                      user?.email ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.favorite, color: Colors.red),
              ],
            ),

            const SizedBox(height: 20),

            /// 💚 CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.green],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    "Tổng quan sức khỏe",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Hãy theo dõi sức khỏe mỗi ngày 💪",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⚡ BUTTONS
            Row(
              children: [
                quickButton(
                  context,
                  "Nhập",
                  Icons.edit,
                  const HealthInputScreen(),
                ),
                quickButton(
                  context,
                  "Lịch sử",
                  Icons.history,
                  const HistoryScreen(),
                ),
              ],
            ),

            Row(
              children: [
                quickButton(
                  context,
                  "Biểu đồ",
                  Icons.show_chart,
                  const ChartScreen(),
                ),
                quickButton(
                  context,
                  "Hồ sơ",
                  Icons.person,
                  const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}