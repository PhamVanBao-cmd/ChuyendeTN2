import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../dashboard/screens/dashboard_screen.dart';

class WelcomeAfterLoginScreen extends StatefulWidget {
  const WelcomeAfterLoginScreen({super.key});

  @override
  State<WelcomeAfterLoginScreen> createState() =>
      _WelcomeAfterLoginScreenState();
}

class _WelcomeAfterLoginScreenState
    extends State<WelcomeAfterLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  bool isNewUser(User user) {
    final created = user.metadata.creationTime;
    final lastLogin = user.metadata.lastSignInTime;

    if (created == null || lastLogin == null) return false;

    return created.difference(lastLogin).inSeconds.abs() < 5;
  }

  @override
  void initState() {
    super.initState();

    /// 🎬 animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _scale = Tween(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    /// ⏱ auto chuyển màn
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Không có user")),
      );
    }

    final newUser = isNewUser(user);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4facfe), Color(0xff43e97b)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// 💓 ICON (giống Google Fit)
                TweenAnimationBuilder(
                  tween: Tween(begin: 0.9, end: 1.1),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value as double,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 80,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// 👋 TEXT
                Text(
                  newUser
                      ? "Chào mừng bạn 🎉"
                      : "Chào mừng quay lại 👋",
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  user.displayName?.isNotEmpty == true
                      ? user.displayName!
                      : user.email ?? "",
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 40),

                /// 🚀 BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DashboardScreen(),
                      ),
                    );
                  },
                  child: const Text("Bắt đầu đo"),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Đang chuẩn bị dữ liệu...",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}