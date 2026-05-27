import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  State<CalorieScreen> createState() =>
      _CalorieScreenState();
}

class _CalorieScreenState
    extends State<CalorieScreen> {

  final weightController =
  TextEditingController();

  final heightController =
  TextEditingController();

  final ageController =
  TextEditingController();

  String gender = "Nam";

  String activity = "Vận động nhẹ";

  String goal = "Giữ cân";

  double result = 0;

  /// ================= CALCULATE =================
  void calculateCalories() {

    double weight =
        double.tryParse(
          weightController.text,
        ) ??
            0;

    double height =
        double.tryParse(
          heightController.text,
        ) ??
            0;

    int age =
        int.tryParse(
          ageController.text,
        ) ??
            0;

    if (weight == 0 ||
        height == 0 ||
        age == 0) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Vui lòng nhập đầy đủ thông tin",
          ),
        ),
      );

      return;
    }

    double bmr;

    /// BMR
    if (gender == "Nam") {

      bmr =
          10 * weight +
              6.25 * height -
              5 * age +
              5;

    } else {

      bmr =
          10 * weight +
              6.25 * height -
              5 * age -
              161;
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

    double calories =
        bmr * activityFactor;

    /// GOAL
    if (goal == "Giảm cân") {
      calories -= 300;
    }

    if (goal == "Tăng cân") {
      calories += 300;
    }

    setState(() {
      result = calories;
    });
  }

  /// ================= SAVE =================
  Future<void> saveCalories() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (result <= 0) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Hãy tính calories trước",
          ),
        ),
      );

      return;
    }

    double weight =
        double.tryParse(
          weightController.text,
        ) ??
            0;

    double height =
        double.tryParse(
          heightController.text,
        ) ??
            0;

    int age =
        int.tryParse(
          ageController.text,
        ) ??
            0;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('health')
        .add({

      /// TYPE
      'type': 'calories',

      /// DATA
      'weight': weight,
      'height': height,
      'age': age,

      'gender': gender,
      'activity': activity,
      'goal': goal,

      'calories': result,

      /// DATE
      'createdAt': Timestamp.now(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text(
          "Đã lưu calories",
        ),
      ),
    );
  }

  /// ================= HEALTH =================
  String getHealthLevel() {

    if (result < 1800) {
      return "Calories thấp";
    }

    if (result < 2500) {
      return "Calories ổn định";
    }

    return "Calories cao";
  }

  /// ================= ADVICE =================
  String getAdvice() {

    if (goal == "Giảm cân") {

      return "Ưu tiên cardio, hạn chế đồ ngọt và nước có gas.";
    }

    if (goal == "Tăng cân") {

      return "Bổ sung protein, ngủ đủ giấc và tập gym.";
    }

    return "Duy trì chế độ ăn uống cân bằng.";
  }

  /// ================= INPUT =================
  Widget input(
      String hint,
      IconData icon,
      TextEditingController controller,
      ) {

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: TextField(

        controller: controller,

        keyboardType:
        TextInputType.number,

        decoration: InputDecoration(

          prefixIcon: Icon(
            icon,
            color: Colors.orange,
          ),

          hintText: hint,

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(
              18,
            ),

            borderSide:
            BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {

    double weight =
        double.tryParse(
          weightController.text,
        ) ??
            0;

    double protein =
        weight * 1.6;

    double carb =
        weight * 3.5;

    double fat =
        weight * 0.8;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF6F7FB),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        Colors.transparent,

        foregroundColor:
        Colors.black,

        title: const Text(

          "Calories Calculator",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(18),

        child: Column(
          children: [

            /// HEADER
            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(24),

              decoration: BoxDecoration(

                gradient:
                LinearGradient(
                  colors: [

                    Colors.orange.shade400,

                    Colors.deepOrange,
                  ],
                ),

                borderRadius:
                BorderRadius.circular(
                  30,
                ),
              ),

              child: const Column(
                children: [

                  Icon(
                    Icons.local_fire_department,
                    size: 55,
                    color: Colors.white,
                  ),

                  SizedBox(height: 10),

                  Text(

                    "Calories Tracker",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 28,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(

                    "Theo dõi calories & dinh dưỡng",

                    style: TextStyle(
                      color:
                      Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// INPUT CARD
            Container(

              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  28,
                ),
              ),

              child: Column(
                children: [

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

                  const SizedBox(height: 10),

                  DropdownButtonFormField(

                    value: gender,

                    decoration:
                    InputDecoration(

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    items:
                    ["Nam", "Nữ"]
                        .map(
                          (e) =>
                          DropdownMenuItem(
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

                  DropdownButtonFormField(

                    value: activity,

                    decoration:
                    InputDecoration(

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    items: [

                      "Ít vận động",

                      "Vận động nhẹ",

                      "Vận động vừa",

                      "Vận động nặng"
                    ]
                        .map(
                          (e) =>
                          DropdownMenuItem(
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

                  const SizedBox(height: 14),

                  DropdownButtonFormField(

                    value: goal,

                    decoration:
                    InputDecoration(

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    items: [

                      "Giảm cân",

                      "Giữ cân",

                      "Tăng cân"
                    ]
                        .map(
                          (e) =>
                          DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                    )
                        .toList(),

                    onChanged: (v) {

                      setState(() {
                        goal = v!;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(

                    width: double.infinity,
                    height: 56,

                    child:
                    ElevatedButton.icon(

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        Colors.orange,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      onPressed:
                      calculateCalories,

                      icon:
                      const Icon(
                        Icons.calculate,
                      ),

                      label:
                      const Text(
                        "Tính Calories",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// RESULT
            if (result > 0)
              Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(24),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),
                ),

                child: Column(
                  children: [

                    CircularPercentIndicator(

                      radius: 95,

                      lineWidth: 14,

                      percent:
                      (result / 3000)
                          .clamp(
                        0.0,
                        1.0,
                      ),

                      circularStrokeCap:
                      CircularStrokeCap.round,

                      progressColor:
                      Colors.orange,

                      center: Column(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                        children: [

                          Text(

                            result
                                .toStringAsFixed(
                              0,
                            ),

                            style:
                            const TextStyle(

                              fontSize:
                              36,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const Text(
                            "kcal",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      getHealthLevel(),

                      style: const TextStyle(

                        fontSize: 20,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      getAdvice(),

                      textAlign:
                      TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly,

                      children: [

                        Text(
                          "🥩 ${protein.toStringAsFixed(0)}g",
                        ),

                        Text(
                          "🍞 ${carb.toStringAsFixed(0)}g",
                        ),

                        Text(
                          "🥑 ${fat.toStringAsFixed(0)}g",
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    SizedBox(

                      width: double.infinity,
                      height: 55,

                      child:
                      ElevatedButton.icon(

                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:
                          Colors.green,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              18,
                            ),
                          ),
                        ),

                        onPressed: () async {

                          await saveCalories();
                        },

                        icon:
                        const Icon(
                          Icons.save,
                        ),

                        label:
                        const Text(
                          "Lưu lịch sử",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}