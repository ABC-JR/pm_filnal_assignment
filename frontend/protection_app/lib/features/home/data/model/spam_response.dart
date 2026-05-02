import 'package:hive/hive.dart';

part 'spam_response.g.dart';

@HiveType(typeId: 0)
class SpamResponse {
  @HiveField(0)
  final String verdict;

  @HiveField(1)
  final int confidence;

  @HiveField(2)
  final int score;

  @HiveField(3)
  final List<String> reasons;

  @HiveField(4)
  final String summary;

  SpamResponse({
    required this.verdict,
    required this.confidence,
    required this.score,
    required this.reasons,
    required this.summary,
  });
}