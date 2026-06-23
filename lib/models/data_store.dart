import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'content_models.dart';

class DataStore {
  DataStore._();

  static final DataStore _instance = DataStore._();
  factory DataStore() => _instance;

  final List<TeacherCourse> courses = _seedCourses();
  final List<CourseMaterial> materials = [];
  final List<Exercise> exercises = [];
  final List<Quiz> quizzes = [];
  final List<ExamPaper> examPapers = [];
  final List<Student> students = _seedStudents();
  final List<StudentGrade> grades = _seedGrades();
  final List<StudentActivity> activities = _seedActivities();

  List<CourseMaterial> getMaterialsForCourse(String courseId) =>
      materials.where((m) => m.courseId == courseId).toList();

  List<Exercise> getExercisesForCourse(String courseId) =>
      exercises.where((e) => e.courseId == courseId).toList();

  List<Quiz> getQuizzesForCourse(String courseId) =>
      quizzes.where((q) => q.courseId == courseId).toList();

  List<ExamPaper> getExamsForCourse(String courseId) =>
      examPapers.where((e) => e.courseId == courseId).toList();

  List<String> get uniqueClassNames =>
      courses.map((c) => c.className).toSet().toList();

  List<String> getSubjectsForClass(String className) =>
      courses.where((c) => c.className == className).map((c) => c.subjectName).toList();

  String? getCourseId(String className, String subjectName) {
    final match = courses.where((c) => c.className == className && c.subjectName == subjectName);
    return match.isNotEmpty ? match.first.id : null;
  }

  List<Student> getStudentsByClass(String className) =>
      students.where((s) => s.className == className).toList();

  StudentGrade? getGrade(String studentId, String courseId) {
    final match = grades.where((g) => g.studentId == studentId && g.courseId == courseId);
    return match.isNotEmpty ? match.first : null;
  }

  List<StudentActivity> getRecentActivities(String studentId, {int limit = 5}) {
    final result = activities.where((a) => a.studentId == studentId).toList();
    result.sort((a, b) => b.dateStr.compareTo(a.dateStr));
    return result.take(limit).toList();
  }

