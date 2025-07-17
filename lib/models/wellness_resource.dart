class WellnessResource {
  final String id;
  final String title;
  final String description;
  final String category;
  final String type; // article, video, audio, exercise
  final String url;
  final String imageUrl;
  final int readTimeMinutes;
  final List<String> tags;

  WellnessResource({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.url,
    required this.imageUrl,
    required this.readTimeMinutes,
    this.tags = const [],
  });
}
