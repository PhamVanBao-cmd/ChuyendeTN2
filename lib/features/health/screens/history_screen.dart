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

      /// 🔥 APPBAR
      appBar: AppBar(
        title: const Text("Lịch sử sức khỏe"),
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

      /// 🔥 BODY FIX KHÔNG BỊ GIÃN
      body: user == null
          ? const Center(child: Text("❌ Chưa đăng nhập"))
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
                  child: Text("Chưa có dữ liệu"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final d = docs[i];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF56CCF2),
                          Color(0xFF2F80ED)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                        )
                      ],
                    ),

                    /// 🔥 CARD CONTENT
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 📅 TIME
                        if (d['createdAt'] != null)
                          Text(
                            (d['createdAt'] as Timestamp)
                                .toDate()
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),

                        const SizedBox(height: 8),

                        /// ❤️ BMI
                        Text(
                          "BMI: ${d['bmi'].toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// 📊 INFO
                        Text(
                          "Huyết áp: ${d['systolic']}/${d['diastolic']} mmHg",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Nhịp tim: ${d['heartRate']} bpm",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Đường huyết: ${d['bloodSugar']} mg/dL",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Cholesterol: ${d['cholesterol']} mg/dL",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
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
}