  List<StudentRecommendation> analyzeStudent({
    required String studentId,
    required String courseId,
    required String studentName,
    required String subjectName,
  }) {
    final g = getGrade(studentId, courseId);
    if (g == null) return [];

    final recs = <StudentRecommendation>[];
    final allActivities = activities.where((a) => a.studentId == studentId).toList();
    final failedActivities = allActivities.where((a) => a.total > 0 && a.score / a.total < 0.5).toList();

    final topics = failedActivities.map((a) => a.title).toSet().toList();
    final isDeclining = g.recentScores.length >= 2 &&
        g.recentScores.last < g.recentScores.first;

    if (g.average < 10) {
      final topicStr = topics.isNotEmpty ? topics.join(', ') : 'fondamentaux';
      recs.add(StudentRecommendation(
        id: 'rec_catchup_$studentId',
        type: 'remedial_test',
        title: 'Test de rattrapage recommande',
        description: '$studentName a une moyenne de ${g.average}/20. '
            'Un test de rattrapage sur $topicStr permettrait de consolider les bases.',
        topic: topicStr,
        urgency: 3,
        icon: Icons.assignment_rounded,
        actionLabel: 'Creer un test de rattrapage',
      ));

      recs.add(StudentRecommendation(
        id: 'rec_exercises_$studentId',
        type: 'more_exercises',
        title: 'Exercices supplementaires',
        description: 'Proposer des exercices cibles sur $topicStr pour '
            'renforcer la comprehension. Taux de completion: ${g.exercisesCompleted}/${g.exercisesAssigned}.',
        topic: topicStr,
        urgency: 3,
        icon: Icons.repeat_rounded,
        actionLabel: 'Ajouter des exercices',
      ));

      recs.add(StudentRecommendation(
        id: 'rec_approach_$studentId',
        type: 'learning_approach',
        title: 'Approche pedagogique alternative',
        description: 'Pour $studentName, une approche plus visuelle avec des '
            'exercices guides pas-a-pas serait plus efficace. '
            'Recommandation: videos courtes + exercices progressifs.',
        topic: topicStr,
        urgency: 2,
        icon: Icons.lightbulb_rounded,
        actionLabel: 'Voir la fiche pedagogique',
      ));

      recs.add(StudentRecommendation(
        id: 'rec_quiz_$studentId',
        type: 'quiz',
        title: 'Quiz diagnostique automatique',
        description: 'Un quiz auto-corrige sur $topicStr permettrait '
            'd\'identifier precisement les lacunes de $studentName.',
        topic: topicStr,
        urgency: 2,
        icon: Icons.quiz_rounded,
        actionLabel: 'Generer un quiz',
      ));
    } else if (g.average < 12) {
      if (topics.isNotEmpty) {
        recs.add(StudentRecommendation(
          id: 'rec_exercises_$studentId',
          type: 'more_exercises',
          title: 'Exercices de renforcement',
          description: '$studentName pourrait beneficier d\'exercices '
              'supplementaires sur ${topics.first}.',
          topic: topics.first,
          urgency: 2,
          icon: Icons.repeat_rounded,
          actionLabel: 'Ajouter des exercices',
        ));
      }
      if (isDeclining) {
        recs.add(StudentRecommendation(
          id: 'rec_approach_$studentId',
          type: 'learning_approach',
          title: 'Changement d\'approche recommande',
          description: 'Les notes de $studentName sont en baisse. '
              'Essayez une approche avec plus de supports visuels '
              'et des exercices interactifs.',
          topic: subjectName,
          urgency: 2,
          icon: Icons.lightbulb_rounded,
          actionLabel: 'Voir la fiche pedagogique',
        ));
      }
    }

    if (g.exercisesAssigned > 0 &&
        g.exercisesCompleted / g.exercisesAssigned < 0.4) {
      recs.add(StudentRecommendation(
        id: 'rec_motivation_$studentId',
        type: 'motivation',
        title: 'Suivi de motivation necessaire',
        description: '$studentName n\'a complete que ${g.exercisesCompleted} '
            'exercices sur ${g.exercisesAssigned}. Un rappel personnalise '
            'et des exercices plus courts pourraient aider.',
        topic: subjectName,
        urgency: 2,
        icon: Icons.flag_rounded,
        actionLabel: 'Envoyer un rappel',
      ));
    }

    recs.sort((a, b) => b.urgency.compareTo(a.urgency));
    return recs;
  }

  static List<TeacherCourse> _seedCourses() {
    int i = 0;
    return [
      TeacherCourse(id: 'c${i++}', subjectName: 'Mathematiques', className: 'Terminale C', teacherName: 'M. Nkwi', icon: Icons.functions_rounded, color: EduCamColors.subjectMaths, completedLessons: 18),
      TeacherCourse(id: 'c${i++}', subjectName: 'Mathematiques', className: 'Terminale D', teacherName: 'M. Nkwi', icon: Icons.functions_rounded, color: EduCamColors.subjectMaths, completedLessons: 18),
      TeacherCourse(id: 'c${i++}', subjectName: 'Physique', className: 'Premiere C', teacherName: 'M. Nkwi', icon: Icons.science_rounded, color: EduCamColors.subjectPhysique, completedLessons: 10),
      TeacherCourse(id: 'c${i++}', subjectName: 'SVT', className: 'Seconde C', teacherName: 'M. Nkwi', icon: Icons.biotech_rounded, color: EduCamColors.subjectSVT, completedLessons: 14),
    ];
  }

