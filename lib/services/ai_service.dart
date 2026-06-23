import 'package:educam_ai/services/api_client.dart';

class AiService {
  static final AiService _instance = AiService._();
  factory AiService() => _instance;
  AiService._();

  final _api = ApiClient();

  Future<String> chat(String message) async {
    final result = await _api.post('/ai/chat', body: {'message': message});
    return (result['data'] as Map<String, dynamic>)['reply'] as String;
  }

  Future<List<Map<String, dynamic>>> getChatHistory() async {
    final result = await _api.get('/ai/history');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<Map<String, dynamic>> generateLesson(String topic, String subject, String className) async {
    final result = await _api.post('/content/generate-lesson', body: {
      'topic': topic,
      'subject': subject,
      'className': className,
    });
    return result['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateExercises(String topic, String subject, {int numQuestions = 5}) async {
    final result = await _api.post('/content/generate-exercises', body: {
      'topic': topic,
      'subject': subject,
      'numQuestions': numQuestions,
    });
    return result['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateQuiz(String topic, String subject, {int numQuestions = 10}) async {
    final result = await _api.post('/content/generate-quiz', body: {
      'topic': topic,
      'subject': subject,
      'numQuestions': numQuestions,
    });
    return result['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateVideo(String topic, String subject, String className) async {
    final result = await _api.post('/video/generate', body: {
      'topic': topic,
      'subject': subject,
      'className': className,
    });
    return result['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> correctCopy(String text, String subject) async {
    final result = await _api.post('/ai/correct', body: {
      'text': text,
      'subject': subject,
    });
    return result['data'] as Map<String, dynamic>;
  }
}
