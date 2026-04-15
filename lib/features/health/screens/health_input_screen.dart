import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'result_screen.dart';

class HealthInputScreen extends StatefulWidget {
  const HealthInputScreen({super.key});

  @override
  State<HealthInputScreen> createState() => _HealthInputScreenState();
}

class _HealthInputScreenState extends State<HealthInputScreen>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final weight = TextEditingController();
  final height = TextEditingController();
  final sys = TextEditingController();
  final dia = TextEditingController();
  final hr = TextEditingController();
  final sugar = TextEditingController();
  final chol = TextEditingController();

  bool isLoading = false;

  late AnimationController _anim;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  /// ================= RESET (LOAD LẠI TRANG) =================
  void reset() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HealthInputScreen(),
      ),
    );
  }

  /// SCAN
  Future<void> scanOCR() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: kIsWeb ? ImageSource.gallery : ImageSource.camera,
    );

    if (image == null) return;

    setState(() => isLoading = true);

    if (kIsWeb) {
      await scanWebOCR(image);
    } else {
      await scanMobileOCR(image);
    }

    setState(() => isLoading = false);
  }

  /// MOBILE OCR
  Future<void> scanMobileOCR(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final recognizer = TextRecognizer();

    final result = await recognizer.processImage(inputImage);
    extract(result.text.toLowerCase());

    recognizer.close();
  }

  /// WEB OCR
  Future<void> scanWebOCR(XFile image) async {
    final bytes = await image.readAsBytes();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.ocr.space/parse/image'),
    );

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: "scan.png",
    ));

    request.fields['apikey'] = 'helloworld';

    var res = await request.send();
    var body = await res.stream.bytesToString();

    final data = jsonDecode(body);
    String text =
        data['ParsedResults']?[0]?['ParsedText']?.toLowerCase() ?? "";

    extract(text);
  }

  /// EXTRACT NUMBER
  void extract(String text) {
    final numbers =
    RegExp(r'\d+').allMatches(text).map((e) => e.group(0)!).toList();

    if (numbers.length < 5) return;

    weight.text = numbers[0];
    height.text = numbers[1];
    sys.text = numbers[2];
    dia.text = numbers[3];
    hr.text = numbers[4];
    sugar.text = numbers[5];

    if (numbers.length > 6) {
      chol.text = numbers[6];
    }

    /// FIX huyết áp
    if (int.parse(sys.text) < int.parse(dia.text)) {
      final t = sys.text;
      sys.text = dia.text;
      dia.text = t;
    }

    setState(() {});
  }

  /// ================= VALIDATE =================
  String? v(String? x, int min, int max) {
    if (x == null || x.isEmpty) return "Nhập";
    int? n = int.tryParse(x);
    if (n == null || n < min || n > max) return "$min-$max";
    return null;
  }

  /// ================= SUBMIT =================
  void submit() {
    if (!_formKey.currentState!.validate()) return;

    double w = double.parse(weight.text);
    double h = double.parse(height.text);
    double bmi = w / ((h / 100) * (h / 100));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          bmi: bmi,
          weight: w,
          height: h,
          systolic: sys.text,
          diastolic: dia.text,
          heartRate: hr.text,
          bloodSugar: sugar.text,
          cholesterol: chol.text,
        ),
      ),
    );
  }

  Widget input(String t, IconData i, TextEditingController c, int min, int max) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          prefixIcon: Icon(i, color: Colors.deepPurple),
          labelText: t,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        validator: (v) => this.v(v, min, max),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// 🔥 APPBAR ICON
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: reset,
          ),
        ],
      ),

      extendBodyBehindAppBar: true,

      body: Stack(
        children: [

          /// BG
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
            ),
          ),

          /// FORM
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [

                          const Text("Health Check",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),

                          const SizedBox(height: 10),

                          ElevatedButton.icon(
                            onPressed: scanOCR,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Scan ảnh"),
                          ),

                          input("Cân nặng (kg)", Icons.monitor_weight, weight, 30, 250),
                          input("Chiều cao (cm)", Icons.height, height, 120, 220),
                          input("Tâm thu", Icons.favorite, sys, 70, 200),
                          input("Tâm trương", Icons.favorite_border, dia, 40, 130),
                          input("Nhịp tim", Icons.monitor_heart, hr, 40, 180),
                          input("Đường huyết (mg/dL)", Icons.bloodtype, sugar, 60, 300),
                          input("Cholesterol (mg/dL)", Icons.opacity, chol, 100, 400),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: submit,
                            child: const Text("Xem kết quả"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}