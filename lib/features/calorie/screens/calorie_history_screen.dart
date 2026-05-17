import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalorieHistoryScreen extends StatelessWidget {
  const CalorieHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Lịch sử Calories"),
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('calories')
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

            padding: const EdgeInsets.all(16),

            itemCount: docs.length,

            itemBuilder: (context, index) {

              final data = docs[index];

              return Card(

                margin: const EdgeInsets.only(bottom: 14),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),

                child: ListTile(

                  contentPadding: const EdgeInsets.all(14),

                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                  ),

                  title: Text(
                    "${data['calories'].toStringAsFixed(0)} kcal",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 6),

                      Text(
                        "Giới tính: ${data['gender']}",
                      ),

                      Text(
                        "Hoạt động: ${data['activity']}",
                      ),

                      Text(
                        "Cân nặng: ${data['weight']} kg",
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
}