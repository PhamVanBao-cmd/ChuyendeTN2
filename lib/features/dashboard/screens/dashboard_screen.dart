import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/screens/login_screen.dart';
import '../../calorie/screens/calorie_screen.dart';
import '../../health/screens/health_input_screen.dart';
import '../../health/screens/history_screen.dart';
import '../../profile/screens/profile_screen.dart';

/// STEP + SLEEP
import '../../steps/screens/step_screen.dart';
import '../../sleep/screens/sleep_screen.dart';

/// WATER
import '../../water/screens/water_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  /// ================= WATER =================
  int currentWater = 0;

  final int waterGoal = 2500;

  /// ================= LOAD WATER =================
  Future<void> loadWater() async {

    final prefs =
    await SharedPreferences.getInstance();

    setState(() {

      currentWater =
          prefs.getInt("current_water") ?? 0;
    });
  }

  /// ================= WATER PROGRESS =================
  double get waterProgress {

    if (currentWater >= waterGoal) {
      return 1;
    }

    return currentWater / waterGoal;
  }

  @override
  void initState() {
    super.initState();

    loadWater();
  }

  /// ================= QUICK BUTTON =================
  Widget quickButton(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      Widget screen,
      ) {

    return GestureDetector(

      onTap: () async {

        await Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );

        /// reload water khi quay lại
        loadWater();
      },

      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.75),
              color,
            ],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          borderRadius:
          BorderRadius.circular(28),

          boxShadow: [

            BoxShadow(
              color:
              color.withOpacity(0.25),

              blurRadius: 15,

              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// ICON
            Container(

              padding:
              const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color:
                Colors.white.withOpacity(0.25),

                borderRadius:
                BorderRadius.circular(18),
              ),

              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),

            const Spacer(),

            Text(
              title,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,

              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= LOGOUT =================
  void logout(BuildContext context) async {

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(
        builder: (_) =>
        const LoginScreen(),
      ),

          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F7FC),

      /// ================= APPBAR =================
      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        Colors.transparent,

        title: const Row(
          children: [

            Icon(
              Icons.favorite,
              color: Colors.red,
            ),

            SizedBox(width: 8),

            Text(
              "Health Dashboard",

              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [

          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.black,
            ),

            onPressed: () =>
                logout(context),
          ),
        ],
      ),

      /// ================= BODY =================
      body: RefreshIndicator(

        onRefresh: loadWater,

        child: SingleChildScrollView(

          physics:
          const AlwaysScrollableScrollPhysics(),

          child: Center(

            child: ConstrainedBox(

              constraints:
              const BoxConstraints(
                maxWidth: 460,
              ),

              child: Padding(

                padding:
                const EdgeInsets.all(16),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    /// ================= USER CARD =================
                    Container(

                      width: double.infinity,

                      padding:
                      const EdgeInsets.all(22),

                      decoration: BoxDecoration(

                        gradient:
                        const LinearGradient(
                          colors: [
                            Color(0xFF6A11CB),
                            Color(0xFF2575FC),
                          ],
                        ),

                        borderRadius:
                        BorderRadius.circular(30),

                        boxShadow: [

                          BoxShadow(
                            color:
                            Colors.blue.withOpacity(
                              0.25,
                            ),

                            blurRadius: 18,

                            offset:
                            const Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [

                          CircleAvatar(
                            radius: 34,

                            backgroundColor:
                            Colors.white,

                            child: Text(
                              (user?.email ?? "U")[0]
                                  .toUpperCase(),

                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                const Text(
                                  "Xin chào 👋",

                                  style: TextStyle(
                                    color:
                                    Colors.white70,

                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  user?.email ?? "",

                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white,

                                    fontSize: 17,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Container(

                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),

                                  decoration:
                                  BoxDecoration(
                                    color:
                                    Colors.white
                                        .withOpacity(
                                      0.2,
                                    ),

                                    borderRadius:
                                    BorderRadius.circular(
                                      20,
                                    ),
                                  ),

                                  child: const Text(
                                    "Healthy Lifestyle",

                                    style: TextStyle(
                                      color:
                                      Colors.white,

                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 34,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// ================= HEALTH SCORE =================
                    Container(

                      width: double.infinity,

                      padding:
                      const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(28),

                        boxShadow: const [

                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          ),
                        ],
                      ),

                      child: Row(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [

                          Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              const Text(
                                "Health Score",

                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: const [

                                  Text(
                                    "85",

                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight:
                                      FontWeight.bold,

                                      color: Colors.green,
                                    ),
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    "/100",

                                    style: TextStyle(
                                      color:
                                      Colors.black45,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                "Sức khỏe của bạn đang tốt 💪",
                              ),
                            ],
                          ),

                          Container(

                            padding:
                            const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color:
                              Colors.green.shade100,

                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.monitor_heart,
                              color: Colors.green,
                              size: 45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// ================= WATER =================
                    GestureDetector(

                      onTap: () async {

                        await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const WaterScreen(),
                          ),
                        );

                        loadWater();
                      },

                      child: Container(

                        width: double.infinity,

                        padding:
                        const EdgeInsets.all(20),

                        decoration: BoxDecoration(

                          gradient: LinearGradient(
                            colors: [
                              Colors.cyan.shade400,
                              Colors.blue.shade500,
                            ],
                          ),

                          borderRadius:
                          BorderRadius.circular(28),
                        ),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Row(

                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                              children: const [

                                Text(
                                  "Water Tracker 💧",

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                Icon(
                                  Icons.water_drop,
                                  color: Colors.white,
                                  size: 42,
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            ClipRRect(

                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),

                              child:
                              LinearProgressIndicator(
                                value: waterProgress,

                                minHeight: 12,

                                backgroundColor:
                                Colors.white24,

                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "$currentWater / $waterGoal ml",

                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Quick Actions",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ================= GRID =================
                    GridView.count(

                      shrinkWrap: true,

                      physics:
                      const NeverScrollableScrollPhysics(),

                      crossAxisCount: 2,

                      crossAxisSpacing: 16,

                      mainAxisSpacing: 16,

                      childAspectRatio: 1.02,

                      children: [

                        quickButton(
                          context,

                          "Health Check",

                          "Theo dõi chỉ số",

                          Icons.monitor_heart,

                          Colors.red,

                          const HealthInputScreen(),
                        ),

                        quickButton(
                          context,

                          "Lịch sử",

                          "Xem kết quả cũ",

                          Icons.history,

                          Colors.orange,

                          const HistoryScreen(),
                        ),

                        quickButton(
                          context,

                          "Calories",

                          "Tính calories",

                          Icons.local_fire_department,

                          Colors.deepOrange,

                          const CalorieScreen(),
                        ),

                        quickButton(
                          context,

                          "Hồ sơ",

                          "Thông tin cá nhân",

                          Icons.person,

                          Colors.blue,

                          const ProfileScreen(),
                        ),

                        /// STEP
                        quickButton(
                          context,

                          "Bước chân",

                          "Theo dõi vận động",

                          Icons.directions_walk,

                          Colors.cyan,

                          const StepScreen(),
                        ),

                        /// SLEEP
                        quickButton(
                          context,

                          "Giấc ngủ",

                          "Theo dõi ngủ nghỉ",

                          Icons.nightlight_round,

                          Colors.deepPurple,

                          const SleepScreen(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}