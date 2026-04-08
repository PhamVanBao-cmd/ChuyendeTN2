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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('health')
            .where('userId', isEqualTo: user!.uid) // 🔥 lọc user
            .orderBy('time', descending: true) // 🔥 mới nhất trước
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
            itemBuilder: (context, index) {
              final data = docs[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("BMI: ${data['bmi'].toStringAsFixed(2)}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Huyết áp: ${data['systolic']}/${data['diastolic']}"),
                      Text("Nhịp tim: ${data['heartRate']}"),
                      Text("Đường: ${data['bloodSugar']}"),
                      Text("Mỡ máu: ${data['cholesterol']}"),
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
}