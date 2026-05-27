import 'package:flutter/material.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
              Color(0xFF00C6FF),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22),

                child: Column(
                  children: [

                    /// ================= LOGO =================
                    TweenAnimationBuilder(
                      tween: Tween<double>(
                        begin: 0.8,
                        end: 1,
                      ),

                      duration: const Duration(
                        milliseconds: 1200,
                      ),

                      curve: Curves.elasticOut,

                      builder: (context, value, child) {

                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },

                      child: Container(
                        padding: const EdgeInsets.all(28),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          color: Colors.white.withOpacity(0.15),

                          border: Border.all(
                            color: Colors.white24,
                            width: 2,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),

                        child: const Icon(
                          Icons.favorite,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    /// ================= TITLE =================
                    const Text(
                      "Health Care+",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Ứng dụng theo dõi sức khỏe thông minh\nBước chân • Giấc ngủ • Nước uống • BMI",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 45),

                    /// ================= MAIN CARD =================
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(32),

                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [

                          feature(
                            Icons.directions_walk,
                            "Theo dõi bước chân",
                            "Đếm bước, calories & khoảng cách",
                            Colors.blue,
                          ),

                          const SizedBox(height: 18),

                          feature(
                            Icons.water_drop,
                            "Theo dõi nước uống",
                            "Nhắc uống nước thông minh",
                            Colors.cyan,
                          ),

                          const SizedBox(height: 18),

                          feature(
                            Icons.nightlight_round,
                            "Theo dõi giấc ngủ",
                            "Phân tích chất lượng giấc ngủ",
                            Colors.deepPurple,
                          ),

                          const SizedBox(height: 18),

                          feature(
                            Icons.favorite,
                            "Chỉ số sức khỏe",
                            "BMI & đánh giá cơ thể",
                            Colors.red,
                          ),

                          const SizedBox(height: 35),

                          /// BUTTON
                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              onPressed: () {

                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const LoginScreen(),
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF2575FC),

                                foregroundColor:
                                Colors.white,

                                elevation: 8,

                                padding:
                                const EdgeInsets.symmetric(
                                  vertical: 17,
                                ),

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              ),

                              child: const Text(
                                "Bắt đầu ngay",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// FOOTER
                    const Text(
                      "Sống khỏe hơn mỗi ngày 💙",
                      style: TextStyle(
                        color: Colors.white70,
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

  Widget feature(
      IconData icon,
      String title,
      String subtitle,
      Color color,
      ) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: color.withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(22),
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),

              borderRadius:
              BorderRadius.circular(18),
            ),

            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,

                  style: const TextStyle(
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}