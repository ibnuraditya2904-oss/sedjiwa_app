import '../models/activity_model.dart';

class DummyActivityData {
  static List<Activity> activities = [
    Activity(
      id: "A1",
      title: "Latihan Pernapasan 5 Menit",
      description:
          "Ambil napas dalam selama 5 menit untuk menenangkan pikiran.",
      tags: ["anxiety", "ringan", "sedang"],
    ),
    Activity(
      id: "A2",
      title: "Jalan Santai 10 Menit",
      description: "Berjalan santai di sekitar rumah untuk mengurangi stres.",
      tags: ["stress", "ringan", "sedang"],
    ),
    Activity(
      id: "A3",
      title: "Menulis Jurnal Emosi",
      description: "Tuliskan apa yang kamu rasakan hari ini.",
      tags: ["depression", "sedang", "berat"],
    ),
    Activity(
      id: "A4",
      title: "Meditasi Singkat",
      description: "Meditasi 10 menit untuk membantu fokus dan relaksasi.",
      tags: ["anxiety", "stress", "sedang", "berat"],
    ),
    Activity(
      id: "A5",
      title: "Hubungi Teman",
      description: "Berbicara dengan teman dekat untuk dukungan emosional.",
      tags: ["depression", "berat"],
    ),
  ];
}
