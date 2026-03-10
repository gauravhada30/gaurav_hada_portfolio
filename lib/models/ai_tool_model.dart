import 'package:flutter/widgets.dart';

class AiToolModel {
  final String name;
  final String description;
  final IconData icon;
  final String colorHex;

  const AiToolModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.colorHex,
  });
}
