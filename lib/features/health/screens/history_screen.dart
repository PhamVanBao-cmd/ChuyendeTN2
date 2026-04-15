import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Lịch sử sức khỏe")),

      body: user == null
          ? const Center(child: Text("❌ Chưa đăng nhập"))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('health')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Chưa có dữ liệu"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("BMI: ${d['bmi'].toStringAsFixed(2)}"),
                  subtitle: Text(
                    "HA: ${d['systolic']}/${d['diastolic']} mmHg\n"
                        "Tim: ${d['heartRate']} bpm\n"
                        "Đường: ${d['bloodSugar']} mg/dL",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}