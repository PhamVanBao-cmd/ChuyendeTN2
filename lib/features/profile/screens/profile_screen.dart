import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 100),

            const SizedBox(height: 10),

            Text(user?.email ?? ""),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              },
              child: const Text("Đăng xuất"),
            )
          ],
        ),
      ),
    );
  }
}