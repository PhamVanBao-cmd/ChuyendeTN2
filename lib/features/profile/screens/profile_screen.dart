import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    nameController.text = user?.displayName ?? "";
  }

  /// 🔥 UPDATE NAME
  Future<void> updateProfile() async {
    await user?.updateDisplayName(nameController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cập nhật thành công")),
    );

    setState(() {});
  }

  /// 🔥 LOGOUT
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  Widget infoRow(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ cá nhân")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 👤 AVATAR
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),

            const SizedBox(height: 20),

            /// 📧 EMAIL
            infoRow("Email", user?.email ?? ""),

            /// 📝 NAME INPUT
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Tên hiển thị"),
            ),

            const SizedBox(height: 20),

            /// UPDATE
            ElevatedButton(
              onPressed: updateProfile,
              child: const Text("Cập nhật"),
            ),

            const SizedBox(height: 10),

            /// LOGOUT
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: logout,
              child: const Text("Đăng xuất"),
            )
          ],
        ),
      ),
    );
  }
}