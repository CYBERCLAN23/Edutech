import 'package:flutter/material.dart';

enum ContentType { video, pdf }

class TeacherCourse {
  final String id;
  final String subjectName;
  final String className;
  final String teacherName;
  final IconData icon;
  final Color color;
  final int totalLessons;
  final int completedLessons;

  const TeacherCourse({
    required this.id,
    required this.subjectName,
    required this.className,
    required this.teacherName,
    required this.icon,
    required this.color,
    this.totalLessons = 20,
    this.completedLessons = 0,
  });

  String get displayName => '$subjectName - $className';
  double get progress => totalLessons > 0 ? completedLessons / totalLessons : 0;
}

class CourseMaterial {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final ContentType type;
  final String? url;
  final DateTime addedAt;

  const CourseMaterial({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.type,
    this.url,
    required this.addedAt,
  });
}

class Exercise {
  final String id;
  final String courseId;
  final String title;
  final String instructions;
  final List<ExerciseQuestion> questions;
  final DateTime createdAt;

  const Exercise({
    required this.id,
    required this.courseId,
    required this.title,
    required this.instructions,
    required this.questions,
    required this.createdAt,
  });

  int get totalPoints {
    int sum = 0;
    for (final q in questions) {
      sum += q.points;
    }
    return sum;
  }
}

class ExerciseQuestion {
  final String text;
  final int points;

  const ExerciseQuestion({required this.text, required this.points});
}

enum QuizStatus { active, draft, completed }

class Quiz {
  final String id;
  final String courseId;
  final String title;
  final List<QuizQuestion> questions;
  final int timeLimitMinutes;
  final DateTime createdAt;
  final QuizStatus status;
  final String subject;
  final String difficulty;
  final double avgScore;
  final int studentCount;
  final int totalStudents;
  final IconData icon;
  final Color color;
  final String? dueDate;

  const Quiz({
    required this.id,
    required this.courseId,
    required this.title,
    required this.questions,
    required this.timeLimitMinutes,
    required this.createdAt,
    this.status = QuizStatus.draft,
    this.subject = '',
    this.difficulty = 'Intermediate',
    this.avgScore = 0,
    this.studentCount = 0,
    this.totalStudents = 0,
    this.icon = Icons.quiz_rounded,
    this.color = Colors.blue,
    this.dueDate,
  });

  String get statusLabel {
    switch (status) {
      case QuizStatus.active: return 'Active';
      case QuizStatus.draft: return 'Draft';
      case QuizStatus.completed: return 'Completed';
    }
  }
}

class QuizQuestion {
  final String text;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

class ExamPaper {
  final String id;
  final String courseId;
  final String title;
  final String year;
  final String? pdfUrl;
  final String? description;
  final DateTime addedAt;

  const ExamPaper({
    required this.id,
    required this.courseId,
    required this.title,
    required this.year,
    this.pdfUrl,
    this.description,
    required this.addedAt,
  });
}

class Student {
  final String id;
  final String name;
  final String className;

  const Student({required this.id, required this.name, required this.className});
}

class StudentGrade {
  final String studentId;
  final String courseId;
  final String subjectName;
  final double average;
  final List<double> recentScores;
  final int exercisesCompleted;
  final int exercisesAssigned;
  final int quizzesCompleted;
  final int quizzesAssigned;
  final String lastActive;

  const StudentGrade({
    required this.studentId,
    required this.courseId,
    required this.subjectName,
    required this.average,
    required this.recentScores,
    required this.exercisesCompleted,
    required this.exercisesAssigned,
    required this.quizzesCompleted,
    required this.quizzesAssigned,
    required this.lastActive,
  });
}

class StudentActivity {
  final String studentId;
  final String type;
  final String subjectName;
  final String title;
  final double score;
  final double total;
  final String dateStr;

  const StudentActivity({
    required this.studentId,
    required this.type,
    required this.subjectName,
    required this.title,
    required this.score,
    required this.total,
    required this.dateStr,
  });
}

class StudentRecommendation {
  final String id;
  final String type;
  final String title;
  final String description;
  final String topic;
  final int urgency;
  final IconData icon;
  final String actionLabel;

  const StudentRecommendation({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.topic,
    required this.urgency,
    required this.icon,
    required this.actionLabel,
  });
}
