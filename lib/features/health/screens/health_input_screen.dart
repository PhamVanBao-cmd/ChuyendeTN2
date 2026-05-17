import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../dashboard/screens/dashboard_screen.dart';
import 'result_screen.dart';

class HealthInputScreen extends StatefulWidget {
  const HealthInputScreen({super.key});

  @override
  State<HealthInputScreen> createState() => _HealthInputScreenState();
}

class _HealthInputScreenState extends State<HealthInputScreen> {

  final _formKey = GlobalKey<FormState>();

  final weight = TextEditingController();
  final height = TextEditingController();
  final sys = TextEditingController();
  final dia = TextEditingController();
  final hr = TextEditingController();
  final sugar = TextEditingController();
  final chol = TextEditingController();

  bool isLoading = false;

  /// ================= RESET =================
  void reset() {

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(
        builder: (_) => const HealthInputScreen(),
      ),
    );
  }

  /// ================= OCR =================
  Future<void> scanOCR() async {

    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: kIsWeb
          ? ImageSource.gallery
          : ImageSource.camera,
    );

    if (image == null) return;

    setState(() {
      isLoading = true;
    });

    if (kIsWeb) {
      await scanWebOCR(image);
    } else {
      await scanMobileOCR(image);
    }

    setState(() {
      isLoading = false;
    });
  }

  /// ================= MOBILE OCR =================
  Future<void> scanMobileOCR(XFile image) async {

    final inputImage =
    InputImage.fromFilePath(image.path);

    final recognizer = TextRecognizer();

    final result =
    await recognizer.processImage(inputImage);

    extract(result.text.toLowerCase());

    recognizer.close();
  }

  /// ================= WEB OCR =================
  Future<void> scanWebOCR(XFile image) async {

    final bytes = await image.readAsBytes();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://api.ocr.space/parse/image',
      ),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: "scan.png",
      ),
    );

    request.fields['apikey'] = 'helloworld';

    var res = await request.send();

    var body = await res.stream.bytesToString();

    final data = jsonDecode(body);

    String text =
        data['ParsedResults']?[0]?['ParsedText']
            ?.toLowerCase() ??
            "";

    extract(text);
  }

  /// ================= EXTRACT =================
  void extract(String text) {

    final numbers = RegExp(r'\d+')
        .allMatches(text)
        .map((e) => e.group(0)!)
        .toList();

    if (numbers.length < 5) return;

    weight.text = numbers[0];
    height.text = numbers[1];
    sys.text = numbers[2];
    dia.text = numbers[3];
    hr.text = numbers[4];

    if (numbers.length > 5) {
      sugar.text = numbers[5];
    }

    if (numbers.length > 6) {
      chol.text = numbers[6];
    }

    /// FIX HUYẾT ÁP
    if (int.parse(sys.text) <
        int.parse(dia.text)) {

      final t = sys.text;

      sys.text = dia.text;

      dia.text = t;
    }

    setState(() {});
  }

  /// ================= VALIDATE =================
  String? v(String? x, int min, int max) {

    if (x == null || x.isEmpty) {
      return "Nhập dữ liệu";
    }

    int? n = int.tryParse(x);

    if (n == null || n < min || n > max) {
      return "$min - $max";
    }

    return null;
  }

  /// ================= SUBMIT =================
  void submit() {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    double w = double.parse(weight.text);

    double h = double.parse(height.text);

    double bmi =
        w / ((h / 100) * (h / 100));

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

  /// ================= INPUT =================
  Widget input(
      String t,
      IconData i,
      TextEditingController c,
      int min,
      int max,
      ) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: TextFormField(

        controller: c,

        keyboardType: TextInputType.number,

        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],

        decoration: InputDecoration(

          prefixIcon: Icon(
            i,
            color: Colors.deepPurple,
          ),

          labelText: t,

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
        ),

        validator: (v) =>
            this.v(v, min, max),
      ),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F7FC),

      /// ================= APPBAR =================
      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        leading: IconButton(

          icon: const Icon(
            Icons.home,
            color: Colors.black,
          ),

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
        ),

        title: const Text(
          "Health Input",
          style: TextStyle(
            color: Colors.black,
          ),
        ),

        actions: [

          IconButton(

            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),

            onPressed: reset,
          ),
        ],
      ),

      /// ================= BODY =================
      body: Stack(

        children: [

          Center(

            child: SingleChildScrollView(

              child: ConstrainedBox(

                constraints: const BoxConstraints(
                  maxWidth: 430,
                ),

                child: Card(

                  margin:
                  const EdgeInsets.all(16),

                  elevation: 10,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(28),
                  ),

                  child: Padding(

                    padding:
                    const EdgeInsets.all(22),

                    child: Form(

                      key: _formKey,

                      child: Column(

                        mainAxisSize:
                        MainAxisSize.min,

                        children: [

                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 70,
                          ),

                          const SizedBox(height: 10),

                          const Text(

                            "Health Check",

                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Theo dõi sức khỏe thông minh",
                          ),

                          const SizedBox(height: 20),

                          /// OCR BUTTON
                          SizedBox(

                            width: double.infinity,

                            height: 52,

                            child: ElevatedButton.icon(

                              onPressed: scanOCR,

                              icon: const Icon(
                                Icons.camera_alt,
                              ),

                              label: const Text(
                                "Scan ảnh OCR",
                              ),

                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.deepPurple,

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      16),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          input(
                            "Cân nặng (kg)",
                            Icons.monitor_weight,
                            weight,
                            30,
                            250,
                          ),

                          input(
                            "Chiều cao (cm)",
                            Icons.height,
                            height,
                            120,
                            220,
                          ),

                          input(
                            "Tâm thu",
                            Icons.favorite,
                            sys,
                            70,
                            200,
                          ),

                          input(
                            "Tâm trương",
                            Icons.favorite_border,
                            dia,
                            40,
                            130,
                          ),

                          input(
                            "Nhịp tim",
                            Icons.monitor_heart,
                            hr,
                            40,
                            180,
                          ),

                          input(
                            "Đường huyết",
                            Icons.bloodtype,
                            sugar,
                            60,
                            300,
                          ),

                          input(
                            "Cholesterol",
                            Icons.opacity,
                            chol,
                            100,
                            400,
                          ),

                          const SizedBox(height: 25),

                          SizedBox(

                            width: double.infinity,

                            height: 55,

                            child: ElevatedButton(

                              onPressed: submit,

                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.green,

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      18),
                                ),
                              ),

                              child: const Text(
                                "Xem kết quả",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
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

          /// ================= LOADING =================
          if (isLoading)

            Container(

              color: Colors.black38,

              child: const Center(
                child:
                CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}