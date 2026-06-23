import 'package:flutter/material.dart';

class MonitoringHistory {
  final String date;
  final String result;

  MonitoringHistory({
    required this.date,
    required this.result,
  });
}

class MonitoringUser {
  final String name;
  final int age;
  final String gender;

  final int depression;
  final int anxiety;
  final int stress;

  final String result;
  final String lastTest;

  final List<String> logbooks;
  final List<MonitoringHistory> history;

  MonitoringUser({
    required this.name,
    required this.age,
    required this.gender,
    required this.depression,
    required this.anxiety,
    required this.stress,
    required this.result,
    required this.lastTest,
    required this.logbooks,
    required this.history,
  });

  Color get resultColor {
    switch (result.toLowerCase()) {
      case "resiko tinggi":
        return Colors.red;
      case "resiko sedang":
        return Colors.orange;
      case "resiko rendah":
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  static List<MonitoringUser> dummyData = [
    MonitoringUser(
      name: "Ibnu",
      age: 23,
      gender: "Laki-laki",
      depression: 10,
      anxiety: 18,
      stress: 14,
      result: "Resiko Sedang",
      lastTest: "20 Juni 2026 09:30",
      logbooks: [
        "Olahraga pagi 30 menit",
        "Meditasi 10 menit",
        "Tidur 8 jam",
      ],
      history: [
        MonitoringHistory(
          date: "20 Juni 2026 09:30",
          result: "Resiko Sedang",
        ),
        MonitoringHistory(
          date: "10 Juni 2026 08:10",
          result: "Resiko Rendah",
        ),
      ],
    ),
  ];
}
