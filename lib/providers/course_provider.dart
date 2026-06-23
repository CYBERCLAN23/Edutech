import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/services/course_service.dart';

final courseServiceProvider = Provider<CourseService>((ref) => CourseService());

final coursesProvider = StateNotifierProvider<CoursesNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return CoursesNotifier(ref.read(courseServiceProvider));
});

class CoursesNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final CourseService _service;

  CoursesNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadCourses() async {
    state = const AsyncValue.loading();
    try {
      final courses = await _service.getCourses();
      state = AsyncValue.data(courses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createCourse(Map<String, dynamic> course) async {
    try {
      await _service.createCourse(course);
      await loadCourses();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final studentsProvider = StateNotifierProvider.family<StudentsNotifier, AsyncValue<List<Map<String, dynamic>>>, String?>(
  (ref, className) {
    return StudentsNotifier(ref.read(courseServiceProvider), className);
  },
);

class StudentsNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final CourseService _service;
  final String? className;

  StudentsNotifier(this._service, this.className) : super(const AsyncValue.loading());

  Future<void> loadStudents() async {
    state = const AsyncValue.loading();
    try {
      final students = await _service.getStudents(className: className);
      state = AsyncValue.data(students);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final courseLessonsProvider = StateNotifierProvider.family<CourseContentNotifier, AsyncValue<List<Map<String, dynamic>>>, String>(
  (ref, courseId) {
    return CourseContentNotifier(ref.read(courseServiceProvider), courseId, 'lessons');
  },
);

final courseExercisesProvider = StateNotifierProvider.family<CourseContentNotifier, AsyncValue<List<Map<String, dynamic>>>, String>(
  (ref, courseId) {
    return CourseContentNotifier(ref.read(courseServiceProvider), courseId, 'exercises');
  },
);

final courseQuizzesProvider = StateNotifierProvider.family<CourseContentNotifier, AsyncValue<List<Map<String, dynamic>>>, String>(
  (ref, courseId) {
    return CourseContentNotifier(ref.read(courseServiceProvider), courseId, 'quizzes');
  },
);

final courseExamsProvider = StateNotifierProvider.family<CourseContentNotifier, AsyncValue<List<Map<String, dynamic>>>, String>(
  (ref, courseId) {
    return CourseContentNotifier(ref.read(courseServiceProvider), courseId, 'exams');
  },
);

class CourseContentNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final CourseService _service;
  final String courseId;
  final String type;

  CourseContentNotifier(this._service, this.courseId, this.type) : super(const AsyncValue.loading());

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      List<Map<String, dynamic>> data;
      switch (type) {
        case 'lessons':
          data = await _service.getLessons(courseId);
          break;
        case 'exercises':
          data = await _service.getExercises(courseId);
          break;
        case 'quizzes':
          data = await _service.getQuizzes(courseId);
          break;
        case 'exams':
          data = await _service.getExams(courseId);
          break;
        default:
          data = [];
      }
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
