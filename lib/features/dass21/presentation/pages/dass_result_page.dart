// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:sedjiwa_app/core/router/routes.dart';
import '../../data/models/activity_model.dart';

class DassResultData {
  final int depressionScore;
  final int anxietyScore;
  final int stressScore;

  final String depressionLabel;
  final String anxietyLabel;
  final String stressLabel;
  final String overallLabel;

  const DassResultData({
    required this.depressionScore,
    required this.anxietyScore,
    required this.stressScore,
    required this.depressionLabel,
    required this.anxietyLabel,
    required this.stressLabel,
    required this.overallLabel,
  });
}

class DassResultPage extends StatefulWidget {
  final DassResultData data;

  const DassResultPage({super.key, required this.data});

  @override
  State<DassResultPage> createState() => _DassResultPageState();
}

class _DassResultPageState extends State<DassResultPage> {
  static const _bg = Color(0xFFAED9D7);
  static const _card = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  int touchedIndex = -1;

  List<Activity> _generateActivities(DassResultData data) {
    return [
      Activity(
        id: "1",
        title: "Latihan Pernapasan",
        description: "Tarik napas dalam selama 5 menit",
        tags: ["stres"],
      ),
      Activity(
        id: "2",
        title: "Jalan Santai",
        description: "Berjalan santai 10-15 menit",
        tags: ["ringan"],
      ),
      Activity(
        id: "3",
        title: "Dengarkan Musik",
        description: "Putar musik yang menenangkan",
        tags: ["relax"],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final activities = _generateActivities(data);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            children: [
              /// 🔙 BACK
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  ),
                  const Spacer(),
                  const Text(
                    "Hasil Tes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  children: [
                    Text(
                      data.overallLabel,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Berdasarkan hasil tes yang telah kamu lakukan,\n"
                      "kondisi emosional kamu berada pada kategori di atas.\n"
                      "Hasil ini bukan diagnosis, tetapi gambaran kondisi saat ini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Visualisasi Kondisi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              setState(() {
                                touchedIndex = response
                                        ?.touchedSection?.touchedSectionIndex ??
                                    -1;
                              });
                            },
                          ),
                          sections: _buildSections(data),
                        ),
                        swapAnimationDuration:
                            const Duration(milliseconds: 800),
                        swapAnimationCurve: Curves.easeInOut,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _Legend(color: Colors.blue, text: "Depresi"),
                        _Legend(color: Colors.orange, text: "Kecemasan"),
                        _Legend(color: Colors.red, text: "Stress"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              _buildButton(
                text: "Lihat Rekomendasi Adaptif",
                onTap: () {
                  context.push(
                    AppRoutes.adaptiveRecommendation,
                    extra: activities,
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildButton(
                text: "Lihat Edukasi",
                onTap: () {
                  context.push(
                    AppRoutes.education,
                    extra: data.overallLabel,
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildButton(
                text: "Kembali ke Beranda",
                onTap: () {
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(DassResultData data) {
    final total = data.depressionScore + data.anxietyScore + data.stressScore;

    final values = [
      data.depressionScore,
      data.anxietyScore,
      data.stressScore,
    ];

    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.red,
    ];

    return List.generate(3, (i) {
      final percent = total == 0 ? 0 : (values[i] / total * 100);

      final isTouched = i == touchedIndex;
      final radius = isTouched ? 70.0 : 60.0;

      return PieChartSectionData(
        color: colors[i],
        value: values[i].toDouble(),
        radius: radius,
        title: "${percent.toStringAsFixed(0)}%",
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _card,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: _border, width: 1.2),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
