import '../models/adaptive_recommendation_data.dart';
import '../../presentation/pages/dass_result_page.dart';

class DummyAiRecommendationService {
  static AdaptiveRecommendationData generate(DassResultData result) {
    final dominant = _getDominantAspect(result);

    if (dominant == "Depresi") {
      return AdaptiveRecommendationData(
        dominantAspect: dominant,
        summary:
            "Gejala awal yang muncul berdasarkan tes yang Anda lakukan menunjukkan kecenderungan pada aspek depresi. Anda mungkin sedang mengalami penurunan semangat, berkurangnya minat terhadap aktivitas, serta munculnya perasaan tidak berharga atau putus asa dalam beberapa situasi.",
        symptoms: const [
          "Sulit merasakan emosi positif",
          "Merasa putus asa atau sedih",
          "Kehilangan semangat dalam beraktivitas",
          "Merasa diri tidak berharga",
          "Merasa hidup kurang bermakna",
        ],
        activities: const [
          "Menulis jurnal emosi selama 10 menit",
          "Berjalan santai 15–20 menit",
          "Mendengarkan musik yang menenangkan",
          "Membuat jadwal aktivitas kecil harian",
          "Menghubungi teman atau keluarga terpercaya",
        ],
      );
    }

    if (dominant == "Kecemasan") {
      return AdaptiveRecommendationData(
        dominantAspect: dominant,
        summary:
            "Gejala awal yang muncul berdasarkan tes yang Anda lakukan menunjukkan kecenderungan pada aspek kecemasan. Anda mungkin mengalami rasa khawatir berlebih, ketegangan tubuh, sulit merasa tenang, atau sensitivitas terhadap situasi yang memicu rasa panik.",
        symptoms: const [
          "Khawatir berlebihan",
          "Mudah panik dalam situasi tertentu",
          "Jantung terasa lebih cepat atau tidak nyaman",
          "Tubuh terasa tegang atau gemetar",
          "Sulit merasa rileks",
        ],
        activities: const [
          "Latihan pernapasan 4-4-6 selama 5 menit",
          "Grounding 5-4-3-2-1",
          "Mengurangi paparan pemicu stres sementara",
          "Istirahat singkat dari layar/gadget",
          "Melakukan peregangan ringan",
        ],
      );
    }

    return AdaptiveRecommendationData(
      dominantAspect: dominant,
      summary:
          "Gejala awal yang muncul berdasarkan tes yang Anda lakukan menunjukkan kecenderungan pada aspek stres. Anda mungkin sedang mengalami ketegangan emosional, sulit beristirahat, lebih mudah tersinggung, dan merasa energi cepat terkuras saat menghadapi tekanan sehari-hari.",
      symptoms: const [
        "Sulit beristirahat",
        "Mudah tersinggung",
        "Reaksi berlebihan terhadap situasi",
        "Sulit merasa tenang",
        "Mudah merasa lelah secara emosional",
      ],
      activities: const [
        "Istirahat terjadwal 10–15 menit",
        "Peregangan tubuh atau relaksasi otot",
        "Membuat prioritas tugas sederhana",
        "Minum air dan atur pola tidur",
        "Melakukan aktivitas yang menenangkan",
      ],
    );
  }

  static String _getDominantAspect(DassResultData result) {
    if (result.depressionScore >= result.anxietyScore &&
        result.depressionScore >= result.stressScore) {
      return "Depresi";
    }
    if (result.anxietyScore >= result.depressionScore &&
        result.anxietyScore >= result.stressScore) {
      return "Kecemasan";
    }
    return "Stress";
  }
}
