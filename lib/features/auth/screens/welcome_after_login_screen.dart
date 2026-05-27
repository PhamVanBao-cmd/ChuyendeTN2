import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../dashboard/screens/dashboard_screen.dart';

class WelcomeAfterLoginScreen
    extends StatefulWidget {

  const WelcomeAfterLoginScreen({
    super.key,
  });

  @override
  State<WelcomeAfterLoginScreen>
  createState() =>
      _WelcomeAfterLoginScreenState();
}

class _WelcomeAfterLoginScreenState
    extends State<
        WelcomeAfterLoginScreen>
    with TickerProviderStateMixin {

  late AnimationController
  controller;

  late Animation<double> fade;

  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(
          vsync: this,

          duration:
          const Duration(
            seconds: 2,
          ),
        );

    fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);

    scale = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,

        curve:
        Curves.elasticOut,
      ),
    );

    controller.forward();

    Future.delayed(
      const Duration(seconds: 3),
          () {

        if (!mounted) return;

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder:
                (_) =>
            const DashboardScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
              Color(0xFF00C6FF),
            ],

            begin:
            Alignment.topLeft,

            end:
            Alignment.bottomRight,
          ),
        ),

        child: FadeTransition(
          opacity: fade,

          child: ScaleTransition(
            scale: scale,

            child: Center(

              child: Padding(
                padding:
                const EdgeInsets.all(24),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    /// ICON
                    Hero(
                      tag: "health_logo",

                      child: Container(
                        padding:
                        const EdgeInsets.all(30),

                        decoration:
                        BoxDecoration(
                          shape:
                          BoxShape.circle,

                          color: Colors.white
                              .withOpacity(
                            0.15,
                          ),

                          border: Border.all(
                            color:
                            Colors.white24,

                            width: 2,
                          ),
                        ),

                        child: const Icon(
                          Icons.favorite,
                          size: 95,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    /// SUCCESS TEXT
                    const Text(
                      "Đăng nhập thành công 🎉",

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        fontSize: 32,

                        fontWeight:
                        FontWeight.bold,

                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      user?.email ??
                          "Người dùng",

                      style:
                      const TextStyle(
                        color:
                        Colors.white70,

                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 35),

                    /// CARD
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),

                      decoration:
                      BoxDecoration(
                        color: Colors.white
                            .withOpacity(
                          0.12,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          24,
                        ),
                      ),

                      child: const Column(
                        children: [

                          SizedBox(
                            width: 30,
                            height: 30,

                            child:
                            CircularProgressIndicator(
                              color:
                              Colors.white,

                              strokeWidth:
                              3,
                            ),
                          ),

                          SizedBox(height: 18),

                          Text(
                            "Đang tải dữ liệu sức khỏe...",

                            style:
                            TextStyle(
                              color:
                              Colors.white,

                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Chuẩn bị trải nghiệm ứng dụng 💙",

                      style: TextStyle(
                        color:
                        Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}