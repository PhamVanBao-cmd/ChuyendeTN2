import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {

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
          prefs.getInt("stepGoal") ??
              10000;

      steps =
          prefs.getInt("todaySteps") ??
              0;

      initialSteps =
          prefs.getInt("initialSteps");
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

    stepStream =
        Pedometer.stepCountStream.listen(

              (StepCount event) async {

            /// LƯU MỐC BAN ĐẦU
            initialSteps ??= event.steps;

            /// TÍNH BƯỚC HÔM NAY
            final currentSteps =
                event.steps - initialSteps!;

            setState(() {

              steps =
              currentSteps < 0
                  ? 0
                  : currentSteps;

              status =
              "Đang theo dõi";
            });

            /// SAVE
            await saveData();
          },

          onError: (e) {

            setState(() {

              status =
              "Thiết bị không hỗ trợ";
            });
          },
        );
  }

  /// ================= RESET DAILY =================
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

  /// ================= STEP LEVEL =================
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

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(25),
          ),

          title: const Text(
            "Đổi mục tiêu bước",
          ),

          content: TextField(

            controller: controller,

            keyboardType:
            TextInputType.number,

            decoration: InputDecoration(

              hintText: "Ví dụ: 12000",

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Hủy"),
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

                Navigator.pop(context);
              },

              child: const Text("Lưu"),
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

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(28),

          boxShadow: [

            BoxShadow(
              color:
              color.withOpacity(0.12),

              blurRadius: 10,

              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          children: [

            CircleAvatar(

              radius: 28,

              backgroundColor:
              color.withOpacity(0.15),

              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              value,

              style: const TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

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
      const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

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
            color.withOpacity(0.15),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,

                  style: const TextStyle(
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

            onPressed: changeGoalDialog,

            icon: const Icon(
              Icons.flag,
            ),
          ),

          IconButton(

            onPressed: resetTodaySteps,

            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ================= HEADER =================
            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(28),

              decoration: BoxDecoration(

                gradient:
                LinearGradient(
                  colors: [

                    levelColor,

                    levelColor.withOpacity(
                      0.7,
                    ),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(35),

                boxShadow: [

                  BoxShadow(
                    color:
                    levelColor.withOpacity(
                      0.35,
                    ),

                    blurRadius: 18,

                    offset:
                    const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                children: [

                  Container(

                    padding:
                    const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white24,

                      borderRadius:
                      BorderRadius.circular(
                        100,
                      ),
                    ),

                    child: const Icon(
                      Icons.directions_walk,

                      color: Colors.white,

                      size: 65,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "$steps",

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 58,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const Text(
                    "Bước hôm nay",

                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 25),

                  ClipRRect(

                    borderRadius:
                    BorderRadius.circular(
                      30,
                    ),

                    child:
                    LinearProgressIndicator(

                      value: progress,

                      minHeight: 14,

                      backgroundColor:
                      Colors.white24,

                      valueColor:
                      const AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "$steps / $goal bước",

                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.white24,

                      borderRadius:
                      BorderRadius.circular(
                        30,
                      ),
                    ),

                    child: Text(
                      stepLevel,

                      style: const TextStyle(
                        color: Colors.white,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= STATUS =================
            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(24),

                boxShadow: const [

                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  ),
                ],
              ),

              child: Row(
                children: [

                  Container(

                    padding:
                    const EdgeInsets.all(10),

                    decoration: BoxDecoration(

                      color:
                      Colors.green.withOpacity(
                        0.15,
                      ),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.health_and_safety,

                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      status,

                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,

                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [

                infoCard(
                  Icons.local_fire_department,
                  "Calories",
                  calories
                      .toStringAsFixed(0),
                  Colors.orange,
                ),

                const SizedBox(width: 14),

                infoCard(
                  Icons.route,
                  "Khoảng cách",
                  "${distance.toStringAsFixed(2)} km",
                  Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [

                infoCard(
                  Icons.timer,
                  "Thời gian",
                  "${walkMinutes.toStringAsFixed(0)} phút",
                  Colors.purple,
                ),

                const SizedBox(width: 14),

                infoCard(
                  Icons.flag,
                  "Mục tiêu",
                  "$goal",
                  Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 25),

            healthCard(
              Icons.favorite,
              "Trạng thái vận động",
              stepLevel,
              levelColor,
            ),

            healthCard(
              Icons.water_drop,
              "Nước khuyến nghị",
              "${(steps / 2000 * 0.3 + 2).toStringAsFixed(1)} L mỗi ngày",
              Colors.blue,
            ),

            healthCard(
              Icons.bedtime,
              "Gợi ý nghỉ ngơi",
              steps > 10000
                  ? "Bạn nên nghỉ ngơi và giãn cơ."
                  : "Hãy vận động thêm để đạt mục tiêu.",
              Colors.indigo,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}