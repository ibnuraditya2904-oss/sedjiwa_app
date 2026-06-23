class Activity {
  final String id;
  final String title;
  final String description;
  final List<String> tags; // 🔥 kunci CBF

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
  });
}
