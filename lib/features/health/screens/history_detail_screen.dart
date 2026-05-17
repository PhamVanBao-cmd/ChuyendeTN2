import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const HistoryDetailScreen({
    super.key,
    required this.data,
  });

  /// ================= DATA =================
  double get bmi => (data['bmi'] ?? 0).toDouble();

  int get systolic => data['systolic'] ?? 0;

  int get diastolic => data['diastolic'] ?? 0;

  int get heartRate => data['heartRate'] ?? 0;

  double get sugar =>
      double.tryParse(data['bloodSugar'].toString()) ?? 0;

  double get chol =>
      double.tryParse(data['cholesterol'].toString()) ?? 0;

  /// ================= TOTAL SCORE =================
  int calculateScore() {
    int score = 100;

    if (bmi > 25) score -= 10;
    if (bmi > 30) score -= 15;

    if (systolic > 140) score -= 15;

    if (heartRate > 100) score -= 10;

    if (sugar > 140) score -= 10;

    if (chol > 240) score -= 10;

    return score.clamp(0, 100);
  }

  /// ================= HEALTH TEXT =================
  String healthText(int s) {
    if (s >= 85) return "Sức khỏe rất tốt";
    if (s >= 70) return "Sức khỏe ổn định";
    if (s >= 50) return "Cần cải thiện";
    return "Cảnh báo sức khỏe";
  }

  /// ================= SCORE COLOR =================
  Color scoreColor(int s) {
    if (s >= 85) return Colors.green;
    if (s >= 70) return Colors.orange;
    return Colors.red;
  }

  /// ================= RISK LEVEL =================
  String riskLevel() {
    final score = calculateScore();

    if (score >= 85) {
      return "Nguy cơ thấp";
    }

    if (score >= 60) {
      return "Nguy cơ trung bình";
    }

    return "Nguy cơ cao";
  }

  /// ================= BMI =================
  String bmiStatus() {
    if (bmi < 18.5) return "Thiếu cân";
    if (bmi < 25) return "Bình thường";
    if (bmi < 30) return "Thừa cân";
    return "Béo phì";
  }

  Color bmiColor() {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  /// ================= BLOOD PRESSURE =================
  String bloodPressureStatus() {
    if (systolic < 120 && diastolic < 80) {
      return "Ổn định";
    }

    if (systolic < 140) {
      return "Hơi cao";
    }

    return "Cao";
  }

  Color bloodPressureColor() {
    if (systolic < 120) return Colors.green;
    if (systolic < 140) return Colors.orange;
    return Colors.red;
  }

  /// ================= HEART =================
  String heartStatus() {
    if (heartRate < 60) return "Hơi thấp";

    if (heartRate <= 100) {
      return "Bình thường";
    }

    return "Nhanh";
  }

  Color heartColor() {
    if (heartRate <= 100) return Colors.green;
    return Colors.red;
  }

  /// ================= SUGAR =================
  String sugarStatus() {
    if (sugar < 140) return "Ổn định";

    if (sugar < 200) {
      return "Cao";
    }

    return "Nguy hiểm";
  }

  Color sugarColor() {
    if (sugar < 140) return Colors.green;

    if (sugar < 200) {
      return Colors.orange;
    }

    return Colors.red;
  }

  /// ================= CHOLESTEROL =================
  String cholStatus() {
    if (chol < 200) return "Tốt";

    if (chol < 240) {
      return "Hơi cao";
    }

    return "Cao";
  }

  Color cholColor() {
    if (chol < 200) return Colors.green;

    if (chol < 240) {
      return Colors.orange;
    }

    return Colors.red;
  }

  /// ================= BMI SCORE =================
  int bmiScore() {
    if (bmi >= 18.5 && bmi <= 24.9) return 100;

    if (bmi < 18.5) {
      return 75;
    }

    if (bmi < 30) {
      return 60;
    }

    return 40;
  }

  /// ================= BLOOD PRESSURE SCORE =================
  int bloodPressureScore() {
    if (systolic < 120 && diastolic < 80) {
      return 100;
    }

    if (systolic < 140) {
      return 75;
    }

    return 45;
  }

  /// ================= HEART SCORE =================
  int heartScore() {
    if (heartRate >= 60 && heartRate <= 100) {
      return 100;
    }

    return 65;
  }

  /// ================= SUGAR SCORE =================
  int sugarScore() {
    if (sugar < 140) return 100;

    if (sugar < 200) {
      return 70;
    }

    return 40;
  }

  /// ================= CHOLESTEROL SCORE =================
  int cholScore() {
    if (chol < 200) return 100;

    if (chol < 240) {
      return 70;
    }

    return 45;
  }

  /// ================= ADVICE =================
  List<String> adviceList() {
    List<String> tips = [];

    if (bmi > 25) {
      tips.add("Giảm đồ ngọt và thức ăn dầu mỡ");
      tips.add("Đi bộ 30 phút mỗi ngày");
    }

    if (systolic > 130) {
      tips.add("Hạn chế muối và thức ăn nhanh");
    }

    if (heartRate > 100) {
      tips.add("Ngủ đủ giấc và giảm căng thẳng");
    }

    if (sugar > 140) {
      tips.add("Giảm nước ngọt và tinh bột");
    }

    if (chol > 200) {
      tips.add("Ăn nhiều rau xanh và cá");
    }

    if (tips.isEmpty) {
      tips.add("Tiếp tục duy trì lối sống lành mạnh");
      tips.add("Uống đủ nước mỗi ngày");
    }

    return tips;
  }

  @override
  Widget build(BuildContext context) {
    final score = calculateScore();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("Chi tiết sức khỏe"),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                /// ================= TOTAL SCORE =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scoreColor(score).withOpacity(0.7),
                        scoreColor(score),
                      ],
                    ),

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Column(
                    children: [

                      const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 45,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "$score",
                        style: const TextStyle(
                          fontSize: 55,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        healthText(score),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// ================= OVERVIEW =================
                overviewCard(score),

                const SizedBox(height: 25),

                /// ================= HEALTH SCORES =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Điểm các chỉ số",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      scoreItem(
                        "BMI",
                        bmiScore(),
                        bmiColor(),
                      ),

                      scoreItem(
                        "Huyết áp",
                        bloodPressureScore(),
                        bloodPressureColor(),
                      ),

                      scoreItem(
                        "Nhịp tim",
                        heartScore(),
                        heartColor(),
                      ),

                      scoreItem(
                        "Đường huyết",
                        sugarScore(),
                        sugarColor(),
                      ),

                      scoreItem(
                        "Cholesterol",
                        cholScore(),
                        cholColor(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// ================= STATUS =================
                healthStatus(
                  "BMI",
                  bmi.toStringAsFixed(1),
                  bmiStatus(),
                  bmiColor(),
                ),

                healthStatus(
                  "Huyết áp",
                  "$systolic/$diastolic mmHg",
                  bloodPressureStatus(),
                  bloodPressureColor(),
                ),

                healthStatus(
                  "Nhịp tim",
                  "$heartRate bpm",
                  heartStatus(),
                  heartColor(),
                ),

                healthStatus(
                  "Đường huyết",
                  "$sugar mg/dL",
                  sugarStatus(),
                  sugarColor(),
                ),

                healthStatus(
                  "Cholesterol",
                  "$chol mg/dL",
                  cholStatus(),
                  cholColor(),
                ),

                const SizedBox(height: 25),

                /// ================= ADVICE =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Row(
                        children: [

                          Icon(
                            Icons.tips_and_updates,
                            color: Colors.orange,
                          ),

                          SizedBox(width: 10),

                          Text(
                            "Lời khuyên sức khỏe",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      ...adviceList().map(
                            (e) => advice(e),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= OVERVIEW CARD =================
  Widget overviewCard(
      int score,
      ) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Tổng quan sức khỏe",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            healthText(score),

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: scoreColor(score),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            riskLevel(),

            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SCORE ITEM =================
  Widget scoreItem(
      String title,
      int score,
      Color color,
      ) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                title,

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              Text(
                "$score/100",

                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= STATUS CARD =================
  Widget healthStatus(
      String title,
      String value,
      String status,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                value,

                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),

            child: Text(
              status,

              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= ADVICE =================
  Widget advice(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [

          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}