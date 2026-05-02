

import 'package:first_video/features/home/data/model/spam_response.dart';

import 'package:hive/hive.dart';

part 'responce_msg.g.dart';

@HiveType(typeId: 1)
class ResponceMsg {
  @HiveField(0)
  final SpamResponse spamResponse;

  @HiveField(1)
  final String message;

  @HiveField(2)
  bool? userFeedback;

  ResponceMsg({
    required this.spamResponse,
    required this.message,
    this.userFeedback,
  });
}