import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'health_input_screen.dart';
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

  /// ================= SAVE + GO HISTORY =================
  Future<void> saveData(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Chưa đăng nhập")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('health')
          .add({
        'bmi': bmi,
        'weight': weight,
        'height': height,

        /// 🔥 CHUYỂN SANG SỐ (QUAN TRỌNG)
        'systolic': int.tryParse(systolic) ?? 0,
        'diastolic': int.tryParse(diastolic) ?? 0,
        'heartRate': int.tryParse(heartRate) ?? 0,
        'bloodSugar': double.tryParse(bloodSugar) ?? 0,
        'cholesterol': double.tryParse(cholesterol) ?? 0,

        'createdAt': Timestamp.now(),
      });

      /// ✅ CHUYỂN SANG HISTORY (ĐÚNG FLOW)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HistoryScreen(),
        ),
            (route) => false,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Lỗi lưu: $e")),
      );
    }
  }

  /// ================= BMI =================
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

  /// ================= CARD =================
  Widget card(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// 🔙 BACK
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      extendBodyBehindAppBar: true,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// 🔥 BMI CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: getColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "BMI ${bmi.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: getColor(),
                        ),
                      ),
                      Text(
                        getStatus(),
                        style: TextStyle(color: getColor()),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 DATA
                card("Cân nặng", weight.toString(), "kg"),
                card("Chiều cao", height.toString(), "cm"),
                card("Huyết áp", "$systolic/$diastolic", "mmHg"),
                card("Nhịp tim", heartRate, "bpm"),
                card("Đường huyết", bloodSugar, "mg/dL"),
                card("Cholesterol", cholesterol, "mg/dL"),

                const Spacer(),

                /// 🔥 BUTTONS
                Row(
                  children: [

                    /// 🏠 HOME
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HealthInputScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        icon: const Icon(Icons.home),
                        label: const Text("Trang chủ"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// 💾 SAVE
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => saveData(context),
                        icon: const Icon(Icons.save),
                        label: const Text("Lưu"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
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
    );
  }
}