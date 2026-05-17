import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../dashboard/screens/dashboard_screen.dart';
import 'history_screen.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final double weight;
  final double height;
  final String systolic;
  final String diastolic;
  final String heartRate;
  final String bloodSugar;
  final String cholesterol;

  const ResultScreen({
    super.key,
    required this.bmi,
    required this.weight,
    required this.height,
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    required this.bloodSugar,
    required this.cholesterol,
  });

  /// ================= SAVE =================
  Future<void> saveData(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('health')
        .add({
      'bmi': bmi,
      'weight': weight,
      'height': height,
      'systolic': int.tryParse(systolic) ?? 0,
      'diastolic': int.tryParse(diastolic) ?? 0,
      'heartRate': int.tryParse(heartRate) ?? 0,
      'bloodSugar': double.tryParse(bloodSugar) ?? 0,
      'cholesterol': double.tryParse(cholesterol) ?? 0,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã lưu dữ liệu"),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HistoryScreen(),
      ),
          (route) => false,
    );
  }

  /// ================= BMI STATUS =================
  String getStatus() {
    if (bmi < 18.5) return "Thiếu cân";
    if (bmi < 25) return "Bình thường";
    if (bmi < 30) return "Thừa cân";
    return "Béo phì";
  }

  Color getColor() {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String getAdvice() {
    if (bmi < 18.5) {
      return "Bạn nên bổ sung dinh dưỡng và ngủ đủ giấc.";
    }

    if (bmi < 25) {
      return "Cơ thể của bạn đang ở trạng thái tốt.";
    }

    if (bmi < 30) {
      return "Bạn nên tập cardio và giảm tinh bột.";
    }

    return "Hãy kiểm soát chế độ ăn và tập luyện thường xuyên.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF4F7FC),

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.transparent,

        title: const Text(
          "Kết quả sức khỏe",
          style: TextStyle(color: Colors.black),
        ),

        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const DashboardScreen(),
              ),
                  (route) => false,
            );
          },
        ),
      ),

      body: Center(

        child: SingleChildScrollView(

          child: ConstrainedBox(

            constraints: const BoxConstraints(
              maxWidth: 430,
            ),

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                children: [

                  /// ================= TOP CARD =================
                  Container(

                    width: double.infinity,

                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(

                      gradient: LinearGradient(
                        colors: [
                          getColor().withOpacity(0.8),
                          getColor(),
                        ],
                      ),

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Column(

                      children: [

                        SizedBox(
                          width: 260,
                          height: 170,
                          child: CustomPaint(
                            painter: BMIPainter(bmi),
                          ),
                        ),

                        Text(
                          bmi.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            getStatus(),
                            style: TextStyle(
                              color: getColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= AI ADVICE =================
                  Container(

                    width: double.infinity,

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                        ),
                      ],
                    ),

                    child: Row(

                      children: [

                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                          getColor().withOpacity(0.15),
                          child: Icon(
                            Icons.favorite,
                            color: getColor(),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              const Text(
                                "Phân tích sức khỏe",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(getAdvice()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= DATA =================
                  infoCard(
                    "Cân nặng",
                    "${weight.toStringAsFixed(1)} kg",
                    Icons.monitor_weight,
                    Colors.orange,
                  ),

                  infoCard(
                    "Chiều cao",
                    "${height.toStringAsFixed(0)} cm",
                    Icons.height,
                    Colors.blue,
                  ),

                  infoCard(
                    "Huyết áp",
                    "$systolic/$diastolic mmHg",
                    Icons.favorite,
                    Colors.red,
                  ),

                  infoCard(
                    "Nhịp tim",
                    "$heartRate bpm",
                    Icons.monitor_heart,
                    Colors.pink,
                  ),

                  infoCard(
                    "Đường huyết",
                    "$bloodSugar mg/dL",
                    Icons.bloodtype,
                    Colors.green,
                  ),

                  infoCard(
                    "Cholesterol",
                    "$cholesterol mg/dL",
                    Icons.opacity,
                    Colors.purple,
                  ),

                  const SizedBox(height: 25),

                  /// ================= BUTTON =================
                  Row(

                    children: [

                      Expanded(
                        child: ElevatedButton.icon(

                          onPressed: () {

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const DashboardScreen(),
                              ),
                                  (route) => false,
                            );
                          },

                          icon: const Icon(Icons.home),

                          label: const Text("Dashboard"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton.icon(

                          onPressed: () => saveData(context),

                          icon: const Icon(Icons.save),

                          label: const Text("Lưu"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                          ),
                        ),
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

  /// ================= INFO CARD =================
  Widget infoCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(

      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),

      child: Row(

        children: [

          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= BMI PAINTER =================
class BMIPainter extends CustomPainter {
  final double bmi;

  BMIPainter(this.bmi);

  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(
      size.width / 2,
      size.height,
    );

    final radius = size.width / 2 - 18;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    double start = pi;

    final segments = [
      {"max": 18.5, "color": Colors.blue},
      {"max": 25.0, "color": Colors.green},
      {"max": 30.0, "color": Colors.orange},
      {"max": 40.0, "color": Colors.red},
    ];

    double total = 40;
    double current = start;

    for (var s in segments) {

      double sweep =
          ((s["max"] as double) / total) * pi;

      paint.color = s["color"] as Color;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        current,
        sweep,
        false,
        paint,
      );

      current += sweep;
    }

    /// NEEDLE
    double angle =
        start + (bmi / total) * pi;

    final needle = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final end = Offset(
      center.dx +
          (radius - 25) * cos(angle),
      center.dy +
          (radius - 25) * sin(angle),
    );

    canvas.drawLine(
      center,
      end,
      needle,
    );

    canvas.drawCircle(
      center,
      8,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}