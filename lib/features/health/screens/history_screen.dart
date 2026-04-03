import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Lịch sử")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('health')
            .where('userId', isEqualTo: user!.uid) // 🔥 lọc user
            .orderBy('time', descending: true)
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

              final time = (data['time'] as Timestamp).toDate();
              final formatted =
              DateFormat('dd/MM/yyyy HH:mm').format(time);

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("BMI: ${data['bmi'].toStringAsFixed(2)}"),
                  subtitle: Text(
                      "Ngày: $formatted\nTim: ${data['heartRate']} bpm"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}