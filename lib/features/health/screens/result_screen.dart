import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'history_screen.dart';

class ResultScreen extends StatefulWidget {
  final double bmi;
  final double weight;
  final double height;
  final String systolic;
  final String diastolic;
  final String heartRate;
  final String bloodSugar;
  final String cholesterol; // 🆕

  const ResultScreen({
    super.key,
    required this.bmi,
    required this.weight,
    required this.height,
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    required this.bloodSugar,
    required this.cholesterol, // 🆕
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override
  void initState() {
    super.initState();
    saveData();
  }

  /// 🔥 Lưu Firebase
  Future<void> saveData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance.collection('health').add({
      'userId': user.uid, // 🔥 BẮT BUỘC
      'bmi': widget.bmi,
      'weight': widget.weight,
      'height': widget.height,
      'systolic': widget.systolic,
      'diastolic': widget.diastolic,
      'heartRate': widget.heartRate,
      'bloodSugar': widget.bloodSugar,
      'cholesterol': widget.cholesterol,
      'time': Timestamp.now(), // 🔥 dùng time
    });
  }

  /// 📊 BMI
  String getBMI() {
    if (widget.bmi < 18.5) return "Thiếu cân 🔵";
    if (widget.bmi < 25) return "Bình thường 🟢";
    if (widget.bmi < 30) return "Thừa cân 🟠";
    return "Béo phì 🔴";
  }

  Color getBMIColor() {
    if (widget.bmi < 18.5) return Colors.blue;
    if (widget.bmi < 25) return Colors.green;
    if (widget.bmi < 30) return Colors.orange;
    return Colors.red;
  }

  /// ❤️ Huyết áp
  String getBP() {
    int sys = int.tryParse(widget.systolic) ?? 0;
    int dia = int.tryParse(widget.diastolic) ?? 0;

    if (sys >= 140 || dia >= 90) return "Cao 🔴";
    if (sys < 90 || dia < 60) return "Thấp 🔵";
    return "Bình thường 🟢";
  }

  /// 💓 Nhịp tim
  String getHeart() {
    int hr = int.tryParse(widget.heartRate) ?? 0;

    if (hr > 100) return "Nhanh 🔴";
    if (hr < 60) return "Chậm 🔵";
    return "Bình thường 🟢";
  }

  /// 🍬 Đường huyết
  String getSugar() {
    double s = double.tryParse(widget.bloodSugar) ?? 0;

    if (s > 7) return "Cao 🔴";
    if (s < 4) return "Thấp 🔵";
    return "Bình thường 🟢";
  }

  /// 🧈 Mỡ máu
  String getChol() {
    double c = double.tryParse(widget.cholesterol) ?? 0;

    if (c > 6.2) return "Cao 🔴";
    if (c < 3.9) return "Thấp 🔵";
    return "Bình thường 🟢";
  }

  /// 🎨 UI row
  Widget buildRow(String title, String value, String status) {
    Color color = Colors.black;

    if (status.contains("🔴")) color = Colors.red;
    if (status.contains("🟢")) color = Colors.green;
    if (status.contains("🔵")) color = Colors.blue;
    if (status.contains("🟠")) color = Colors.orange;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: $value"),
          Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bp = getBP();
    final hr = getHeart();
    final sugar = getSugar();
    final chol = getChol();

    return Scaffold(
      appBar: AppBar(title: const Text("Kết quả sức khỏe")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 📊 BMI nổi bật
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: getBMIColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "BMI: ${widget.bmi.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: getBMIColor(),
                    ),
                  ),
                  Text(getBMI()),
                ],
              ),
            ),

            const SizedBox(height: 20),

            buildRow("Cân nặng", "${widget.weight} kg", ""),
            buildRow("Chiều cao", "${widget.height} cm", ""),

            buildRow(
              "Huyết áp",
              "${widget.systolic}/${widget.diastolic} mmHg",
              bp,
            ),

            buildRow(
              "Nhịp tim",
              "${widget.heartRate} bpm",
              hr,
            ),

            buildRow(
              "Đường huyết",
              "${widget.bloodSugar} mmol/L",
              sugar,
            ),

            buildRow(
              "Mỡ máu",
              "${widget.cholesterol} mmol/L",
              chol,
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