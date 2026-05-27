import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'calorie_history_screen.dart';

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

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('calories')
        .add({

      'weight':
      weightController.text,

      'height':
      heightController.text,

      'age':
      ageController.text,

      'gender': gender,

      'activity': activity,

      'goal': goal,

      'calories': result,

      'createdAt':
      Timestamp.now(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
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

  /// ================= MACRO CARD =================
  Widget macroCard(
      String title,
      String value,
      Color color,
      IconData icon,
      ) {

    return Expanded(
      child: Container(

        margin:
        const EdgeInsets.symmetric(
          horizontal: 5,
        ),

        padding:
        const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color:
          color.withOpacity(0.1),

          borderRadius:
          BorderRadius.circular(
            20,
          ),
        ),

        child: Column(
          children: [

            Icon(
              icon,
              color: color,
              size: 28,
            ),

            const SizedBox(height: 10),

            Text(
              value,

              style: TextStyle(
                color: color,

                fontWeight:
                FontWeight.bold,

                fontSize: 18,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,

              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= FOOD =================
  Widget foodTile(
      String emoji,
      String title,
      String desc,
      ) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          18,
        ),
      ),

      child: Row(
        children: [

          Text(
            emoji,
            style: const TextStyle(
              fontSize: 28,
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

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  desc,

                  style:
                  const TextStyle(
                    color:
                    Colors.grey,
                  ),
                ),
              ],
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

        actions: [

          IconButton(

            icon:
            const Icon(Icons.history),

            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder:
                      (_) =>
                  const CalorieHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(18),

        child: Column(
          children: [

            /// ================= HEADER =================
            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(
                24,
              ),

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

            /// ================= INPUT CARD =================
            Container(

              padding:
              const EdgeInsets.all(
                20,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  28,
                ),

                boxShadow: [

                  BoxShadow(
                    color:
                    Colors.black
                        .withOpacity(
                      0.05,
                    ),

                    blurRadius: 10,
                  ),
                ],
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

                  /// GENDER
                  DropdownButtonFormField(

                    value: gender,

                    decoration:
                    InputDecoration(
                      filled: true,

                      fillColor:
                      Colors.white,

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

                  /// ACTIVITY
                  DropdownButtonFormField(

                    value: activity,

                    decoration:
                    InputDecoration(
                      filled: true,

                      fillColor:
                      Colors.white,

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

                  /// GOAL
                  DropdownButtonFormField(

                    value: goal,

                    decoration:
                    InputDecoration(
                      filled: true,

                      fillColor:
                      Colors.white,

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

                  /// BUTTON
                  SizedBox(

                    width:
                    double.infinity,

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

                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// ================= RESULT =================
            if (result > 0)
              Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(
                  24,
                ),

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

                      backgroundColor:
                      Colors.orange
                          .withOpacity(
                        0.15,
                      ),

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

                    Container(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        Colors.orange
                            .shade100,

                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                      ),

                      child: Text(
                        getHealthLevel(),

                        style: TextStyle(
                          color:
                          Colors.orange
                              .shade900,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// GOAL CARD
                    Container(

                      width:
                      double.infinity,

                      padding:
                      const EdgeInsets.all(
                        18,
                      ),

                      decoration:
                      BoxDecoration(
                        gradient:
                        LinearGradient(
                          colors: [

                            Colors.orange
                                .shade100,

                            Colors.orange
                                .shade50,
                          ],
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          22,
                        ),
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons.flag,
                            color:
                            Colors.orange,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Text(
                              "Mục tiêu hiện tại: $goal",

                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// DAILY TARGET
                    Row(
                      children: [

                        macroCard(
                          "Protein",
                          "${protein.toStringAsFixed(0)}g",
                          Colors.red,
                          Icons.egg_alt,
                        ),

                        macroCard(
                          "Carb",
                          "${carb.toStringAsFixed(0)}g",
                          Colors.orange,
                          Icons.bakery_dining,
                        ),

                        macroCard(
                          "Fat",
                          "${fat.toStringAsFixed(0)}g",
                          Colors.blue,
                          Icons.opacity,
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    /// WATER
                    Container(

                      width:
                      double.infinity,

                      padding:
                      const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        Colors.blue
                            .shade50,

                        borderRadius:
                        BorderRadius.circular(
                          24,
                        ),
                      ),

                      child: Row(
                        children: [

                          CircleAvatar(
                            radius: 28,

                            backgroundColor:
                            Colors.blue
                                .shade100,

                            child: const Icon(
                              Icons.water_drop,

                              color:
                              Colors.blue,
                            ),
                          ),

                          const SizedBox(
                            width: 16,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                const Text(
                                  "Nước cần uống",

                                  style:
                                  TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .bold,

                                    fontSize:
                                    16,
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  "${(weight * 0.035).toStringAsFixed(1)} L mỗi ngày",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// MEAL PLAN
                    Container(

                      width:
                      double.infinity,

                      padding:
                      const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        Colors.green
                            .shade50,

                        borderRadius:
                        BorderRadius.circular(
                          24,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          const Row(
                            children: [

                              Icon(
                                Icons.restaurant,
                                color:
                                Colors.green,
                              ),

                              SizedBox(
                                width: 8,
                              ),

                              Text(
                                "Gợi ý bữa ăn",

                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,

                                  fontSize:
                                  18,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          foodTile(
                            "🍳",
                            "Bữa sáng",
                            "Trứng, yến mạch, sữa",
                          ),

                          foodTile(
                            "🍗",
                            "Bữa trưa",
                            "Cơm, ức gà, rau xanh",
                          ),

                          foodTile(
                            "🥗",
                            "Bữa tối",
                            "Salad, cá hồi, trái cây",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ADVICE
                    Container(

                      width:
                      double.infinity,

                      padding:
                      const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        Colors.orange
                            .shade50,

                        borderRadius:
                        BorderRadius.circular(
                          22,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          const Text(
                            "💡 Lời khuyên",

                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,

                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Text(
                            getAdvice(),

                            style:
                            const TextStyle(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// SAVE
                    SizedBox(

                      width:
                      double.infinity,

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

                        onPressed:
                        saveCalories,

                        icon:
                        const Icon(
                          Icons.save,
                        ),

                        label:
                        const Text(
                          "Lưu lịch sử",

                          style: TextStyle(
                            fontSize: 17,
                          ),
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