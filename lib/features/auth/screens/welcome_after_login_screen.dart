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

  late AnimationController controller;

  late Animation<double> fade;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);

    scale = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    controller.forward();

    Future.delayed(const Duration(seconds: 3), () {

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: FadeTransition(

          opacity: fade,

          child: ScaleTransition(

            scale: scale,

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Container(
                  padding: const EdgeInsets.all(28),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.favorite,
                    size: 90,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Đăng nhập thành công 🎉",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  user?.email ?? "",

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),

                      SizedBox(width: 15),

                      Text(
                        "Đang tải dữ liệu...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}