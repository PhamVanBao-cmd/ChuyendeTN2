import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String filter = "all";

  Stream<QuerySnapshot> getData() {
    final user = FirebaseAuth.instance.currentUser;

    Query query = FirebaseFirestore.instance
        .collection('health')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('time', descending: false);

    return query.snapshots();
  }

  List<FlSpot> buildSpots(List docs, String field) {
    List<FlSpot> spots = [];

    for (int i = 0; i < docs.length; i++) {
      double value = (docs[i][field] ?? 0).toDouble();
      spots.add(FlSpot(i.toDouble(), value));
    }

    return spots;
  }

  Widget buildChart(List docs) {
    final bmiSpots = buildSpots(docs, 'bmi');
    final heartSpots = buildSpots(docs, 'heartRate');
    final sugarSpots = buildSpots(docs, 'bloodSugar');

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),

        titlesData: FlTitlesData(show: true),

        lineBarsData: [
          LineChartBarData(
            spots: bmiSpots,
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: heartSpots,
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: sugarSpots,
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  List filterData(List docs) {
    if (filter == "7") {
      return docs.take(7).toList();
    }
    if (filter == "30") {
      return docs.take(30).toList();
    }
    return docs;
  }

  Widget buildFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        filterBtn("7 ngày", "7"),
        filterBtn("30 ngày", "30"),
        filterBtn("Tất cả", "all"),
      ],
    );
  }

  Widget filterBtn(String text, String value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          filter = value;
        });
      },
      child: Text(text),
    );
  }

  Widget buildLegend() {
    return Column(
      children: const [
        Text("BMI"),
        Text("Nhịp tim"),
        Text("Đường huyết"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biểu đồ sức khỏe")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          buildFilter(),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = filterData(snapshot.data!.docs);

                if (docs.isEmpty) {
                  return const Center(child: Text("Chưa có dữ liệu"));
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(child: buildChart(docs)),
                      const SizedBox(height: 10),
                      buildLegend(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}