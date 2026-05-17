import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'calorie_history_screen.dart';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  State<CalorieScreen> createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  String gender = "Nam";
  String activity = "Vận động nhẹ";

  double result = 0;

  /// ================= CALCULATE =================
  void calculateCalories() {

    double weight =
        double.tryParse(weightController.text) ?? 0;

    double height =
        double.tryParse(heightController.text) ?? 0;

    int age =
        int.tryParse(ageController.text) ?? 0;

    if (weight == 0 || height == 0 || age == 0) {
      return;
    }

    double bmr;

    /// BMR
    if (gender == "Nam") {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    /// ACTIVITY
    double activityFactor = 1.2;

    switch (activity) {

      case "Ít vận động":
        activityFactor = 1.2;
        break;

      case "Vận động nhẹ":
        activityFactor = 1.375;
        break;

      case "Vận động vừa":
        activityFactor = 1.55;
        break;

      case "Vận động nặng":
        activityFactor = 1.725;
        break;
    }

    setState(() {
      result = bmr * activityFactor;
    });
  }

  /// ================= SAVE =================
  Future<void> saveCalories() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    double weight =
        double.tryParse(weightController.text) ?? 0;

    double height =
        double.tryParse(heightController.text) ?? 0;

    int age =
        int.tryParse(ageController.text) ?? 0;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('calories')
        .add({

      'weight': weight,
      'height': height,
      'age': age,

      'gender': gender,
      'activity': activity,

      'calories': result,

      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã lưu lịch sử calories"),
      ),
    );
  }

  /// ================= LEVEL =================
  String getHealthLevel() {

    if (result < 1800) {
      return "Nhu cầu calories thấp";
    }

    if (result < 2500) {
      return "Nhu cầu calories bình thường";
    }

    return "Nhu cầu calories cao";
  }

  /// ================= ADVICE =================
  String getAdvice() {

    if (result < 1800) {
      return "Bạn nên bổ sung thêm protein, tinh bột tốt và ngủ đủ giấc.";
    }

    if (result < 2500) {
      return "Chỉ số khá ổn. Hãy duy trì chế độ ăn và tập luyện.";
    }

    return "Nên ưu tiên thực phẩm sạch và cardio thường xuyên.";
  }

  /// ================= INPUT =================
  Widget input(
      String hint,
      IconData icon,
      TextEditingController controller,
      ) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(

        controller: controller,

        keyboardType: TextInputType.number,

        decoration: InputDecoration(

          prefixIcon: Icon(
            icon,
            color: Colors.orange,
          ),

          hintText: hint,

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  /// ================= ROW =================
  Widget rowData(
      String title,
      String value,
      Color color,
      ) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CARD =================
  Widget adviceCard(
      IconData icon,
      Color color,
      String title,
      String value,
      ) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          CircleAvatar(
            backgroundColor:
            color.withOpacity(0.2),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= FOOD =================
  Widget food(String title, String desc) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),

      child: Row(
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              desc,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {

    double weight =
        double.tryParse(weightController.text) ?? 0;

    return Scaffold(

      backgroundColor: const Color(0xFFF6F7FB),

      /// APPBAR
      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.transparent,

        foregroundColor: Colors.black,

        title: const Text(
          "Tính Calories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(

            icon: const Icon(Icons.history),

            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const CalorieHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(

            constraints: const BoxConstraints(
              maxWidth: 430,
            ),

            child: Padding(
              padding: const EdgeInsets.all(18),

              child: Card(

                elevation: 10,

                shadowColor:
                Colors.orange.withOpacity(0.2),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(30),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(22),

                  child: Column(
                    children: [

                      /// HEADER
                      Container(

                        width: double.infinity,

                        padding:
                        const EdgeInsets.all(22),

                        decoration: BoxDecoration(

                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.deepOrange.shade400,
                            ],
                          ),

                          borderRadius:
                          BorderRadius.circular(25),
                        ),

                        child: const Column(
                          children: [

                            Icon(
                              Icons.local_fire_department,
                              color: Colors.white,
                              size: 50,
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Calories Calculator",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "Tính lượng calories cần mỗi ngày",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// INPUT
                      input(
                        "Cân nặng (kg)",
                        Icons.monitor_weight,
                        weightController,
                      ),

                      input(
                        "Chiều cao (cm)",
                        Icons.height,
                        heightController,
                      ),

                      input(
                        "Tuổi",
                        Icons.calendar_month,
                        ageController,
                      ),

                      const SizedBox(height: 8),

                      /// GENDER
                      DropdownButtonFormField(

                        value: gender,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                        ),

                        items: ["Nam", "Nữ"]
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                            .toList(),

                        onChanged: (v) {
                          setState(() {
                            gender = v!;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      /// ACTIVITY
                      DropdownButtonFormField(

                        value: activity,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                        ),

                        items: [
                          "Ít vận động",
                          "Vận động nhẹ",
                          "Vận động vừa",
                          "Vận động nặng"
                        ]
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                            .toList(),

                        onChanged: (v) {
                          setState(() {
                            activity = v!;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      /// BUTTON
                      SizedBox(

                        width: double.infinity,
                        height: 58,

                        child: ElevatedButton.icon(

                          style:
                          ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.orange,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                          ),

                          onPressed:
                          calculateCalories,

                          icon:
                          const Icon(Icons.calculate),

                          label: const Text(
                            "Tính Calories",
                            style:
                            TextStyle(fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// SAVE BUTTON
                      if (result > 0)
                        SizedBox(

                          width: double.infinity,
                          height: 55,

                          child: ElevatedButton.icon(

                            style:
                            ElevatedButton.styleFrom(

                              backgroundColor:
                              Colors.green,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                            ),

                            onPressed: saveCalories,

                            icon: const Icon(Icons.save),

                            label: const Text(
                              "Lưu lịch sử",
                              style:
                              TextStyle(fontSize: 17),
                            ),
                          ),
                        ),

                      const SizedBox(height: 28),

                      /// RESULT
                      if (result > 0)
                        Container(

                          width: double.infinity,

                          padding:
                          const EdgeInsets.all(22),

                          decoration: BoxDecoration(

                            borderRadius:
                            BorderRadius.circular(28),

                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade50,
                                Colors.white,
                              ],
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange
                                    .withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),

                          child: Column(
                            children: [

                              CircleAvatar(
                                radius: 38,

                                backgroundColor:
                                Colors.orange.shade100,

                                child: Icon(
                                  Icons
                                      .local_fire_department,
                                  color:
                                  Colors.orange.shade700,
                                  size: 42,
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Text(
                                "Calories mỗi ngày",

                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                result.toStringAsFixed(0),

                                style: TextStyle(
                                  fontSize: 54,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  Colors.orange.shade700,
                                ),
                              ),

                              const Text(
                                "kcal / day",

                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Container(

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),

                                decoration: BoxDecoration(
                                  color:
                                  Colors.orange.shade100,

                                  borderRadius:
                                  BorderRadius.circular(
                                      30),
                                ),

                                child: Text(
                                  getHealthLevel(),

                                  style: TextStyle(
                                    color:
                                    Colors.orange.shade900,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              Divider(
                                color: Colors.grey.shade300,
                              ),

                              const SizedBox(height: 18),

                              rowData(
                                "🔥 Giảm cân",
                                "${(result - 300).toStringAsFixed(0)} kcal",
                                Colors.red,
                              ),

                              rowData(
                                "⚖️ Giữ cân",
                                "${result.toStringAsFixed(0)} kcal",
                                Colors.green,
                              ),

                              rowData(
                                "💪 Tăng cân",
                                "${(result + 300).toStringAsFixed(0)} kcal",
                                Colors.blue,
                              ),

                              const SizedBox(height: 26),

                              adviceCard(
                                Icons.water_drop,
                                Colors.blue,
                                "Nước cần uống",
                                "${(weight * 0.035).toStringAsFixed(1)} L mỗi ngày",
                              ),

                              const SizedBox(height: 12),

                              adviceCard(
                                Icons.egg_alt,
                                Colors.orange,
                                "Protein khuyến nghị",
                                "${(weight * 1.6).toStringAsFixed(0)} g/ngày",
                              ),

                              const SizedBox(height: 22),

                              /// FOOD
                              Container(

                                width: double.infinity,

                                padding:
                                const EdgeInsets.all(18),

                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,

                                  borderRadius:
                                  BorderRadius.circular(22),
                                ),

                                child: Column(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [

                                    const Row(
                                      children: [

                                        Icon(
                                          Icons.restaurant,
                                          color: Colors.green,
                                        ),

                                        SizedBox(width: 8),

                                        Text(
                                          "Gợi ý dinh dưỡng",

                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,

                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    food(
                                      "🥦 Rau xanh",
                                      "Bổ sung chất xơ và vitamin",
                                    ),

                                    food(
                                      "🍗 Thịt gà",
                                      "Protein sạch hỗ trợ tăng cơ",
                                    ),

                                    food(
                                      "🥚 Trứng",
                                      "Giàu dinh dưỡng",
                                    ),

                                    food(
                                      "🍌 Chuối",
                                      "Tốt cho tim mạch",
                                    ),

                                    food(
                                      "🥛 Sữa",
                                      "Hỗ trợ phát triển cơ bắp",
                                    ),

                                    const SizedBox(height: 16),

                                    Text(
                                      getAdvice(),

                                      style: const TextStyle(
                                        height: 1.5,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
    );
  }
}