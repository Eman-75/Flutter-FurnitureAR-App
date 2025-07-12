import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Future<Map<int, double>> fetchWeeklySales() async {
  Map<int, double> salesData = {
    1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0,
  };

  QuerySnapshot orders = await FirebaseFirestore.instance
      .collection('Orders')
      .orderBy('CREATED_AT', descending: true)
      .get();

  DateTime now = DateTime.now();
  DateTime monday = now.subtract(Duration(days: now.weekday - 1));

  for (var doc in orders.docs) {
    Timestamp ts = doc['CREATED_AT'];
    DateTime date = ts.toDate();

    if (date.isBefore(monday)) continue;

    int weekday = date.weekday;
    if (weekday >= 1 && weekday <= 6) {
      double price = (doc['totalPrice'] ?? 0).toDouble();
      salesData[weekday] = salesData[weekday]! + price;
    }
  }

  return salesData;
}

Widget LineGraph() {
  return FutureBuilder<Map<int, double>>(
    future: fetchWeeklySales(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      final salesData = snapshot.data!;
      final spots = salesData.entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
          .where((spot) => spot.y > 0) // filter out 0 sales
          .toList()
        ..sort((a, b) => a.x.compareTo(b.x));

      // ✅ If no orders this week
      if (spots.isEmpty) {
        // 👇 Provide dummy data for demo
        spots.addAll([
          FlSpot(1, 50),
          FlSpot(2, 70),
          FlSpot(3, 30),
          FlSpot(4, 80),
          FlSpot(5, 50),
          FlSpot(6, 90),
        ]);

      }

      return Padding(
        padding: EdgeInsets.only(right: 30, top: 20, left: 20),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 1: return Text('Mon');
                        case 2: return Text('Tue');
                        case 3: return Text('Wed');
                        case 4: return Text('Thu');
                        case 5: return Text('Fri');
                        case 6: return Text('Sat');
                        default: return SizedBox.shrink();
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 10,
                    getTitlesWidget: (value, meta) =>
                        Text('${value.toInt()}'),
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.green.shade800,
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withOpacity(0.2),
                  ),
                  spots: spots,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