  static List<Student> _seedStudents() {
    return [
      const Student(id: 's1', name: 'Samuel Mbarga', className: 'Terminale C'),
      const Student(id: 's2', name: 'Alice Ngo', className: 'Terminale C'),
      const Student(id: 's3', name: 'Paul Biya Jr', className: 'Terminale C'),
      const Student(id: 's4', name: 'Marie Eyanga', className: 'Terminale C'),
      const Student(id: 's5', name: 'Jean-Pierre Essono', className: 'Terminale C'),
      const Student(id: 's6', name: 'Esther Bikoe', className: 'Terminale C'),
      const Student(id: 's7', name: 'Christine Awono', className: 'Terminale C'),
      const Student(id: 's8', name: 'Luc Mbede', className: 'Terminale C'),
      const Student(id: 's9', name: 'Felicien Nkoulou', className: 'Terminale D'),
      const Student(id: 's10', name: 'Beatrice Mbele', className: 'Terminale D'),
      const Student(id: 's11', name: 'David Nkengue', className: 'Terminale D'),
      const Student(id: 's12', name: 'Sophie Ekwalla', className: 'Terminale D'),
      const Student(id: 's13', name: 'Pierre Mvogo', className: 'Premiere C'),
      const Student(id: 's14', name: 'Julienne Mbarga', className: 'Premiere C'),
      const Student(id: 's15', name: 'Rene Onguene', className: 'Premiere C'),
      const Student(id: 's16', name: 'Colette Abena', className: 'Premiere C'),
      const Student(id: 's17', name: 'Blaise Ndi', className: 'Seconde C'),
      const Student(id: 's18', name: 'Florence Atangana', className: 'Seconde C'),
      const Student(id: 's19', name: 'Henri Njock', className: 'Seconde C'),
      const Student(id: 's20', name: 'Georgette Mboe', className: 'Seconde C'),
    ];
  }

