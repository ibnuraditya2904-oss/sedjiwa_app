import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/models/monitoring_user.dart';

class MonitoringDetailPage extends StatelessWidget {
  final MonitoringUser user;

  const MonitoringDetailPage({
    super.key,
    required this.user,
  });

  static const _bg = Color(0xFFAED9D7);
  static const _cardBg = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  Widget _section({
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _border,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 3),
            color: Color(0x12000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 240,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 50,
          sectionsSpace: 4,
          sections: [
            PieChartSectionData(
              value: user.depression.toDouble(),
              color: Colors.red,
              title: "${user.depression}",
              radius: 70,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              value: user.anxiety.toDouble(),
              color: Colors.orange,
              title: "${user.anxiety}",
              radius: 70,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              value: user.stress.toDouble(),
              color: Colors.blue,
              title: "${user.stress}",
              radius: 70,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Row(
          children: [
            Icon(Icons.circle, color: Colors.red, size: 12),
            SizedBox(width: 6),
            Text("Depression"),
          ],
        ),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.orange, size: 12),
            SizedBox(width: 6),
            Text("Anxiety"),
          ],
        ),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.blue, size: 12),
            SizedBox(width: 6),
            Text("Stress"),
          ],
        ),
      ],
    );
  }

  Widget _scoreCard(
    String title,
    String score,
    Color color,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            score,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _resultColor() {
    switch (user.result.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    final resultColor = _resultColor();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _section(
              title: "Profil User",
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.name),
                    subtitle: const Text("Nama"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cake),
                    title: Text("${user.age} Tahun"),
                    subtitle: const Text("Umur"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: Text(user.gender),
                    subtitle: const Text("Gender"),
                  ),
                ],
              ),
            ),
            _section(
              title: "Hasil DASS-21 Terakhir",
              child: Column(
                children: [
                  _buildPieChart(),
                  const SizedBox(height: 12),
                  _legend(),
                  const SizedBox(height: 12),
                  Text(
                    "Tes Terakhir: ${user.lastTest}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _section(
              title: "Ringkasan Hasil",
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _scoreCard(
                    "Depression",
                    user.depression.toString(),
                    Colors.red,
                  ),
                  _scoreCard(
                    "Anxiety",
                    user.anxiety.toString(),
                    Colors.orange,
                  ),
                  _scoreCard(
                    "Stress",
                    user.stress.toString(),
                    Colors.blue,
                  ),
                ],
              ),
            ),
            _section(
              title: "Kesimpulan",
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: resultColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: resultColor,
                    ),
                  ),
                  child: Text(
                    user.result,
                    style: TextStyle(
                      color: resultColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            _section(
              title: "Riwayat Tes",
              child: Column(
                children: user.history.map((e) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.history),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(e.result),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            _section(
              title: "Aktivitas Logbook",
              child: Column(
                children: user.logbooks.map((e) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _border,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
