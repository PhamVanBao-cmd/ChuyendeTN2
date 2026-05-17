import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../dashboard/screens/dashboard_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      /// ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Lịch sử sức khỏe",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DashboardScreen(),
              ),
            );
          },
        ),
      ),

      /// ================= BODY =================
      body: user == null
          ? const Center(
        child: Text("❌ Chưa đăng nhập"),
      )
          : Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),

          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('health')
                .orderBy('createdAt', descending: true)
                .snapshots(),

            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Chưa có dữ liệu 😢",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,

                itemBuilder: (_, i) {

                  final d = docs[i];

                  final bmi =
                  (d['bmi'] ?? 0).toDouble();

                  final sys =
                      int.tryParse(d['systolic'].toString()) ?? 0;

                  final dia =
                      int.tryParse(d['diastolic'].toString()) ?? 0;

                  final hr =
                      int.tryParse(d['heartRate'].toString()) ?? 0;

                  final sugar =
                      double.tryParse(d['bloodSugar'].toString()) ?? 0;

                  final chol =
                      double.tryParse(d['cholesterol'].toString()) ?? 0;

                  final weight =
                      double.tryParse(d['weight'].toString()) ?? 0;

                  final height =
                      double.tryParse(d['height'].toString()) ?? 0;

                  return GestureDetector(

                    /// ================= DETAIL =================
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,

                        builder: (_) {
                          return Container(
                            padding: const EdgeInsets.all(20),

                            decoration: const BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),

                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  /// HANDLE
                                  Center(
                                    child: Container(
                                      width: 60,
                                      height: 6,

                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  /// TITLE
                                  const Text(
                                    "Chi tiết lần đo",

                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  /// BMI CARD
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),

                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          getBMIColor(bmi)
                                              .withOpacity(0.7),
                                          getBMIColor(bmi),
                                        ],
                                      ),

                                      borderRadius:
                                      BorderRadius.circular(25),
                                    ),

                                    child: Column(
                                      children: [

                                        const Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: 50,
                                        ),

                                        const SizedBox(height: 10),

                                        Text(
                                          bmi.toStringAsFixed(1),

                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),

                                        Text(
                                          getBMIText(bmi),

                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 25),

                                  /// ================= HEALTH SCORE =================
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),

                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius:
                                      BorderRadius.circular(25),
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                      children: [

                                        const Text(
                                          "Đánh giá sức khỏe",

                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        healthScoreItem(
                                          "BMI",
                                          bmi < 25 ? 90 : 65,
                                          getBMIColor(bmi),
                                        ),

                                        const SizedBox(height: 15),

                                        healthScoreItem(
                                          "Huyết áp",
                                          sys < 120 ? 95 : 70,
                                          Colors.red,
                                        ),

                                        const SizedBox(height: 15),

                                        healthScoreItem(
                                          "Nhịp tim",
                                          hr <= 100 ? 92 : 60,
                                          Colors.pink,
                                        ),

                                        const SizedBox(height: 15),

                                        healthScoreItem(
                                          "Đường huyết",
                                          sugar < 140 ? 90 : 55,
                                          Colors.deepPurple,
                                        ),

                                        const SizedBox(height: 15),

                                        healthScoreItem(
                                          "Cholesterol",
                                          chol < 200 ? 88 : 60,
                                          Colors.cyan,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  /// ================= DETAIL INFO =================
                                  detailTile(
                                    Icons.monitor_weight,
                                    "Cân nặng",
                                    "$weight kg",
                                    Colors.orange,
                                  ),

                                  detailTile(
                                    Icons.height,
                                    "Chiều cao",
                                    "$height cm",
                                    Colors.blue,
                                  ),

                                  detailTile(
                                    Icons.favorite,
                                    "Huyết áp",
                                    "$sys / $dia mmHg",
                                    Colors.red,
                                  ),

                                  detailTile(
                                    Icons.monitor_heart,
                                    "Nhịp tim",
                                    "$hr bpm",
                                    Colors.pink,
                                  ),

                                  detailTile(
                                    Icons.bloodtype,
                                    "Đường huyết",
                                    "$sugar mg/dL",
                                    Colors.deepPurple,
                                  ),

                                  detailTile(
                                    Icons.water_drop,
                                    "Cholesterol",
                                    "$chol mg/dL",
                                    Colors.cyan,
                                  ),

                                  const SizedBox(height: 20),

                                  /// ================= DATE =================
                                  Container(
                                    width: double.infinity,
                                    padding:
                                    const EdgeInsets.all(16),

                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,

                                      borderRadius:
                                      BorderRadius.circular(18),
                                    ),

                                    child: Row(
                                      children: [

                                        const Icon(
                                          Icons.access_time,
                                        ),

                                        const SizedBox(width: 10),

                                        Expanded(
                                          child: Text(
                                            d['createdAt'] != null
                                                ? (d['createdAt']
                                            as Timestamp)
                                                .toDate()
                                                .toString()
                                                : "",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },

                    /// ================= CARD =================
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(

                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF4facfe),
                            Color(0xFF00f2fe),
                          ],
                        ),

                        borderRadius: BorderRadius.circular(25),

                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                          ),
                        ],
                      ),

                      child: Row(
                        children: [

                          /// ICON
                          Container(
                            padding: const EdgeInsets.all(14),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                              BorderRadius.circular(18),
                            ),

                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 15),

                          /// INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  "BMI: ${bmi.toStringAsFixed(1)}",

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  getBMIText(bmi),

                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Huyết áp: $sys/$dia",

                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ARROW
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// ================= SCORE ITEM =================
  Widget healthScoreItem(
      String title,
      int score,
      Color color,
      ) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            Text(
              title,

              style: const TextStyle(
                fontWeight: FontWeight.bold,
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
            backgroundColor: Colors.grey.shade300,
            valueColor:
            AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  /// ================= DETAIL TILE =================
  Widget detailTile(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [

          CircleAvatar(
            backgroundColor:
            color.withOpacity(0.15),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
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

  /// ================= BMI TEXT =================
  String getBMIText(double bmi) {
    if (bmi < 18.5) return "Thiếu cân";
    if (bmi < 25) return "Bình thường";
    if (bmi < 30) return "Thừa cân";
    return "Béo phì";
  }

  /// ================= BMI COLOR =================
  Color getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}