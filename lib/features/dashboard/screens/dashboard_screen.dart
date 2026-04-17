import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../health/screens/health_input_screen.dart';
import '../../health/screens/history_screen.dart';
import '../../health/screens/chart_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../auth/screens/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  /// 🔥 BUTTON CARD
  Widget quickButton(
      BuildContext context, String title, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 LOGOUT
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
      backgroundColor: const Color(0xFFF5F7FB),

      /// 🔥 APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: const [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text(
              "Health App",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => logout(context),
          )
        ],
      ),

      /// 🔥 FIX KHÔNG BỊ KÉO GIÃN
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420, // 🔥 KHÓA WIDTH
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// 👋 HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue,
                        child: Text(
                          (user?.email ?? "U")[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Xin chào 👋"),
                            Text(
                              user?.email ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.favorite, color: Colors.red),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 💚 CARD TỔNG QUAN
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tổng quan sức khỏe",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Theo dõi sức khỏe mỗi ngày 💪",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// 🔥 GRID BUTTON
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [

                      quickButton(
                        context,
                        "Nhập dữ liệu",
                        Icons.edit,
                        const HealthInputScreen(),
                      ),

                      quickButton(
                        context,
                        "Lịch sử",
                        Icons.history,
                        const HistoryScreen(),
                      ),

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
          ),
        ),
      ),
    );
  }
}