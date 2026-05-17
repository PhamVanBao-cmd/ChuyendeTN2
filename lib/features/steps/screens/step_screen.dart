import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {

  StreamSubscription<StepCount>? stepStream;

  int steps = 0;

  int goal = 10000;

  String status = "Đang tải...";

  /// ================= PERMISSION =================
  Future<void> requestPermission() async {

    final result =
    await Permission.activityRecognition.request();

    if (result.isGranted) {
      startListening();
    } else {
      setState(() {
        status = "Không có quyền truy cập";
      });
    }
  }

  /// ================= START =================
  void startListening() {

    stepStream =
        Pedometer.stepCountStream.listen(

              (StepCount event) {

            setState(() {
              steps = event.steps;
              status = "Đang theo dõi";
            });
          },

          onError: (e) {
            setState(() {
              status = "Thiết bị không hỗ trợ";
            });
          },
        );
  }

  /// ================= PROGRESS =================
  double get progress {

    if (steps >= goal) return 1;

    return steps / goal;
  }

  /// ================= CALORIES =================
  double get calories {
    return steps * 0.04;
  }

  /// ================= DISTANCE =================
  double get distance {
    return steps * 0.0008;
  }

  @override
  void initState() {
    super.initState();

    requestPermission();
  }

  @override
  void dispose() {

    stepStream?.cancel();

    super.dispose();
  }

  /// ================= INFO CARD =================
  Widget infoCard(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {

    return Expanded(
      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(25),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),

        child: Column(
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor:
              color.withOpacity(0.15),

              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              value,

              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,

              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,

        title: const Text(
          "Theo dõi bước chân",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4facfe),
                    Color(0xFF00f2fe),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(30),
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.directions_walk,
                    color: Colors.white,
                    size: 60,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "$steps",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    "Bước hôm nay",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor:
                      Colors.white30,

                      valueColor:
                      const AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "$steps / $goal bước",

                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= STATUS =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(22),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  ),
                ],
              ),

              child: Row(
                children: [

                  const Icon(
                    Icons.health_and_safety,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      status,

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= STATS =================
            Row(
              children: [

                infoCard(
                  Icons.local_fire_department,
                  "Calories",
                  calories.toStringAsFixed(0),
                  Colors.orange,
                ),

                const SizedBox(width: 15),

                infoCard(
                  Icons.route,
                  "Km",
                  distance.toStringAsFixed(2),
                  Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// ================= TIPS =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(25),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  ),
                ],
              ),

              child: const Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Icon(
                        Icons.tips_and_updates,
                        color: Colors.orange,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Lợi ích đi bộ",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  Text(
                    "• Cải thiện tim mạch",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "• Đốt cháy calories",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "• Giảm stress và ngủ ngon hơn",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "• Tăng cường sức khỏe tổng thể",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}