import 'package:flutter/material.dart';
import 'result_screen.dart';

class HealthInputScreen extends StatefulWidget {
  const HealthInputScreen({super.key});

  @override
  State<HealthInputScreen> createState() => _HealthInputScreenState();
}

class _HealthInputScreenState extends State<HealthInputScreen> {
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final heartRateController = TextEditingController();
  final bloodSugarController = TextEditingController();
  final cholesterolController = TextEditingController(); // 🆕 mỡ máu

  void handleSubmit() {
    try {
      double weight =
          double.tryParse(weightController.text.replaceAll(',', '.')) ?? 0;

      double height =
          double.tryParse(heightController.text.replaceAll(',', '.')) ?? 0;

      if (weight == 0 || height == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng nhập đầy đủ dữ liệu!")),
        );
        return;
      }

      double bmi = weight / (height * height);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            bmi: bmi,
            weight: weight,
            height: height * 100, // hiển thị cm
            systolic: systolicController.text,
            diastolic: diastolicController.text,
            heartRate: heartRateController.text,
            bloodSugar: bloodSugarController.text,
            cholesterol: cholesterolController.text, // 🆕
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi dữ liệu nhập!")),
      );
    }
  }

  Widget buildInput({
    required TextEditingController controller,
    required String label,
    required String unit,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhập sức khỏe"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🧍 Cơ bản
            buildInput(
              controller: weightController,
              label: "Cân nặng",
              unit: "kg",
              icon: Icons.monitor_weight,
            ),

            buildInput(
              controller: heightController,
              label: "Chiều cao",
              unit: "m",
              icon: Icons.height,
            ),

            /// ❤️ Huyết áp
            buildInput(
              controller: systolicController,
              label: "Huyết áp tâm thu",
              unit: "mmHg",
              icon: Icons.favorite,
            ),

            buildInput(
              controller: diastolicController,
              label: "Huyết áp tâm trương",
              unit: "mmHg",
              icon: Icons.favorite_border,
            ),

            /// 💓 Nhịp tim
            buildInput(
              controller: heartRateController,
              label: "Nhịp tim",
              unit: "bpm",
              icon: Icons.favorite,
            ),

            /// 🍬 Đường huyết
            buildInput(
              controller: bloodSugarController,
              label: "Đường huyết",
              unit: "mmol/L",
              icon: Icons.bloodtype,
            ),

            /// 🧈 Mỡ máu
            buildInput(
              controller: cholesterolController,
              label: "Mỡ máu",
              unit: "mmol/L",
              icon: Icons.opacity,
            ),

            const SizedBox(height: 20),

            /// 🔥 BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                ),
                child: const Text(
                  "Lấy kết quả",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}