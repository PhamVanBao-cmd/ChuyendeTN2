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
  List<FlSpot> spots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("❌ CHƯA LOGIN");
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('health')
          .where('userId', isEqualTo: user.uid)
          .orderBy('time')
          .get();

      print("🔥 SỐ DATA: ${snapshot.docs.length}");

      List<FlSpot> temp = [];

      for (int i = 0; i < snapshot.docs.length; i++) {
        final data = snapshot.docs[i].data();

        double bmi = (data['bmi'] ?? 0).toDouble();

        print("👉 BMI: $bmi");

        temp.add(FlSpot(i.toDouble(), bmi));
      }

      setState(() {
        spots = temp;
        isLoading = false;
      });
    } catch (e) {
      print("❌ LỖI CHART: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biểu đồ sức khỏe")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : spots.isEmpty
          ? const Center(child: Text("Không có dữ liệu 😢"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),

            /// 📊 trục
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),

            /// 📈 line giống Google Fit
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 4,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}