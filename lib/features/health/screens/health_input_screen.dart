import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'result_screen.dart';

class HealthInputScreen extends StatefulWidget {
  const HealthInputScreen({super.key});

  @override
  State<HealthInputScreen> createState() => _HealthInputScreenState();
}

class _HealthInputScreenState extends State<HealthInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final heartRateController = TextEditingController();
  final bloodSugarController = TextEditingController();
  final cholesterolController = TextEditingController();

  /// 🔥 CHẶN CHỈ NHẬP SỐ
  final numberOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));

  /// 🔥 VALIDATE CHUẨN Y KHOA
  String? validateRequired(String? v) {
    if (v == null || v.trim().isEmpty) return "Không được để trống";
    return null;
  }

  String? validateWeight(String? v) {
    if (validateRequired(v) != null) return validateRequired(v);

    double? w = double.tryParse(v!);
    if (w == null) return "Sai định dạng";

    if (w < 30 || w > 250) return "30–250 kg";
    return null;
  }

  String? validateHeight(String? v) {
    if (validateRequired(v) != null) return validateRequired(v);

    double? h = double.tryParse(v!);
    if (h == null) return "Sai định dạng";

    if (h < 120 || h > 220) return "120–220 cm";
    return null;
  }

  String? validateBP(String? v) {
    if (validateRequired(v) != null) return validateRequired(v);

    int? x = int.tryParse(v!);
    if (x == null) return "Sai định dạng";

    if (x < 70 || x > 200) return "70–200 mmHg";
    return null;
  }

  String? validateHeart(String? v) {
    if (validateRequired(v) != null) return validateRequired(v);

    int? hr = int.tryParse(v!);
    if (hr == null) return "Sai định dạng";

    if (hr < 40 || hr > 180) return "40–180 bpm";
    return null;
  }

  String? validateSugar(String? v) {
    if (validateRequired(v) != null) return validateRequired(v);

    double? s = double.tryParse(v!);
    if (s == null) return "Sai định dạng";

    if (s < 60 || s > 300) return "60–300 mg/dL";
    return null;
  }

  String? validateChol(String? v) {
    if (validateRequired(v) != null) return validateRequired(v);

    double? c = double.tryParse(v!);
    if (c == null) return "Sai định dạng";

    if (c < 100 || c > 400) return "100–400 mg/dL";
    return null;
  }

  Widget input(String label, TextEditingController c, String? Function(String?) v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [numberOnly], // 🔥 CHẶN CHỮ
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: v,
      ),
    );
  }

  /// 🚀 SUBMIT
  void submit() {
    FocusScope.of(context).unfocus();

    /// 🔥 validate toàn bộ form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Vui lòng nhập đúng dữ liệu")),
      );
      return;
    }

    /// ✅ chỉ khi đúng mới qua Result
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          weight: double.parse(weightController.text),
          height: double.parse(heightController.text),
          systolic: systolicController.text,
          diastolic: diastolicController.text,
          heartRate: heartRateController.text,
          bloodSugar: bloodSugarController.text,
          cholesterol: cholesterolController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhập sức khỏe")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              input("Cân nặng (kg)", weightController, validateWeight),
              input("Chiều cao (cm)", heightController, validateHeight),
              input("Huyết áp tâm thu", systolicController, validateBP),
              input("Huyết áp tâm trương", diastolicController, validateBP),
              input("Nhịp tim (bpm)", heartRateController, validateHeart),
              input("Đường huyết (mg/dL)", bloodSugarController, validateSugar),
              input("Cholesterol (mg/dL)", cholesterolController, validateChol),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: submit,
                child: const Text("Xem kết quả"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}