  static List<StudentGrade> _seedGrades() {
    return [
      // Terminale C - Mathematiques
      const StudentGrade(studentId: 's1', courseId: 'c0', subjectName: 'Mathematiques', average: 14.5, recentScores: [12, 16, 11, 14, 18], exercisesCompleted: 12, exercisesAssigned: 15, quizzesCompleted: 8, quizzesAssigned: 10, lastActive: '2026-06-20'),
      const StudentGrade(studentId: 's2', courseId: 'c0', subjectName: 'Mathematiques', average: 16.0, recentScores: [15, 17, 14, 16, 19], exercisesCompleted: 14, exercisesAssigned: 15, quizzesCompleted: 9, quizzesAssigned: 10, lastActive: '2026-06-21'),
      const StudentGrade(studentId: 's3', courseId: 'c0', subjectName: 'Mathematiques', average: 12.0, recentScores: [10, 13, 9, 14, 11], exercisesCompleted: 10, exercisesAssigned: 15, quizzesCompleted: 6, quizzesAssigned: 10, lastActive: '2026-06-18'),
      const StudentGrade(studentId: 's4', courseId: 'c0', subjectName: 'Mathematiques', average: 17.5, recentScores: [18, 16, 19, 17, 20], exercisesCompleted: 15, exercisesAssigned: 15, quizzesCompleted: 10, quizzesAssigned: 10, lastActive: '2026-06-22'),
      const StudentGrade(studentId: 's5', courseId: 'c0', subjectName: 'Mathematiques', average: 9.5, recentScores: [8, 11, 7, 10, 9], exercisesCompleted: 6, exercisesAssigned: 15, quizzesCompleted: 4, quizzesAssigned: 10, lastActive: '2026-06-15'),
      const StudentGrade(studentId: 's6', courseId: 'c0', subjectName: 'Mathematiques', average: 8.0, recentScores: [6, 9, 7, 8, 10], exercisesCompleted: 5, exercisesAssigned: 15, quizzesCompleted: 3, quizzesAssigned: 10, lastActive: '2026-06-14'),
      const StudentGrade(studentId: 's7', courseId: 'c0', subjectName: 'Mathematiques', average: 13.0, recentScores: [11, 14, 12, 13, 15], exercisesCompleted: 11, exercisesAssigned: 15, quizzesCompleted: 7, quizzesAssigned: 10, lastActive: '2026-06-19'),
      const StudentGrade(studentId: 's8', courseId: 'c0', subjectName: 'Mathematiques', average: 10.5, recentScores: [9, 12, 8, 11, 10], exercisesCompleted: 8, exercisesAssigned: 15, quizzesCompleted: 5, quizzesAssigned: 10, lastActive: '2026-06-17'),
      // Terminale D - Mathematiques
      const StudentGrade(studentId: 's9', courseId: 'c1', subjectName: 'Mathematiques', average: 13.0, recentScores: [11, 14, 12, 15, 13], exercisesCompleted: 11, exercisesAssigned: 15, quizzesCompleted: 7, quizzesAssigned: 10, lastActive: '2026-06-20'),
      const StudentGrade(studentId: 's10', courseId: 'c1', subjectName: 'Mathematiques', average: 15.5, recentScores: [14, 17, 15, 16, 18], exercisesCompleted: 13, exercisesAssigned: 15, quizzesCompleted: 9, quizzesAssigned: 10, lastActive: '2026-06-21'),
      const StudentGrade(studentId: 's11', courseId: 'c1', subjectName: 'Mathematiques', average: 11.0, recentScores: [9, 12, 10, 13, 11], exercisesCompleted: 9, exercisesAssigned: 15, quizzesCompleted: 6, quizzesAssigned: 10, lastActive: '2026-06-18'),
      const StudentGrade(studentId: 's12', courseId: 'c1', subjectName: 'Mathematiques', average: 16.5, recentScores: [17, 15, 18, 16, 19], exercisesCompleted: 14, exercisesAssigned: 15, quizzesCompleted: 9, quizzesAssigned: 10, lastActive: '2026-06-22'),
      // Premiere C - Physique
      const StudentGrade(studentId: 's13', courseId: 'c2', subjectName: 'Physique', average: 14.0, recentScores: [12, 15, 13, 16, 14], exercisesCompleted: 10, exercisesAssigned: 12, quizzesCompleted: 6, quizzesAssigned: 8, lastActive: '2026-06-20'),
      const StudentGrade(studentId: 's14', courseId: 'c2', subjectName: 'Physique', average: 12.5, recentScores: [11, 13, 10, 14, 12], exercisesCompleted: 8, exercisesAssigned: 12, quizzesCompleted: 5, quizzesAssigned: 8, lastActive: '2026-06-19'),
      const StudentGrade(studentId: 's15', courseId: 'c2', subjectName: 'Physique', average: 16.0, recentScores: [15, 17, 16, 18, 15], exercisesCompleted: 11, exercisesAssigned: 12, quizzesCompleted: 7, quizzesAssigned: 8, lastActive: '2026-06-22'),
      const StudentGrade(studentId: 's16', courseId: 'c2', subjectName: 'Physique', average: 9.0, recentScores: [7, 10, 8, 9, 11], exercisesCompleted: 5, exercisesAssigned: 12, quizzesCompleted: 3, quizzesAssigned: 8, lastActive: '2026-06-16'),
      // Seconde C - SVT
      const StudentGrade(studentId: 's17', courseId: 'c3', subjectName: 'SVT', average: 15.0, recentScores: [14, 16, 13, 17, 15], exercisesCompleted: 10, exercisesAssigned: 12, quizzesCompleted: 7, quizzesAssigned: 8, lastActive: '2026-06-21'),
      const StudentGrade(studentId: 's18', courseId: 'c3', subjectName: 'SVT', average: 13.5, recentScores: [12, 14, 11, 15, 13], exercisesCompleted: 9, exercisesAssigned: 12, quizzesCompleted: 6, quizzesAssigned: 8, lastActive: '2026-06-20'),
      const StudentGrade(studentId: 's19', courseId: 'c3', subjectName: 'SVT', average: 17.0, recentScores: [18, 16, 19, 17, 20], exercisesCompleted: 12, exercisesAssigned: 12, quizzesCompleted: 8, quizzesAssigned: 8, lastActive: '2026-06-22'),
      const StudentGrade(studentId: 's20', courseId: 'c3', subjectName: 'SVT', average: 10.0, recentScores: [8, 11, 9, 10, 12], exercisesCompleted: 6, exercisesAssigned: 12, quizzesCompleted: 4, quizzesAssigned: 8, lastActive: '2026-06-17'),
    ];
  }

