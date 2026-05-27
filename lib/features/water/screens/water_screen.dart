import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:theodoisuckhoe/core/services/notification_service.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {

  /// ================= WATER =================
  int currentWater = 0;

  int goalWater = 2500;

  int streakDays = 5;

  String waterLevel = "Tốt";

  /// ================= INPUT =================
  final TextEditingController waterController =
  TextEditingController();

  /// ================= REMINDER =================
  int reminderMinutes = 30;

  @override
  void initState() {
    super.initState();

    loadWater();
  }

  /// ================= LOAD =================
  Future<void> loadWater() async {

    final prefs =
    await SharedPreferences.getInstance();

    setState(() {

      currentWater =
          prefs.getInt("current_water") ?? 0;

      reminderMinutes =
          prefs.getInt("reminder") ?? 30;

      goalWater =
          prefs.getInt("goal_water") ?? 2500;

      streakDays =
          prefs.getInt("streak_days") ?? 5;
    });

    updateWaterLevel();
  }

  /// ================= SAVE =================
  Future<void> saveWater() async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      "current_water",
      currentWater,
    );

    await prefs.setInt(
      "goal_water",
      goalWater,
    );

    await prefs.setInt(
      "streak_days",
      streakDays,
    );
  }

  /// ================= SAVE REMINDER =================
  Future<void> saveReminder() async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      "reminder",
      reminderMinutes,
    );
  }

  /// ================= WATER LEVEL =================
  void updateWaterLevel() {

    final percent =
        (currentWater / goalWater) * 100;

    if (percent >= 100) {

      waterLevel = "Hoàn hảo 💧";

    } else if (percent >= 70) {

      waterLevel = "Tốt 👍";

    } else if (percent >= 40) {

      waterLevel = "Trung bình";

    } else {

      waterLevel = "Thiếu nước";
    }
  }

  /// ================= ADD WATER =================
  Future<void> addWater(int amount) async {

    setState(() {

      currentWater += amount;

      if (currentWater > goalWater) {
        currentWater = goalWater;
      }

      updateWaterLevel();

      if (currentWater >= goalWater) {
        streakDays++;
      }
    });

    await saveWater();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        content: Text(
          "Đã thêm $amount ml nước 💧",
        ),
      ),
    );
  }

  /// ================= CUSTOM WATER =================
  Future<void> addCustomWater() async {

    final value =
    int.tryParse(
      waterController.text,
    );

    if (value == null || value <= 0) {
      return;
    }

    setState(() {

      currentWater += value;

      if (currentWater > goalWater) {
        currentWater = goalWater;
      }

      updateWaterLevel();
    });

    await saveWater();

    waterController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        content: Text(
          "Đã lưu $value ml nước 💧",
        ),
      ),
    );
  }

  /// ================= RESET =================
  Future<void> resetWater() async {

    setState(() {

      currentWater = 0;

      updateWaterLevel();
    });

    await saveWater();
  }

  /// ================= PROGRESS =================
  double get progress {

    return currentWater / goalWater;
  }

  /// ================= PICK REMINDER =================
  Future<void> pickReminderTime() async {

    final result =
    await showDialog<int>(

      context: context,

      builder: (context) {

        final controller =
        TextEditingController(
          text: reminderMinutes.toString(),
        );

        return AlertDialog(

          title: const Text(
            "Nhập thời gian nhắc",
          ),

          content: TextField(
            controller: controller,

            keyboardType:
            TextInputType.number,

            decoration: const InputDecoration(
              hintText: "Ví dụ: 30",
              labelText: "Số phút",
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
              onPressed: () {

                final minutes =
                int.tryParse(
                  controller.text,
                );

                if (minutes != null &&
                    minutes > 0) {

                  Navigator.pop(
                    context,
                    minutes,
                  );
                }
              },

              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );

    if (result != null) {

      setState(() {
        reminderMinutes = result;
      });

      await saveReminder();

      await NotificationService.showNotification(
        title: "Nhắc uống nước 💧",
        body:
        "Tôi sẽ nhắc bạn sau $reminderMinutes phút",
      );

      await NotificationService
          .scheduleWaterReminder(
        reminderMinutes,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            "Đã đặt nhắc sau $reminderMinutes phút",
          ),
        ),
      );
    }
  }

  /// ================= CHANGE GOAL =================
  Future<void> changeGoal() async {

    final controller =
    TextEditingController(
      text: goalWater.toString(),
    );

    final result =
    await showDialog<int>(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            "Đổi mục tiêu nước",
          ),

          content: TextField(
            controller: controller,

            keyboardType:
            TextInputType.number,

            decoration: const InputDecoration(
              hintText: "Ví dụ: 3000",
              labelText: "ml nước",
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
              onPressed: () {

                final value =
                int.tryParse(
                  controller.text,
                );

                if (value != null &&
                    value > 0) {

                  Navigator.pop(
                    context,
                    value,
                  );
                }
              },

              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );

    if (result != null) {

      setState(() {
        goalWater = result;
      });

      updateWaterLevel();

      await saveWater();
    }
  }

  /// ================= BUTTON =================
  Widget waterButton(
      String text,
      int amount,
      Color color,
      ) {

    return Expanded(
      child: GestureDetector(

        onTap: () {
          addWater(amount);
        },

        child: Container(

          padding:
          const EdgeInsets.symmetric(
            vertical: 18,
          ),

          decoration: BoxDecoration(
            color: color,

            borderRadius:
            BorderRadius.circular(22),
          ),

          child: Column(
            children: [

              const Icon(
                Icons.water_drop,
                color: Colors.white,
                size: 30,
              ),

              const SizedBox(height: 10),

              Text(
                text,

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          BorderRadius.circular(25),

          boxShadow: const [

            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),

        child: Column(
          children: [

            CircleAvatar(
              radius: 26,

              backgroundColor:
              color.withOpacity(0.15),

              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              value,

              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(

        title: const Text(
          "Theo dõi nước uống",
        ),

        backgroundColor:
        Colors.transparent,

        foregroundColor:
        Colors.black,

        elevation: 0,

        actions: [

          IconButton(
            onPressed: () {
              changeGoal();
            },

            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ================= HEADER =================
            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(28),

              decoration: BoxDecoration(

                gradient:
                const LinearGradient(
                  colors: [
                    Color(0xFF36D1DC),
                    Color(0xFF5B86E5),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(30),
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.water_drop,
                    color: Colors.white,
                    size: 75,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "$currentWater ml",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Mục tiêu: $goalWater ml",

                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 22),

                  ClipRRect(

                    borderRadius:
                    BorderRadius.circular(
                      20,
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

                  const SizedBox(height: 12),

                  Text(
                    "${(progress * 100).toInt()}% hoàn thành",

                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= STATS =================
            Row(
              children: [

                infoCard(
                  Icons.emoji_events,
                  "Streak",
                  "$streakDays ngày",
                  Colors.orange,
                ),

                const SizedBox(width: 15),

                infoCard(
                  Icons.health_and_safety,
                  "Đánh giá",
                  waterLevel,
                  Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// ================= QUICK BUTTON =================
            Row(
              children: [

                waterButton(
                  "+200ml",
                  200,
                  Colors.blue,
                ),

                const SizedBox(width: 12),

                waterButton(
                  "+500ml",
                  500,
                  Colors.cyan,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                waterButton(
                  "+750ml",
                  750,
                  Colors.indigo,
                ),

                const SizedBox(width: 12),

                waterButton(
                  "+1000ml",
                  1000,
                  Colors.teal,
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// ================= INPUT =================
            TextField(

              controller: waterController,

              keyboardType:
              TextInputType.number,

              decoration: InputDecoration(

                hintText:
                "Nhập số ml nước",

                prefixIcon:
                const Icon(
                  Icons.water_drop,
                ),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// ================= SAVE =================
            SizedBox(
              width: double.infinity,

              child:
              ElevatedButton.icon(

                onPressed: () {
                  addCustomWater();
                },

                icon: const Icon(
                  Icons.save,
                ),

                label: const Text(
                  "Lưu lượng nước",
                ),

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.blue,

                  foregroundColor:
                  Colors.white,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// ================= REMINDER =================
            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(25),

                boxShadow: const [

                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  ),
                ],
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Row(
                    children: [

                      Icon(
                        Icons.notifications_active,
                        color: Colors.orange,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Nhắc uống nước",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Đang nhắc sau $reminderMinutes phút",
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(

                    onPressed: () {
                      pickReminderTime();
                    },

                    icon: const Icon(
                      Icons.alarm,
                    ),

                    label: const Text(
                      "Đổi thời gian nhắc",
                    ),

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors.orange,

                      foregroundColor:
                      Colors.white,

                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 18,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= HEALTH TIPS =================
            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(22),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(25),

                boxShadow: const [

                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  ),
                ],
              ),

              child: const Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Icon(
                        Icons.tips_and_updates,
                        color: Colors.blue,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Lợi ích uống đủ nước",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  Text(
                    "💧 Giúp da khỏe và đẹp hơn",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "🧠 Tăng tập trung và giảm mệt mỏi",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "🔥 Hỗ trợ giảm cân và trao đổi chất",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "❤️ Tốt cho tim mạch và thận",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= RESET =================
            SizedBox(
              width: double.infinity,

              child:
              ElevatedButton.icon(

                onPressed: () {
                  resetWater();
                },

                icon: const Icon(
                  Icons.refresh,
                ),

                label: const Text(
                  "Reset hôm nay",
                ),

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.red,

                  foregroundColor:
                  Colors.white,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}