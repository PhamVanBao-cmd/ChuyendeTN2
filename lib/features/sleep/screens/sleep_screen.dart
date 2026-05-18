import 'package:flutter/material.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {

  double sleepHours = 7.5;

  double goal = 8;

  TimeOfDay sleepTime =
  const TimeOfDay(hour: 23, minute: 0);

  TimeOfDay wakeTime =
  const TimeOfDay(hour: 6, minute: 30);

  /// ================= QUALITY =================
  String sleepQuality() {

    if (sleepHours >= 8) {
      return "Ngủ rất tốt";
    }

    if (sleepHours >= 6) {
      return "Ổn định";
    }

    return "Thiếu ngủ";
  }

  /// ================= COLOR =================
  Color qualityColor() {

    if (sleepHours >= 8) {
      return Colors.green;
    }

    if (sleepHours >= 6) {
      return Colors.orange;
    }

    return Colors.red;
  }

  /// ================= PROGRESS =================
  double get progress {

    if (sleepHours >= goal) return 1;

    return sleepHours / goal;
  }

  /// ================= CALCULATE HOURS =================
  void calculateSleepHours() {

    final sleepMinutes =
        sleepTime.hour * 60 + sleepTime.minute;

    final wakeMinutes =
        wakeTime.hour * 60 + wakeTime.minute;

    int totalMinutes;

    if (wakeMinutes >= sleepMinutes) {

      totalMinutes =
          wakeMinutes - sleepMinutes;
    } else {

      totalMinutes =
          (24 * 60 - sleepMinutes) + wakeMinutes;
    }

    setState(() {
      sleepHours = totalMinutes / 60;
    });
  }

  /// ================= PICK SLEEP TIME =================
  Future<void> pickSleepTime() async {

    final picked = await showTimePicker(
      context: context,

      initialTime: sleepTime,

      initialEntryMode:
      TimePickerEntryMode.input,

      builder: (context, child) {

        return MediaQuery(

          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),

          child: child!,
        );
      },
    );

    if (picked != null) {

      setState(() {
        sleepTime = picked;
      });

      calculateSleepHours();
    }
  }

  /// ================= PICK WAKE TIME =================
  Future<void> pickWakeTime() async {

    final picked = await showTimePicker(
      context: context,

      initialTime: wakeTime,

      initialEntryMode:
      TimePickerEntryMode.input,

      builder: (context, child) {

        return MediaQuery(

          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),

          child: child!,
        );
      },
    );

    if (picked != null) {

      setState(() {
        wakeTime = picked;
      });

      calculateSleepHours();
    }
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
                fontWeight: FontWeight.bold,
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
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,

        title: const Text(
          "Theo dõi giấc ngủ",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF667eea),
                    Color(0xFF764ba2),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(30),
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.nightlight_round,
                    color: Colors.white,
                    size: 60,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "${sleepHours.toStringAsFixed(1)}h",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    sleepQuality(),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= PROGRESS =================
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,

                      backgroundColor:
                      Colors.white30,

                      valueColor:
                      const AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${sleepHours.toStringAsFixed(1)} / ${goal.toStringAsFixed(0)} giờ",

                    style: const TextStyle(
                      color: Colors.white70,
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
                  Icons.bedtime,
                  "Đi ngủ",
                  sleepTime.format(context),
                  Colors.deepPurple,
                ),

                const SizedBox(width: 15),

                infoCard(
                  Icons.wb_sunny,
                  "Thức dậy",
                  wakeTime.format(context),
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ================= CHANGE BUTTONS =================
            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickSleepTime,

                    icon: const Icon(
                      Icons.nightlight,
                    ),

                    label: const Text(
                      "Giờ ngủ",
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.deepPurple,

                      foregroundColor:
                      Colors.white,

                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickWakeTime,

                    icon: const Icon(
                      Icons.wb_sunny,
                    ),

                    label: const Text(
                      "Giờ dậy",
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.orange,

                      foregroundColor:
                      Colors.white,

                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// ================= QUALITY CARD =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

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

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 28,

                    backgroundColor:
                    qualityColor()
                        .withOpacity(0.15),

                    child: Icon(
                      Icons.health_and_safety,
                      color: qualityColor(),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Đánh giá giấc ngủ",

                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          sleepQuality(),

                          style: TextStyle(
                            color: qualityColor(),
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= TIPS =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

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
                        color: Colors.orange,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Mẹo ngủ ngon",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  Text(
                    "• Ngủ trước 23h",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "• Hạn chế điện thoại trước khi ngủ",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "• Không uống cafe buổi tối",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "• Giữ phòng ngủ yên tĩnh",
                  ),

                  SizedBox(height: 10),

                  Text(
                    "• Duy trì lịch ngủ đều đặn",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}