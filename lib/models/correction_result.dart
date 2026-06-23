class CorrectionResult {
  final String subject;
  final int score;
  final int totalPoints;
  final List<String> corrections;
  final List<String> praises;
  final String feedback;

  const CorrectionResult({
    required this.subject,
    required this.score,
    required this.totalPoints,
    required this.corrections,
    required this.praises,
    required this.feedback,
  });

  double get percentage => (score / totalPoints) * 100;
}
