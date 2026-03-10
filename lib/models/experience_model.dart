class ExperienceModel {
  final String company;
  final String role;
  final String duration;
  final String location;
  final List<String> points;
  final String? logoEmoji;
  final List<String> tags;
  final bool isPresent;

  const ExperienceModel({
    required this.company,
    required this.role,
    required this.duration,
    required this.location,
    required this.points,
    this.logoEmoji,
    required this.tags,
    this.isPresent = false,
  });
}