  static List<StudentActivity> _seedActivities() {
    return const [
      StudentActivity(studentId: 's1', type: 'exercice', subjectName: 'Mathematiques', title: 'Fractions algebriques', score: 14, total: 20, dateStr: '2026-06-20'),
      StudentActivity(studentId: 's1', type: 'quiz', subjectName: 'Mathematiques', title: 'Algebre lineaire', score: 8, total: 10, dateStr: '2026-06-19'),
      StudentActivity(studentId: 's1', type: 'cours', subjectName: 'Mathematiques', title: 'Chapitre 5 - Derivation', score: 0, total: 0, dateStr: '2026-06-18'),
      StudentActivity(studentId: 's2', type: 'exercice', subjectName: 'Mathematiques', title: 'Fractions algebriques', score: 17, total: 20, dateStr: '2026-06-21'),
      StudentActivity(studentId: 's2', type: 'quiz', subjectName: 'Mathematiques', title: 'Algebre lineaire', score: 9, total: 10, dateStr: '2026-06-20'),
      StudentActivity(studentId: 's2', type: 'cours', subjectName: 'Mathematiques', title: 'Chapitre 4 - Fonctions', score: 0, total: 0, dateStr: '2026-06-19'),
      StudentActivity(studentId: 's3', type: 'exercice', subjectName: 'Mathematiques', title: 'Probabilites', score: 11, total: 20, dateStr: '2026-06-18'),
      StudentActivity(studentId: 's4', type: 'exercice', subjectName: 'Mathematiques', title: 'Suites numeriques', score: 19, total: 20, dateStr: '2026-06-22'),
      StudentActivity(studentId: 's4', type: 'quiz', subjectName: 'Mathematiques', title: 'Geometrie dans l\'espace', score: 10, total: 10, dateStr: '2026-06-21'),
      StudentActivity(studentId: 's5', type: 'exercice', subjectName: 'Mathematiques', title: 'Statistiques', score: 9, total: 20, dateStr: '2026-06-15'),
      StudentActivity(studentId: 's5', type: 'quiz', subjectName: 'Mathematiques', title: 'Probabilites', score: 4, total: 10, dateStr: '2026-06-14'),
      StudentActivity(studentId: 's6', type: 'exercice', subjectName: 'Mathematiques', title: 'Statistiques', score: 8, total: 20, dateStr: '2026-06-14'),
      StudentActivity(studentId: 's7', type: 'exercice', subjectName: 'Mathematiques', title: 'Fractions algebriques', score: 13, total: 20, dateStr: '2026-06-19'),
      StudentActivity(studentId: 's8', type: 'exercice', subjectName: 'Mathematiques', title: 'Probabilites', score: 10, total: 20, dateStr: '2026-06-17'),
      StudentActivity(studentId: 's13', type: 'exercice', subjectName: 'Physique', title: 'Mecanique Newtonienne', score: 14, total: 20, dateStr: '2026-06-20'),
      StudentActivity(studentId: 's13', type: 'quiz', subjectName: 'Physique', title: 'Lois du mouvement', score: 7, total: 10, dateStr: '2026-06-19'),
      StudentActivity(studentId: 's15', type: 'exercice', subjectName: 'Physique', title: 'Electrostatique', score: 17, total: 20, dateStr: '2026-06-22'),
      StudentActivity(studentId: 's17', type: 'exercice', subjectName: 'SVT', title: 'Genetique', score: 15, total: 20, dateStr: '2026-06-21'),
      StudentActivity(studentId: 's19', type: 'exercice', subjectName: 'SVT', title: "Systeme nerveux", score: 18, total: 20, dateStr: '2026-06-22'),
    ];
  }
}
