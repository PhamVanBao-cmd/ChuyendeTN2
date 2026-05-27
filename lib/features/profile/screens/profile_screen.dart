import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  final user =
      FirebaseAuth.instance.currentUser;

  late TextEditingController
  nameController;

  late TextEditingController
  ageController;

  late TextEditingController
  heightController;

  late TextEditingController
  weightController;

  late TextEditingController
  goalController;

  bool darkMode = false;

  bool notification = true;

  File? imageFile;

  String? imageUrl;

  /// ================= SAVE =================
  Future<void> saveProfile() async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      'name',
      nameController.text,
    );

    await prefs.setString(
      'age',
      ageController.text,
    );

    await prefs.setString(
      'height',
      heightController.text,
    );

    await prefs.setString(
      'weight',
      weightController.text,
    );

    await prefs.setString(
      'goal',
      goalController.text,
    );

    await prefs.setBool(
      'darkMode',
      darkMode,
    );

    await prefs.setBool(
      'notification',
      notification,
    );

    if (imageFile != null) {

      await prefs.setString(
        'imagePath',
        imageFile!.path,
      );
    }

    if (imageUrl != null) {

      await prefs.setString(
        'imageUrl',
        imageUrl!,
      );
    }
  }

  /// ================= LOAD =================
  Future<void> loadProfile() async {

    final prefs =
    await SharedPreferences.getInstance();

    nameController.text =
        prefs.getString('name') ??
            user?.displayName ??
            "";

    ageController.text =
        prefs.getString('age') ??
            "20";

    heightController.text =
        prefs.getString('height') ??
            "170";

    weightController.text =
        prefs.getString('weight') ??
            "65";

    goalController.text =
        prefs.getString('goal') ??
            "Duy trì sức khỏe";

    darkMode =
        prefs.getBool('darkMode') ??
            false;

    notification =
        prefs.getBool('notification') ??
            true;

    imageUrl =
        prefs.getString('imageUrl');

    final imagePath =
    prefs.getString('imagePath');

    if (imagePath != null) {

      imageFile =
          File(imagePath);
    }

    setState(() {});
  }

  @override
  void initState() {

    super.initState();

    nameController =
        TextEditingController();

    ageController =
        TextEditingController();

    heightController =
        TextEditingController();

    weightController =
        TextEditingController();

    goalController =
        TextEditingController();

    loadProfile();
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

  /// ================= PICK IMAGE =================
  Future<void> pickImage() async {

    final ImagePicker picker =
    ImagePicker();

    final XFile? pickedFile =
    await picker.pickImage(
      source:
      ImageSource.gallery,
    );

    if (pickedFile == null) {
      return;
    }

    setState(() {

      imageFile =
          File(pickedFile.path);
    });

    await saveProfile();

    await uploadImage();
  }

  /// ================= UPLOAD IMAGE =================
  Future<void> uploadImage() async {

    if (imageFile == null ||
        user == null) {
      return;
    }

    try {

      final ref =
      FirebaseStorage.instance
          .ref()
          .child(
        "profile_images/${user!.uid}.jpg",
      );

      await ref.putFile(
        imageFile!,
      );

      final url =
      await ref.getDownloadURL();

      await user!
          .updatePhotoURL(url);

      setState(() {

        imageUrl = url;
      });

      await saveProfile();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Cập nhật ảnh đại diện thành công",
          ),
        ),
      );

    } catch (e) {

      setState(() {

        imageUrl = null;
      });

      await saveProfile();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Firebase Storage chưa bật.\nĐang dùng ảnh local.",
          ),
        ),
      );
    }
  }

  /// ================= BMI =================
  double get bmi {

    final h =
        double.tryParse(
          heightController.text,
        ) ??
            0;

    final w =
        double.tryParse(
          weightController.text,
        ) ??
            0;

    if (h <= 0) return 0;

    return w /
        ((h / 100) *
            (h / 100));
  }

  /// ================= BMI TEXT =================
  String bmiText() {

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

  /// ================= BMI COLOR =================
  Color bmiColor() {

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

  /// ================= UPDATE PROFILE =================
  Future<void> updateProfile() async {

    await user?.updateDisplayName(
      nameController.text,
    );

    await saveProfile();

    setState(() {});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          "Cập nhật thành công",
        ),
      ),
    );
  }

  /// ================= LOGOUT =================
  Future<void> logout() async {

    await FirebaseAuth.instance
        .signOut();

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder:
            (_) =>
        const LoginScreen(),
      ),

          (route) => false,
    );
  }

  /// ================= STAT ITEM =================
  Widget statItem(
      String value,
      String label,
      IconData icon,
      ) {

    return Column(
      children: [

        Icon(
          icon,
          color: Colors.white,
        ),

        const SizedBox(height: 6),

        Text(
          value,

          style:
          const TextStyle(
            color: Colors.white,

            fontSize: 20,

            fontWeight:
            FontWeight.bold,
          ),
        ),

        Text(
          label,

          style:
          const TextStyle(
            color:
            Colors.white70,
          ),
        ),
      ],
    );
  }

  /// ================= INPUT =================
  Widget customInput(
      TextEditingController
      controller,
      String label,
      IconData icon,
      ) {

    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 16,
      ),

      child: TextField(
        controller: controller,

        onChanged: (_) async {

          setState(() {});

          await saveProfile();
        },

        decoration:
        InputDecoration(
          labelText: label,

          prefixIcon:
          Icon(icon),

          filled: true,

          fillColor:
          const Color(
            0xFFF3F5F7,
          ),

          border:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              22,
            ),

            borderSide:
            BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {

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
          "Hồ sơ cá nhân",
        ),

        actions: [

          IconButton(
            onPressed: logout,

            icon: const Icon(
              Icons.logout,
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
              const EdgeInsets.all(
                25,
              ),

              decoration:
              BoxDecoration(
                gradient:
                const LinearGradient(
                  colors: [

                    Color(
                      0xFF6A11CB,
                    ),

                    Color(
                      0xFF2575FC,
                    ),
                  ],

                  begin:
                  Alignment.topLeft,

                  end:
                  Alignment
                      .bottomRight,
                ),

                borderRadius:
                BorderRadius.circular(
                  35,
                ),

                boxShadow: const [

                  BoxShadow(
                    color:
                    Colors.black26,

                    blurRadius: 12,

                    offset:
                    Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                children: [

                  /// AVATAR
                  GestureDetector(
                    onTap: pickImage,

                    child: Stack(
                      children: [

                        Container(
                          decoration:
                          BoxDecoration(
                            shape:
                            BoxShape.circle,

                            boxShadow: [

                              BoxShadow(
                                color:
                                Colors.white
                                    .withOpacity(
                                  0.5,
                                ),

                                blurRadius:
                                20,
                              ),
                            ],
                          ),

                          child:
                          CircleAvatar(
                            radius: 55,

                            backgroundColor:
                            Colors.white,

                            backgroundImage:
                            imageFile != null
                                ? FileImage(
                              imageFile!,
                            )
                                : (imageUrl !=
                                null
                                ? NetworkImage(
                              imageUrl!,
                            )
                                : null)
                            as ImageProvider?,

                            child:
                            imageFile ==
                                null &&
                                imageUrl ==
                                    null
                                ? Text(
                              (nameController.text
                                  .isNotEmpty)
                                  ? nameController
                                  .text[0]
                                  : "U",

                              style:
                              const TextStyle(
                                fontSize:
                                40,

                                fontWeight:
                                FontWeight.bold,

                                color:
                                Colors.blue,
                              ),
                            )
                                : null,
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,

                          child:
                          Container(
                            padding:
                            const EdgeInsets.all(
                              8,
                            ),

                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white,

                              borderRadius:
                              BorderRadius.circular(
                                50,
                              ),
                            ),

                            child:
                            const Icon(
                              Icons
                                  .camera_alt,

                              color:
                              Colors.blue,

                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  /// NAME
                  Text(
                    nameController.text
                        .isNotEmpty
                        ? nameController.text
                        : "Người dùng",

                    style:
                    const TextStyle(
                      color:
                      Colors.white,

                      fontSize: 25,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  /// EMAIL
                  Text(
                    user?.email ?? "",

                    style:
                    const TextStyle(
                      color:
                      Colors.white70,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  /// STATS
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,

                    children: [

                      statItem(
                        "7200",
                        "Steps",
                        Icons
                            .directions_walk,
                      ),

                      statItem(
                        "1800",
                        "Calories",
                        Icons
                            .local_fire_department,
                      ),

                      statItem(
                        "2.1L",
                        "Water",
                        Icons
                            .water_drop,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ================= PROFILE FORM =================
            customInput(
              nameController,
              "Tên",
              Icons.person,
            ),

            customInput(
              ageController,
              "Tuổi",
              Icons.cake,
            ),

            customInput(
              heightController,
              "Chiều cao (cm)",
              Icons.height,
            ),

            customInput(
              weightController,
              "Cân nặng (kg)",
              Icons.monitor_weight,
            ),

            customInput(
              goalController,
              "Mục tiêu",
              Icons.flag,
            ),

            const SizedBox(height: 20),

            /// BMI
            Container(
              width: double.infinity,

              padding:
              const EdgeInsets.all(20),

              decoration:
              BoxDecoration(
                color: bmiColor(),

                borderRadius:
                BorderRadius.circular(
                  25,
                ),
              ),

              child: Column(
                children: [

                  const Text(
                    "BMI",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    bmi.toStringAsFixed(1),

                    style:
                    const TextStyle(
                      color:
                      Colors.white,

                      fontSize: 38,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  Text(
                    bmiText(),

                    style:
                    const TextStyle(
                      color:
                      Colors.white70,

                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed:
                updateProfile,

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.blue,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                child: const Text(
                  "Lưu hồ sơ",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 18,
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