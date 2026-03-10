class ProjectModel {
  final String title;
  final String subtitle;
  final String description;
  final List<String> points;
  final List<String> tags;
  final String? githubUrl;
  final String? liveUrl;
  final String emoji;
  final String accentColor;

  const ProjectModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.points,
    required this.tags,
    this.githubUrl,
    this.liveUrl,
    required this.emoji,
    required this.accentColor,
  });
}

class SkillCategory {
  final String name;
  final List<String> skills;
  final String emoji;

  const SkillCategory({
    required this.name,
    required this.skills,
    required this.emoji,
  });
}
