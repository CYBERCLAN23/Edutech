import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String nameFr;
  final IconData icon;
  final Color color;
  final double progress;
  final int lessonsCompleted;
  final int totalLessons;
  final String description;

  const Subject({
    required this.id,
    required this.name,
    required this.nameFr,
    required this.icon,
    required this.color,
    required this.progress,
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.description,
  });

  static const List<Subject> subjects = [
    Subject(
      id: 'maths',
      name: 'Mathematics',
      nameFr: 'Mathematiques',
      icon: Icons.functions_rounded,
      color: Color(0xFF4F46E5),
      progress: 0.72,
      lessonsCompleted: 18,
      totalLessons: 25,
      description: 'Algebre, Geometrie, Probabilites – prepa BAC',
    ),
    Subject(
      id: 'svt',
      name: 'SVT',
      nameFr: 'Sciences de la Vie',
      icon: Icons.biotech_rounded,
      color: Color(0xFF10B981),
      progress: 0.55,
      lessonsCompleted: 11,
      totalLessons: 20,
      description: 'Biologie, Geologie, Ecologie',
    ),
    Subject(
      id: 'histoire',
      name: 'Histoire-Geo',
      nameFr: 'Histoire-Geographie',
      icon: Icons.public_rounded,
      color: Color(0xFFF59E0B),
      progress: 0.88,
      lessonsCompleted: 22,
      totalLessons: 25,
      description: 'Histoire du Cameroun, Geographie mondiale',
    ),
    Subject(
      id: 'physique',
      name: 'Physics',
      nameFr: 'Physique-Chimie',
      icon: Icons.science_rounded,
      color: Color(0xFFEF4444),
      progress: 0.40,
      lessonsCompleted: 8,
      totalLessons: 20,
      description: 'Mecanique, Electricite, Chimie organique',
    ),
    Subject(
      id: 'francais',
      name: 'Francais',
      nameFr: 'Francais',
      icon: Icons.menu_book_rounded,
      color: Color(0xFFEC4899),
      progress: 0.65,
      lessonsCompleted: 13,
      totalLessons: 20,
      description: 'Dissertation, Grammaire, Litterature',
    ),
    Subject(
      id: 'anglais',
      name: 'English',
      nameFr: 'Anglais',
      icon: Icons.language_rounded,
      color: Color(0xFF06B6D4),
      progress: 0.60,
      lessonsCompleted: 12,
      totalLessons: 20,
      description: 'Grammar, Essay Writing, Comprehension',
    ),
  ];
}
