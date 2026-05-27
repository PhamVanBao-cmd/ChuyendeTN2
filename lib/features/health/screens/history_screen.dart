import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../dashboard/screens/dashboard_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen> {

  final List<String> selectedDocs = [];

  /// ================= DELETE =================
  Future<void> deleteSelected() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    for (String id in selectedDocs) {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('health')
          .doc(id)
          .delete();
    }

    setState(() {
      selectedDocs.clear();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Đã xóa dữ liệu đã chọn",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        Colors.white,

        foregroundColor:
        Colors.black,

        title: Text(

          selectedDocs.isEmpty
              ? "Lịch sử sức khỏe"
              : "${selectedDocs.length} đã chọn",

          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(

          icon: Icon(

            selectedDocs.isEmpty
                ? Icons.arrow_back
                : Icons.close,
          ),

          onPressed: () {

            if (selectedDocs.isNotEmpty) {

              setState(() {
                selectedDocs.clear();
              });

            } else {

              Navigator.pushReplacement(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                  const DashboardScreen(),
                ),
              );
            }
          },
        ),

        actions: [

          if (selectedDocs.isNotEmpty)

            IconButton(

              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),

              onPressed: () async {

                final confirm =
                await showDialog<bool>(

                  context: context,

                  builder: (_) {

                    return AlertDialog(

                      title: const Text(
                        "Xóa dữ liệu?",
                      ),

                      content: Text(
                        "Bạn muốn xóa ${selectedDocs.length} mục?",
                      ),

                      actions: [

                        TextButton(

                          onPressed: () {

                            Navigator.pop(
                              context,
                              false,
                            );
                          },

                          child: const Text(
                            "Hủy",
                          ),
                        ),

                        ElevatedButton(

                          onPressed: () {

                            Navigator.pop(
                              context,
                              true,
                            );
                          },

                          child: const Text(
                            "Xóa",
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  deleteSelected();
                }
              },
            ),
        ],
      ),

      body: user == null

          ? const Center(
        child: Text(
          "❌ Chưa đăng nhập",
        ),
      )

          : StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('health')
            .orderBy(
          'createdAt',
          descending: true,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final docs =
              snapshot.data!.docs;

          if (docs.isEmpty) {

            return const Center(
              child: Text(
                "Chưa có dữ liệu 😢",
              ),
            );
          }

          return ListView.builder(

            padding:
            const EdgeInsets.all(16),

            itemCount: docs.length,

            itemBuilder: (_, i) {

              final d = docs[i];

              final data =
              d.data()
              as Map<String, dynamic>;

              final isSelected =
              selectedDocs.contains(
                d.id,
              );

              final type =
                  data['type'] ?? 'bmi';

              final bmi =
              (data['bmi'] ?? 0)
                  .toDouble();

              final calories =
              (data['calories'] ?? 0)
                  .toDouble();

              final sys =
                  int.tryParse(
                    data['systolic']
                        ?.toString() ??
                        '0',
                  ) ??
                      0;

              final dia =
                  int.tryParse(
                    data['diastolic']
                        ?.toString() ??
                        '0',
                  ) ??
                      0;

              final hr =
                  int.tryParse(
                    data['heartRate']
                        ?.toString() ??
                        '0',
                  ) ??
                      0;

              final sugar =
                  double.tryParse(
                    data['bloodSugar']
                        ?.toString() ??
                        '0',
                  ) ??
                      0;

              final chol =
                  double.tryParse(
                    data['cholesterol']
                        ?.toString() ??
                        '0',
                  ) ??
                      0;

              final weight =
                  double.tryParse(
                    data['weight']
                        ?.toString() ??
                        '0',
                  ) ??
                      0;

              final height =
                  double.tryParse(
                    data['height']
                        ?.toString() ??
                        '0',
                  ) ??
                      0;

              return InkWell(

                borderRadius:
                BorderRadius.circular(
                  25,
                ),

                onLongPress: () {

                  setState(() {

                    if (isSelected) {

                      selectedDocs.remove(
                        d.id,
                      );

                    } else {

                      selectedDocs.add(
                        d.id,
                      );
                    }
                  });
                },

                onTap: () {

                  if (selectedDocs
                      .isNotEmpty) {

                    setState(() {

                      if (isSelected) {

                        selectedDocs
                            .remove(
                          d.id,
                        );

                      } else {

                        selectedDocs
                            .add(
                          d.id,
                        );
                      }
                    });

                    return;
                  }

                  showModalBottomSheet(

                    context: context,

                    isScrollControlled:
                    true,

                    backgroundColor:
                    Colors.transparent,

                    builder: (_) {

                      return Container(

                        padding:
                        const EdgeInsets.all(
                          20,
                        ),

                        decoration:
                        const BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                          BorderRadius.vertical(
                            top:
                            Radius.circular(
                              30,
                            ),
                          ),
                        ),

                        child:
                        SingleChildScrollView(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              Center(
                                child: Container(

                                  width: 60,
                                  height: 6,

                                  decoration:
                                  BoxDecoration(

                                    color: Colors
                                        .grey
                                        .shade300,

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      10,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Text(

                                type == 'calories'
                                    ? "Chi tiết Calories"
                                    : "Chi tiết sức khỏe",

                                style:
                                const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Container(

                                width:
                                double.infinity,

                                padding:
                                const EdgeInsets
                                    .all(20),

                                decoration:
                                BoxDecoration(

                                  gradient:
                                  LinearGradient(

                                    colors:

                                    type ==
                                        'calories'

                                        ? [

                                      Colors
                                          .orange
                                          .shade300,

                                      Colors
                                          .deepOrange,
                                    ]

                                        : [

                                      getBMIColor(
                                        bmi,
                                      ).withOpacity(
                                        0.7,
                                      ),

                                      getBMIColor(
                                        bmi,
                                      ),
                                    ],
                                  ),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    25,
                                  ),
                                ),

                                child: Column(
                                  children: [

                                    Icon(

                                      type ==
                                          'calories'

                                          ? Icons
                                          .local_fire_department

                                          : Icons
                                          .favorite,

                                      color:
                                      Colors.white,

                                      size: 50,
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Text(

                                      type ==
                                          'calories'

                                          ? calories
                                          .toStringAsFixed(
                                        0,
                                      )

                                          : bmi
                                          .toStringAsFixed(
                                        1,
                                      ),

                                      style:
                                      const TextStyle(

                                        color:
                                        Colors
                                            .white,

                                        fontSize:
                                        40,

                                        fontWeight:
                                        FontWeight
                                            .bold,
                                      ),
                                    ),

                                    Text(

                                      type ==
                                          'calories'

                                          ? "kcal"

                                          : getBMIText(
                                        bmi,
                                      ),

                                      style:
                                      const TextStyle(

                                        color:
                                        Colors
                                            .white,

                                        fontSize:
                                        18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              if (type == 'calories') ...[

                                detailTile(
                                  Icons.flag,
                                  "Mục tiêu",
                                  data['goal']
                                      ?.toString() ??
                                      "",
                                  Colors.orange,
                                ),

                                detailTile(
                                  Icons.directions_run,
                                  "Hoạt động",
                                  data['activity']
                                      ?.toString() ??
                                      "",
                                  Colors.blue,
                                ),

                                detailTile(
                                  Icons.person,
                                  "Giới tính",
                                  data['gender']
                                      ?.toString() ??
                                      "",
                                  Colors.purple,
                                ),
                              ],

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

                              if (type !=
                                  'calories') ...[

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
                              ],

                              const SizedBox(
                                height: 20,
                              ),

                              Container(

                                width:
                                double.infinity,

                                padding:
                                const EdgeInsets
                                    .all(16),

                                decoration:
                                BoxDecoration(

                                  color: Colors
                                      .grey
                                      .shade100,

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    18,
                                  ),
                                ),

                                child: Row(
                                  children: [

                                    const Icon(
                                      Icons
                                          .access_time,
                                    ),

                                    const SizedBox(
                                      width: 10,
                                    ),

                                    Expanded(
                                      child: Text(

                                        data['createdAt']
                                            !=
                                            null

                                            ? (data['createdAt']
                                        as Timestamp)
                                            .toDate()
                                            .toString()

                                            : "",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },

                child: Container(

                  margin:
                  const EdgeInsets.only(
                    bottom: 16,
                  ),

                  padding:
                  const EdgeInsets.all(
                    18,
                  ),

                  decoration: BoxDecoration(

                    border: isSelected

                        ? Border.all(
                      color: Colors.red,
                      width: 3,
                    )

                        : null,

                    gradient:
                    LinearGradient(

                      colors:

                      type == 'calories'

                          ? [
                        Colors.orange,
                        Colors.deepOrange,
                      ]

                          : [
                        const Color(
                          0xFF4facfe,
                        ),
                        const Color(
                          0xFF00f2fe,
                        ),
                      ],
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      25,
                    ),
                  ),

                  child: Row(
                    children: [

                      Container(

                        padding:
                        const EdgeInsets
                            .all(14),

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.white,

                          borderRadius:
                          BorderRadius
                              .circular(
                            18,
                          ),
                        ),

                        child: Icon(

                          type ==
                              'calories'

                              ? Icons
                              .local_fire_department

                              : Icons.favorite,

                          color:

                          type ==
                              'calories'

                              ? Colors.orange

                              : Colors.red,

                          size: 30,
                        ),
                      ),

                      const SizedBox(
                        width: 15,
                      ),

                      Expanded(
                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(

                              type ==
                                  'calories'

                                  ? "Calories: ${calories.toStringAsFixed(0)} kcal"

                                  : "BMI: ${bmi.toStringAsFixed(1)}",

                              style:
                              const TextStyle(

                                color:
                                Colors.white,

                                fontSize:
                                20,

                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(

                              type ==
                                  'calories'

                                  ? "Mục tiêu: ${data['goal'] ?? ''}"

                                  : getBMIText(
                                bmi,
                              ),

                              style:
                              const TextStyle(
                                color: Colors
                                    .white70,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(

                              type ==
                                  'calories'

                                  ? "Hoạt động: ${data['activity'] ?? ''}"

                                  : "Huyết áp: $sys/$dia",

                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      isSelected

                          ? const Icon(
                        Icons.check_circle,
                        color:
                        Colors.white,
                        size: 30,
                      )

                          : const Icon(
                        Icons
                            .arrow_forward_ios,
                        color:
                        Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget detailTile(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.grey.shade100,

        borderRadius:
        BorderRadius.circular(20),
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
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String getBMIText(double bmi) {

    if (bmi < 18.5) {
      return "Thiếu cân";
    }

    if (bmi < 25) {
      return "Bình thường";
    }

    if (bmi < 30) {
      return "Thừa cân";
    }

    return "Béo phì";
  }

  Color getBMIColor(double bmi) {

    if (bmi < 18.5) {
      return Colors.blue;
    }

    if (bmi < 25) {
      return Colors.green;
    }

    if (bmi < 30) {
      return Colors.orange;
    }

    return Colors.red;
  }
}