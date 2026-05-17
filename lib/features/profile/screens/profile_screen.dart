import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final user = FirebaseAuth.instance.currentUser;

  late TextEditingController nameController;

  late TextEditingController ageController;

  late TextEditingController heightController;

  late TextEditingController weightController;

  late TextEditingController goalController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: user?.displayName ?? "",
    );

    ageController = TextEditingController(
      text: "20",
    );

    heightController = TextEditingController(
      text: "170",
    );

    weightController = TextEditingController(
      text: "65",
    );

    goalController = TextEditingController(
      text: "Duy trì sức khỏe",
    );
  }

  @override
  void dispose() {

    nameController.dispose();

    ageController.dispose();

    heightController.dispose();

    weightController.dispose();

    goalController.dispose();

    super.dispose();
  }

  /// ================= BMI =================
  double get bmi {

    final heightText =
    heightController.text.isEmpty
        ? "0"
        : heightController.text;

    final weightText =
    weightController.text.isEmpty
        ? "0"
        : weightController.text;

    final h =
        double.tryParse(heightText) ?? 0;

    final w =
        double.tryParse(weightText) ?? 0;

    if (h <= 0) return 0;

    return w / ((h / 100) * (h / 100));
  }

  /// ================= BMI TEXT =================
  String bmiText() {

    if (bmi < 18.5) return "Thiếu cân";

    if (bmi < 25) {
      return "Bình thường";
    }

    if (bmi < 30) {
      return "Thừa cân";
    }

    return "Béo phì";
  }

  /// ================= BMI COLOR =================
  Color bmiColor() {

    if (bmi < 18.5) return Colors.blue;

    if (bmi < 25) {
      return Colors.green;
    }

    if (bmi < 30) {
      return Colors.orange;
    }

    return Colors.red;
  }

  /// ================= UPDATE PROFILE =================
  Future<void> updateProfile() async {

    await user?.updateDisplayName(
      nameController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cập nhật thành công"),
      ),
    );

    setState(() {});
  }

  /// ================= LOGOUT =================
  Future<void> logout() async {

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),

          (route) => false,
    );
  }

  /// ================= INFO CARD =================
  Widget infoCard(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

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
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= INPUT =================
  Widget customInput(
      TextEditingController controller,
      String label,
      IconData icon,
      ) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextField(
        controller: controller,

        onChanged: (_) {
          setState(() {});
        },

        decoration: InputDecoration(
          labelText: label,

          prefixIcon: Icon(icon),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),
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
          "Hồ sơ cá nhân",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ================= PROFILE HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4facfe),
                    Color(0xFF00f2fe),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(30),
              ),

              child: Column(
                children: [

                  /// AVATAR
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,

                    child: Text(
                      (user?.displayName != null &&
                          user!.displayName!.isNotEmpty)
                          ? user!.displayName![0]
                          : "U",

                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// NAME
                  Text(
                    user?.displayName?.isNotEmpty == true
                        ? user!.displayName!
                        : "Người dùng",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  /// EMAIL
                  Text(
                    user?.email ?? "",

                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= BMI CARD =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: bmiColor(),

                borderRadius:
                BorderRadius.circular(25),
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 45,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    bmi == 0
                        ? "--"
                        : bmi.toStringAsFixed(1),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    bmi == 0
                        ? "Chưa có dữ liệu"
                        : bmiText(),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= BODY INFO =================
            infoCard(
              Icons.cake,
              "Tuổi",
              "${ageController.text} tuổi",
              Colors.orange,
            ),

            infoCard(
              Icons.height,
              "Chiều cao",
              "${heightController.text} cm",
              Colors.blue,
            ),

            infoCard(
              Icons.monitor_weight,
              "Cân nặng",
              "${weightController.text} kg",
              Colors.green,
            ),

            infoCard(
              Icons.flag,
              "Mục tiêu",
              goalController.text,
              Colors.purple,
            ),

            const SizedBox(height: 10),

            /// ================= EDIT SECTION =================
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

              child: Column(
                children: [

                  const Row(
                    children: [

                      Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Chỉnh sửa thông tin",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  customInput(
                    nameController,
                    "Tên hiển thị",
                    Icons.person,
                  ),

                  customInput(
                    ageController,
                    "Tuổi",
                    Icons.cake,
                  ),

                  customInput(
                    heightController,
                    "Chiều cao",
                    Icons.height,
                  ),

                  customInput(
                    weightController,
                    "Cân nặng",
                    Icons.monitor_weight,
                  ),

                  customInput(
                    goalController,
                    "Mục tiêu sức khỏe",
                    Icons.flag,
                  ),

                  const SizedBox(height: 10),

                  /// UPDATE BUTTON
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: updateProfile,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.blue,

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(
                        "Cập nhật",

                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= LOGOUT =================
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: logout,

                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),

                label: const Text(
                  "Đăng xuất",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
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