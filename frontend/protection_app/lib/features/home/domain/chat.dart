


import 'package:hive/hive.dart';

part 'chat.g.dart';

@HiveType(typeId: 2)
class Chat {
  @HiveField(0)
  String id;
  @HiveField(1)
  String message; 

  Chat({
    required this.id,
    required this.message,
  });

}