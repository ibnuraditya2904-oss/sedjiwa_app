// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sedjiwa_app/core/router/routes.dart';
import 'dass_result_page.dart';

class DassTestPage extends StatefulWidget {
  const DassTestPage({super.key});

  @override
  State<DassTestPage> createState() => _DassTestPageState();
}

class _DassTestPageState extends State<DassTestPage> {
  static const _bg = Color(0xFFAED9D7);
  static const _card = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  final PageController _controller = PageController();
  int _index = 0;

  final List<int?> _answers = List<int?>.filled(21, null);

  final List<String> _questions = const [
    "Dalam seminggu terakhir, saya merasa sulit untuk beristirahat.",
    "Dalam seminggu terakhir, saya merasa bibir saya sering kering.",
    "Dalam seminggu terakhir, saya tidak bisa merasakan perasaan positif sama sekali.",
    "Dalam seminggu terakhir, saya mudah mengalami kesulitan bernafas.",
    "Dalam seminggu terakhir, saya sepertinya tidak punya kekuatan.",
    "Dalam seminggu terakhir, saya bereaksi berlebihan.",
    "Dalam seminggu terakhir, saya merasa gemetar.",
    "Dalam seminggu terakhir, saya menghabiskan banyak energi karena cemas.",
    "Dalam seminggu terakhir, saya khawatir akan panik.",
    "Dalam seminggu terakhir, saya tidak ada harapan masa depan.",
    "Dalam seminggu terakhir, saya mudah kesal.",
    "Dalam seminggu terakhir, saya sulit untuk rileks.",
    "Dalam seminggu terakhir, saya merasa sedih.",
    "Dalam seminggu terakhir, saya tidak sabar terhadap gangguan.",
    "Dalam seminggu terakhir, saya hampir panik.",
    "Dalam seminggu terakhir, saya tidak antusias.",
    "Dalam seminggu terakhir, saya merasa tidak berharga.",
    "Dalam seminggu terakhir, saya mudah tersinggung.",
    "Dalam seminggu terakhir, saya sadar detak jantung berubah.",
    "Dalam seminggu terakhir, saya takut tanpa alasan.",
    "Dalam seminggu terakhir, hidup terasa tidak bermakna.",
  ];

  final List<_Option> _options = const [
    _Option(0, "Tidak pernah"),
    _Option(1, "Kadang-kadang"),
    _Option(2, "Sering"),
    _Option(3, "Hampir selalu"),
  ];

  void _selectAnswer(int value) {
    setState(() {
      _answers[_index] = value;
    });

    HapticFeedback.lightImpact();

    Future.delayed(const Duration(milliseconds: 180), () {
      if (_index < 20) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      } else {
        _showSubmitDialog();
      }
    });
  }

  Future<void> _showSubmitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Konfirmasi Tes"),
          content: const Text(
            "Apakah Anda sudah yakin ingin mengirim hasil tes DASS-21?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Belum"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Sudah"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      _finishTest();
    }
  }

  void _finishTest() {
    int sum(List<int> idx) => idx.fold(0, (a, i) => a + (_answers[i] ?? 0));

    final dep = sum([2, 4, 9, 12, 15, 16, 20]) * 2;
    final anx = sum([1, 3, 6, 8, 14, 18, 19]) * 2;
    final str = sum([0, 5, 7, 10, 11, 13, 17]) * 2;

    final depLabel = _labelDep(dep);
    final anxLabel = _labelAnx(anx);
    final strLabel = _labelStr(str);

    final overall = _worst([depLabel, anxLabel, strLabel]);

    context.go(
      AppRoutes.dassResults,
      extra: DassResultData(
        depressionScore: dep,
        anxietyScore: anx,
        stressScore: str,
        depressionLabel: depLabel,
        anxietyLabel: anxLabel,
        stressLabel: strLabel,
        overallLabel: overall,
      ),
    );
  }

//label logic

  String _labelDep(int s) {
    if (s <= 9) return "Resiko Rendah";
    if (s <= 13) return "Resiko Ringan";
    if (s <= 20) return "Resiko Sedang";
    if (s <= 27) return "Resiko Tinggi";
    return "Resiko Sangat Tinggi";
  }

  String _labelAnx(int s) {
    if (s <= 7) return "Resiko Rendah";
    if (s <= 9) return "Resiko Ringan";
    if (s <= 14) return "Resiko Sedang";
    if (s <= 19) return "Resiko Tinggi";
    return "Resiko Sangat Tinggi";
  }

  String _labelStr(int s) {
    if (s <= 14) return "Resiko Rendah";
    if (s <= 18) return "Resiko Ringan";
    if (s <= 25) return "Resiko Sedang";
    if (s <= 33) return "Resiko Tinggi";
    return "Resiko Sangat Tinggi";
  }

  String _worst(List<String> labels) {
    const order = {
      "Resiko Rendah": 0,
      "Resiko Ringan": 1,
      "Resiko Sedang": 2,
      "Resiko Tinggi": 3,
      "Resiko Sangat Tinggi": 4,
    };

    labels.sort((a, b) => order[a]!.compareTo(order[b]!));
    return labels.last;
  }

  void _goBack() {
    if (_index > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      context.pop();
    }
  }

  double get _progress => (_answers.where((e) => e != null).length) / 21;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: _goBack,
                      ),
                      const Spacer(),
                      Text("${_index + 1}/21"),
                    ],
                  ),
                  LinearProgressIndicator(value: _progress),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 21,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        _questions[i],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _bg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Column(
                children: _options.map((opt) {
                  final selected = _answers[_index] == opt.value;

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => _selectAnswer(opt.value),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected ? _border : _card,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: _border),
                        ),
                      ),
                      child: Text(
                        opt.label,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
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

class _Option {
  final int value;
  final String label;
  const _Option(this.value, this.label);
}
