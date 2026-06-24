import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._();
  factory LocalStorageService() => _instance;
  LocalStorageService._();

  static const _coursesBox = 'offline_courses';
  static const _quizzesBox = 'offline_quizzes';
  static const _answersBox = 'offline_quiz_answers';
  static const _resourcesBox = 'offline_resources';
  static const _syncQueueBox = 'sync_queue';
  static const _cacheBox = 'api_cache';

  late Box<String> _courses;
  late Box<String> _quizzes;
  late Box<String> _answers;
  late Box<String> _resources;
  late Box<String> _syncQueue;
  late Box<String> _cache;

  Future<void> init() async {
    await Hive.initFlutter();
    _courses = await Hive.openBox<String>(_coursesBox);
    _quizzes = await Hive.openBox<String>(_quizzesBox);
    _answers = await Hive.openBox<String>(_answersBox);
    _resources = await Hive.openBox<String>(_resourcesBox);
    _syncQueue = await Hive.openBox<String>(_syncQueueBox);
    _cache = await Hive.openBox<String>(_cacheBox);
  }

  Map<String, dynamic>? _decode(String raw) {
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  String _encode(Map<String, dynamic> data) => jsonEncode(data);

  List<Map<String, dynamic>> _decodeList(String raw) {
    try {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  String _encodeList(List<Map<String, dynamic>> data) => jsonEncode(data);

  // --- Courses ---
  Future<void> cacheCourses(List<Map<String, dynamic>> courses) async {
    await _courses.put('all', _encodeList(courses));
  }

  List<Map<String, dynamic>> getCachedCourses() {
    final raw = _courses.get('all');
    if (raw == null) return [];
    return _decodeList(raw);
  }

  // --- Quizzes ---
  Future<void> cacheQuiz(Map<String, dynamic> quiz) async {
    await _quizzes.put(quiz['id'] as String, _encode(quiz));
  }

  Map<String, dynamic>? getCachedQuiz(String quizId) {
    final raw = _quizzes.get(quizId);
    if (raw == null) return null;
    return _decode(raw);
  }

  Future<void> cacheQuizzesForCourse(String courseId, List<Map<String, dynamic>> quizzes) async {
    for (final q in quizzes) {
      q['course_id'] = courseId;
      await cacheQuiz(q);
    }
  }

  List<Map<String, dynamic>> getCachedQuizzesForCourse(String courseId) {
    final all = <Map<String, dynamic>>[];
    for (final entry in _quizzes.toMap().entries) {
      final q = _decode(entry.value);
      if (q != null && q['course_id'] == courseId) {
        all.add(q);
      }
    }
    return all;
  }

  // --- Quiz Answers (offline submissions) ---
  Future<void> saveQuizAnswer(Map<String, dynamic> answer) async {
    final id = answer['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString();
    answer['id'] = id;
    answer['_synced'] = false;
    answer['_created_at'] = DateTime.now().toIso8601String();
    await _answers.put(id, _encode(answer));
    await _addToSyncQueue({
      'type': 'quiz_answer',
      'payload_id': id,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Map<String, dynamic>? getUnsyncedAnswer(String answerId) {
    final raw = _answers.get(answerId);
    if (raw == null) return null;
    final data = _decode(raw);
    if (data != null && data['_synced'] == true) return null;
    return data;
  }

  List<Map<String, dynamic>> getAllUnsyncedAnswers() {
    final all = <Map<String, dynamic>>[];
    for (final entry in _answers.toMap().entries) {
      final a = _decode(entry.value);
      if (a != null && a['_synced'] != true) all.add(a);
    }
    return all;
  }

  Future<void> markAnswerSynced(String answerId) async {
    final raw = _answers.get(answerId);
    if (raw == null) return;
    final data = _decode(raw);
    if (data == null) return;
    data['_synced'] = true;
    data['_synced_at'] = DateTime.now().toIso8601String();
    await _answers.put(answerId, _encode(data));
  }

  // --- Resources (downloaded for offline) ---
  Future<void> saveResource(Map<String, dynamic> resource) async {
    await _resources.put(resource['id'] as String, _encode(resource));
  }

  Map<String, dynamic>? getResource(String resourceId) {
    final raw = _resources.get(resourceId);
    if (raw == null) return null;
    final data = _decode(raw);
    if (data != null && data['_deleted'] == true) return null;
    return data;
  }

  List<Map<String, dynamic>> getAllResources() {
    final all = <Map<String, dynamic>>[];
    for (final entry in _resources.toMap().entries) {
      final r = _decode(entry.value);
      if (r != null && r['_deleted'] != true) all.add(r);
    }
    return all;
  }

  List<Map<String, dynamic>> getResourcesForCourse(String courseId) {
    return getAllResources().where((r) => r['course_id'] == courseId).toList();
  }

  Future<void> deleteResource(String resourceId) async {
    final raw = _resources.get(resourceId);
    if (raw == null) return;
    final data = _decode(raw);
    if (data == null) return;
    data['_deleted'] = true;
    await _resources.put(resourceId, _encode(data));
  }

  // --- Sync Queue ---
  Future<void> _addToSyncQueue(Map<String, dynamic> item) async {
    final id = item['payload_id'] as String;
    await _syncQueue.put(id, _encode(item));
  }

  List<Map<String, dynamic>> getPendingSyncItems() {
    final all = <Map<String, dynamic>>[];
    for (final entry in _syncQueue.toMap().entries) {
      final item = _decode(entry.value);
      if (item != null) all.add(item);
    }
    all.sort((a, b) {
      final aTime = a['created_at'] as String? ?? '';
      final bTime = b['created_at'] as String? ?? '';
      return aTime.compareTo(bTime);
    });
    return all;
  }

  Future<void> removeSyncItem(String payloadId) async {
    await _syncQueue.delete(payloadId);
  }

  // --- Generic API Cache ---
  Future<void> cacheApiResponse(String key, Map<String, dynamic> data, {Duration maxAge = const Duration(hours: 1)}) async {
    final entry = {
      'data': data,
      'cached_at': DateTime.now().millisecondsSinceEpoch,
      'max_age_ms': maxAge.inMilliseconds,
    };
    await _cache.put(key, _encode(entry));
  }

  Map<String, dynamic>? getCachedApiResponse(String key) {
    final raw = _cache.get(key);
    if (raw == null) return null;
    final entry = _decode(raw);
    if (entry == null) return null;
    final cachedAt = entry['cached_at'] as int;
    final maxAge = entry['max_age_ms'] as int;
    final age = DateTime.now().millisecondsSinceEpoch - cachedAt;
    if (age > maxAge) {
      _cache.delete(key);
      return null;
    }
    return entry['data'] as Map<String, dynamic>?;
  }

  Future<void> clearAll() async {
    await _courses.clear();
    await _quizzes.clear();
    await _answers.clear();
    await _resources.clear();
    await _syncQueue.clear();
    await _cache.clear();
  }
}
