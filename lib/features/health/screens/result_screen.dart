import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'history_screen.dart';

class ResultScreen extends StatefulWidget {
  final double weight;
  final double height;
  final String systolic;
  final String diastolic;
  final String heartRate;
  final String bloodSugar;
  final String cholesterol;

  const ResultScreen({
    super.key,
    required this.weight,
    required this.height,
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    required this.bloodSugar,
    required this.cholesterol,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  double bmi = 0;

  @override
  void initState() {
    super.initState();
    calculateBMI();
    saveData();
  }

  void calculateBMI() {
    double h = widget.height / 100;
    bmi = widget.weight / (h * h);
  }

  Future<void> saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('health')
        .add({
      'bmi': bmi,
      'weight': widget.weight,
      'height': widget.height,
      'systolic': widget.systolic,
      'diastolic': widget.diastolic,
      'heartRate': widget.heartRate,
      'bloodSugar': widget.bloodSugar,
      'cholesterol': widget.cholesterol,
      'createdAt': Timestamp.now(),
    });
  }

  String getBMI() {
    if (bmi < 18.5) return "Thiếu cân 🔵";
    if (bmi < 25) return "Bình thường 🟢";
    if (bmi < 30) return "Thừa cân 🟠";
    return "Béo phì 🔴";
  }

  String getSugar() {
    double s = double.tryParse(widget.bloodSugar) ?? 0;
    if (s >= 126) return "Cao 🔴";
    if (s < 70) return "Thấp 🔵";
    return "Bình thường 🟢";
  }

  String getChol() {
    double c = double.tryParse(widget.cholesterol) ?? 0;
    if (c >= 240) return "Rất cao 🔴";
    if (c >= 200) return "Cao 🟠";
    return "Bình thường 🟢";
  }

  String generateReport() {
    List<String> warn = [];

    if (bmi >= 30) warn.add("⚠️ Béo phì");
    if ((int.tryParse(widget.systolic) ?? 0) >= 140) warn.add("⚠️ Huyết áp cao");
    if ((int.tryParse(widget.heartRate) ?? 0) > 100) warn.add("⚠️ Tim nhanh");
    if ((double.tryParse(widget.bloodSugar) ?? 0) >= 126) warn.add("⚠️ Tiểu đường");
    if ((double.tryParse(widget.cholesterol) ?? 0) >= 240) warn.add("⚠️ Cholesterol cao");

    if (warn.isEmpty) return "✅ Sức khỏe tốt";
    if (warn.length >= 3) return "🚨 NGUY HIỂM\n\n${warn.join("\n")}";

    return warn.join("\n");
  }

  Widget row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(t), Text(v)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kết quả")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Text("BMI: ${bmi.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 26)),
            Text(getBMI()),

            const SizedBox(height: 20),

            row("Cân nặng", "${widget.weight} kg"),
            row("Chiều cao", "${widget.height} cm"),
            row("Đường huyết", getSugar()),
            row("Cholesterol", getChol()),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.yellow.shade100,
              child: Text(generateReport()),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryScreen(),
                  ),
                );
              },
              child: const Text("Xem lịch sử"),
            )
          ],
        ),
      ),
    );
  }
}