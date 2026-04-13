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
  final cholesterolController = TextEditingController();

  double bmi = 0;

  void calculateAndGo() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double heightCm = double.tryParse(heightController.text) ?? 0;

    /// 👉 đổi cm -> m
    double heightM = heightCm / 100;

    if (weight == 0 || heightM == 0) return;

    bmi = weight / (heightM * heightM);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          bmi: bmi,
          weight: weight,
          height: heightCm,
          systolic: systolicController.text,
          diastolic: diastolicController.text,
          heartRate: heartRateController.text,
          bloodSugar: bloodSugarController.text,
          cholesterol: cholesterolController.text,
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller,
      {String unit = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "$label $unit",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Nhập sức khỏe")),
      body: Center(
        child: Container(
          width: screenWidth > 600 ? 400 : double.infinity, // 🔥 fix web
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                  )
                ],
              ),
              child: Column(
                children: [

                  /// 📊 TITLE
                  const Text(
                    "Nhập thông tin sức khỏe",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  buildInput("Cân nặng", weightController, unit: "(kg)"),
                  buildInput("Chiều cao", heightController, unit: "(cm)"),

                  buildInput("Huyết áp tâm thu", systolicController, unit: "(mmHg)"),
                  buildInput("Huyết áp tâm trương", diastolicController, unit: "(mmHg)"),

                  buildInput("Nhịp tim", heartRateController, unit: "(bpm)"),

                  buildInput("Đường huyết", bloodSugarController, unit: "(mmol/L)"),

                  buildInput("Mỡ máu", cholesterolController, unit: "(mmol/L)"),

                  const SizedBox(height: 20),

                  /// 🚀 BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: calculateAndGo,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Lấy kết quả"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}