import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example data for the chart
    final List<Map<String, dynamic>> data = [
      {'value': 10.0},
      {'value': 20.0},
      {'value': 30.0},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Text('Item ${entry.key + 1}'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 20,
                      color: Colors.blueAccent,
                      width: entry.value['value'] * 10, // Adjust the width based on the value
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('${entry.value['value']}'),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}