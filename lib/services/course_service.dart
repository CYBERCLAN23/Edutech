import 'package:educam_ai/services/api_client.dart';

class CourseService {
  static final CourseService _instance = CourseService._();
  factory CourseService() => _instance;
  CourseService._();

  final _api = ApiClient();

  Future<List<Map<String, dynamic>>> getCourses() async {
    final result = await _api.get('/courses');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<Map<String, dynamic>> createCourse(Map<String, dynamic> course) async {
    final result = await _api.post('/courses', body: course);
    return result['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getLessons(String courseId) async {
    final result = await _api.get('/courses/$courseId/lessons');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<List<Map<String, dynamic>>> getExercises(String courseId) async {
    final result = await _api.get('/courses/$courseId/exercises');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<List<Map<String, dynamic>>> getQuizzes(String courseId) async {
    final result = await _api.get('/courses/$courseId/quizzes');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<List<Map<String, dynamic>>> getExams(String courseId) async {
    final result = await _api.get('/courses/$courseId/exams');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<List<Map<String, dynamic>>> getStudents({String? className}) async {
    final query = <String, String>{};
    if (className != null) query['class'] = className;
    final result = await _api.get('/students', query: query);
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<Map<String, dynamic>> getStudentGrade(String studentId, String courseId) async {
    final result = await _api.get('/students/$studentId/grades', query: {'courseId': courseId});
    return result['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getStudentActivities(String studentId) async {
    final result = await _api.get('/students/$studentId/activities');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<List<Map<String, dynamic>>> getStudentRecommendations(String studentId) async {
    final result = await _api.get('/students/$studentId/recommendations');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<void> upsertGrade(Map<String, dynamic> grade) async {
    await _api.put('/students/grades', body: grade);
  }

  Future<List<Map<String, dynamic>>> getDocuments({String? category}) async {
    final query = <String, String>{};
    if (category != null) query['category'] = category;
    final result = await _api.get('/documents', query: query);
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }
}
