import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() =>
      _StepScreenState();
}

class _StepScreenState
    extends State<StepScreen> {

  StreamSubscription<StepCount>? stepStream;

  int steps = 0;

  int goal = 10000;

  String status = "Đang tải...";

  int? initialSteps;

  double userWeight = 65;

  /// ================= INIT =================
  @override
  void initState() {

    super.initState();

    loadData().then((_) {

      requestPermission();
    });
  }

  /// ================= LOAD DATA =================
  Future<void> loadData() async {

    final prefs =
    await SharedPreferences.getInstance();

    setState(() {

      goal =
          prefs.getInt(
            "stepGoal",
          ) ??
              10000;

      steps =
          prefs.getInt(
            "todaySteps",
          ) ??
              0;

      initialSteps =
          prefs.getInt(
            "initialSteps",
          );
    });
  }

  /// ================= SAVE DATA =================
  Future<void> saveData() async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      "stepGoal",
      goal,
    );

    await prefs.setInt(
      "todaySteps",
      steps,
    );

    if (initialSteps != null) {

      await prefs.setInt(
        "initialSteps",
        initialSteps!,
      );
    }
  }

  /// ================= SAVE GOAL =================
  Future<void> saveGoal() async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      "stepGoal",
      goal,
    );
  }

  /// ================= PERMISSION =================
  Future<void> requestPermission() async {

    final result =
    await Permission.activityRecognition
        .request();

    if (result.isGranted) {

      startListening();

    } else {

      setState(() {

        status =
        "Không có quyền truy cập";
      });
    }
  }

  /// ================= START =================
  void startListening() {

    stepStream?.cancel();

    stepStream =
        Pedometer.stepCountStream.listen(

              (StepCount event) async {

            print(
              "TOTAL SENSOR: ${event.steps}",
            );

            /// lưu mốc đầu tiên
            if (initialSteps == null) {

              initialSteps =
                  event.steps;

              await saveData();
            }

            int todaySteps =
                event.steps -
                    initialSteps!;

            if (todaySteps < 0) {
              todaySteps = 0;
            }

            setState(() {

              steps = todaySteps;

              status =
              "Đang theo dõi bước chân";
            });

            await saveData();
          },

          onError: (error) {

            print(error);

            setState(() {

              status =
              "Thiết bị không hỗ trợ cảm biến";
            });
          },
        );
  }

  /// ================= RESET =================
  Future<void> resetTodaySteps() async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(
      "initialSteps",
    );

    initialSteps = null;

    steps = 0;

    await saveData();

    setState(() {});
  }

  /// ================= PROGRESS =================
  double get progress {

    if (steps >= goal) {
      return 1;
    }

    return steps / goal;
  }

  /// ================= CALORIES =================
  double get calories {

    return steps * 0.045;
  }

  /// ================= DISTANCE =================
  double get distance {

    return steps * 0.00075;
  }

  /// ================= TIME WALK =================
  double get walkMinutes {

    return steps / 100;
  }

  /// ================= LEVEL =================
  String get stepLevel {

    if (steps < 3000) {
      return "Ít vận động";
    }

    if (steps < 7000) {
      return "Khá tốt";
    }

    if (steps < 10000) {
      return "Tốt";
    }

    return "Xuất sắc";
  }

  /// ================= COLOR =================
  Color get levelColor {

    if (steps < 3000) {
      return Colors.red;
    }

    if (steps < 7000) {
      return Colors.orange;
    }

    if (steps < 10000) {
      return Colors.blue;
    }

    return Colors.green;
  }

  /// ================= CHANGE GOAL =================
  void changeGoalDialog() {

    final controller =
    TextEditingController(
      text: goal.toString(),
    );

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              25,
            ),
          ),

          title: const Text(
            "Đổi mục tiêu bước",
          ),

          content: TextField(

            controller: controller,

            keyboardType:
            TextInputType.number,

            decoration: InputDecoration(

              hintText:
              "Ví dụ: 12000",

              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  15,
                ),
              ),
            ),
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                );
              },

              child: const Text(
                "Hủy",
              ),
            ),

            ElevatedButton(

              onPressed: () async {

                setState(() {

                  goal =
                      int.tryParse(
                        controller.text,
                      ) ??
                          10000;
                });

                await saveGoal();

                Navigator.pop(
                  context,
                );
              },

              child: const Text(
                "Lưu",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {

    stepStream?.cancel();

    super.dispose();
  }

  /// ================= INFO CARD =================
  Widget infoCard(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {

    return Expanded(
      child: Container(

        padding:
        const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(
            28,
          ),

          boxShadow: [

            BoxShadow(
              color:
              color.withOpacity(
                0.12,
              ),

              blurRadius: 10,

              offset:
              const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          children: [

            CircleAvatar(

              radius: 28,

              backgroundColor:
              color.withOpacity(
                0.15,
              ),

              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              value,

              style:
              const TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              title,

              style:
              const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= HEALTH CARD =================
  Widget healthCard(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {

    return Container(

      width: double.infinity,

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          24,
        ),

        boxShadow: const [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 24,

            backgroundColor:
            color.withOpacity(
              0.15,
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style:
                  const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  value,

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,

                    fontSize: 17,
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

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        Colors.transparent,

        foregroundColor:
        Colors.black,

        title: const Text(
          "Theo dõi bước chân",
        ),

        actions: [

          IconButton(

            onPressed:
            changeGoalDialog,

            icon: const Icon(
              Icons.flag,
            ),
          ),

          IconButton(

            onPressed:
            resetTodaySteps,

            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Column(
          children: [

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(
                28,
              ),

              decoration: BoxDecoration(

                gradient:
                LinearGradient(
                  colors: [

                    levelColor,

                    levelColor
                        .withOpacity(
                      0.7,
                    ),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(
                  35,
                ),
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.directions_walk,
                    color: Colors.white,
                    size: 70,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text(
                    "$steps",

                    style:
                    const TextStyle(
                      color:
                      Colors.white,

                      fontSize: 55,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const Text(
                    "Bước hôm nay",

                    style: TextStyle(
                      color:
                      Colors.white70,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    "$steps / $goal bước",

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            healthCard(
              Icons.favorite,
              "Trạng thái",
              stepLevel,
              levelColor,
            ),

            healthCard(
              Icons.local_fire_department,
              "Calories",
              "${calories.toStringAsFixed(0)} kcal",
              Colors.orange,
            ),

            healthCard(
              Icons.route,
              "Khoảng cách",
              "${distance.toStringAsFixed(2)} km",
              Colors.blue,
            ),

            healthCard(
              Icons.timer,
              "Thời gian đi bộ",
              "${walkMinutes.toStringAsFixed(0)} phút",
              Colors.purple,
            ),

            healthCard(
              Icons.info,
              "Trạng thái cảm biến",
              status,
              Colors.green,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}