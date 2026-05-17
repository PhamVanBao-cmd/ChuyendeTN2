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
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),

                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      /// LOGO
                      Container(
                        padding: const EdgeInsets.all(28),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white24,
                            width: 2,
                          ),
                        ),

                        child: const Icon(
                          Icons.favorite,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Health App",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Theo dõi sức khỏe thông minh\nBMI • Calories • Huyết áp • Biểu đồ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 45),

                      /// CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                            ),
                          ],
                        ),

                        child: Column(
                          children: [

                            feature(
                              Icons.monitor_heart,
                              "Theo dõi sức khỏe",
                              "Đo BMI, nhịp tim, huyết áp",
                              Colors.red,
                            ),

                            const SizedBox(height: 18),

                            feature(
                              Icons.local_fire_department,
                              "Tính Calories",
                              "Đưa ra nhu cầu calories mỗi ngày",
                              Colors.orange,
                            ),

                            const SizedBox(height: 18),

                            feature(
                              Icons.show_chart,
                              "Biểu đồ & lịch sử",
                              "Xem tiến trình sức khỏe theo thời gian",
                              Colors.green,
                            ),

                            const SizedBox(height: 30),

                            SizedBox(
                              width: double.infinity,

                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(18),
                                  ),
                                ),

                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const LoginScreen(),
                                    ),
                                  );
                                },

                                child: const Text(
                                  "Bắt đầu",
                                  style: TextStyle(fontSize: 16),
                                ),
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
    return Row(
      children: [

        Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),

          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 4),

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
    );
  }
}