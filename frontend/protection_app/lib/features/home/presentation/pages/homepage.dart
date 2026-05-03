import 'dart:io';

import 'package:dio/dio.dart';
import 'package:first_video/core/utils/pickers.dart';
import 'package:first_video/features/auth/data/repositories/auth_local_repository.dart';
import 'package:first_video/features/auth/domain/entities/user.dart';
import 'package:first_video/features/home/data/repository/spam_repository.dart';
import 'package:first_video/features/home/domain/chat.dart';
import 'package:first_video/features/home/domain/model/responce_msg.dart';
import 'package:first_video/features/home/presentation/pages/questionpage.dart';
import 'package:first_video/features/home/presentation/pages/userpage.dart';
import 'package:first_video/features/home/presentation/widgets/ai_analyze_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  var message = TextEditingController();
  var formkey = GlobalKey<FormState>();

  List<ResponceMsg> rmessages = [];

  File? selectedAudio;

  final chatsBox = Hive.box<Chat>('chats');
  var current_chat = Chat(id: 'default', message: 'Default Chat');

  late User realuser;
  final authRepo = AuthLocalRepository();

  Box<ResponceMsg> get box {
    // Create a unique box for each chat
    try {
      return Hive.box<ResponceMsg>('chat_${current_chat.id}');
    } catch (e) {
      // Box doesn't exist yet, return default
      return Hive.box<ResponceMsg>('chatBox');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    // Load messages for current chat
    _loadMessages();
    // If no chats exist, create a default one
    if (chatsBox.isEmpty) {
      chatsBox.add(current_chat);
    }
  }

  Future<void> _initializeRepository() async {
    await authRepo.init();
    final user = await authRepo.getUser();
    setState(() {
      realuser = user ?? User(email: '', password: '', token: '', name: '');
    });
  }

  void _loadMessages() {
    try {
      final chatBox = Hive.box<ResponceMsg>('chat_${current_chat.id}');
      setState(() {
        rmessages = chatBox.values.toList();
      });
    } catch (e) {
      setState(() {
        rmessages = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView.builder(
          itemCount: chatsBox.length + 1, // +1 для кнопки
          itemBuilder: (context, index) {
            // 🟢 КНОПКА СОЗДАНИЯ ЧАТА (первый элемент)
            if (index == 0) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        realuser.email.isNotEmpty
                            ? realuser.email[0].toUpperCase()
                            : "?",
                      ),
                    ),

                    title: Text(
                      "${realuser.name} (${realuser.email})",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Userpage(user: realuser,))
                       
                      );
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.add, color: Colors.blue),
                    title: Text(
                      "Start New Chat",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      final newChat = Chat(
                        id: DateTime.now().toIso8601String(),
                        message: "Chat ${chatsBox.length + 1}",
                      );

                      chatsBox.add(newChat);
                      current_chat = newChat;

                      _loadMessages();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }

            // 📦 Обычные чаты
            final chat = chatsBox.getAt(index - 1)!;

            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  chat.message.isNotEmpty ? chat.message[0].toUpperCase() : "?",
                ),
              ),

              title: Text(
                chat.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              tileColor: current_chat == chat
                  ? Colors.blue.withOpacity(0.1)
                  : null,

              onTap: () {
                current_chat = chat;
                _loadMessages();
                Navigator.pop(context);
              },
            );
          },
        ),
      ),

      appBar: AppBar(
        title: const Text(
          'Spam Detection App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔥 СПИСОК СООБЩЕНИЙ
            Expanded(
              child: rmessages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: rmessages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              QuestionPage(rmessages: rmessages, index: index),
                              AiAnalysisCard(
                                res: rmessages[index].spamResponse,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                      thickness: 1,
                                      color: Colors.grey[300],
                                    ),

                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            if (rmessages[index]
                                                    .spamResponse
                                                    .verdict
                                                    .toLowerCase() ==
                                                'spam') {
                                              await SpamRepository(
                                                dio: Dio(),
                                              ).retrain(
                                                rmessages[index].message,
                                                true,
                                              );
                                            } else {
                                              await SpamRepository(
                                                dio: Dio(),
                                              ).retrain(
                                                rmessages[index].message,
                                                false,
                                              );
                                            }

                                            setState(() {
                                              rmessages[index].userFeedback =
                                                  rmessages[index]
                                                          .userFeedback ==
                                                      true
                                                  ? null
                                                  : true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.thumb_up,
                                            color:
                                                rmessages[index].userFeedback ==
                                                    true
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            if (rmessages[index]
                                                    .spamResponse
                                                    .verdict
                                                    .toLowerCase() ==
                                                'spam') {
                                              await SpamRepository(
                                                dio: Dio(),
                                              ).retrain(
                                                rmessages[index].message,
                                                false,
                                              );
                                            } else {
                                              await SpamRepository(
                                                dio: Dio(),
                                              ).retrain(
                                                rmessages[index].message,
                                                true,
                                              );
                                            }

                                            await SpamRepository(
                                              dio: Dio(),
                                            ).retrain(
                                              rmessages[index].message,
                                              false,
                                            );

                                            setState(() {
                                              rmessages[index].userFeedback =
                                                  rmessages[index]
                                                          .userFeedback ==
                                                      false
                                                  ? null
                                                  : false;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.thumb_down,
                                            color:
                                                rmessages[index].userFeedback ==
                                                    false
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            /// 🔥 ПОЛЕ ВВОДА (внизу)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: message,
                      maxLines: null,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: IconButton(
                          onPressed: () async {
                            final pickedAudio = await pickAudio();

                            if (pickedAudio != null) {
                              final savedAudio = await saveFilePermanently(
                                pickedAudio.path,
                              );

                              setState(() {
                                selectedAudio = savedAudio;
                              });

                              var spamResponse = await SpamRepository(
                                dio: Dio(),
                              ).checkSpamMicro(savedAudio);

                              // Ensure chat box exists
                              try {
                                await Hive.openBox<ResponceMsg>(
                                  'chat_${current_chat.id}',
                                );
                              } catch (e) {
                                // Box already open
                              }

                              // Add message to current chat box
                              await box.add(
                                ResponceMsg(
                                  message: "[Audio Message]",
                                  spamResponse: spamResponse,
                                ),
                              );

                              setState(() {
                                rmessages.add(
                                  ResponceMsg(
                                    message: "[Audio Message]",
                                    spamResponse: spamResponse,
                                  ),
                                );
                                message.clear();
                              });
                            }
                          },
                          icon: Icon(Icons.music_video_rounded),
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: message.text.isNotEmpty
                                ? Colors.grey
                                : const Color.fromARGB(84, 70, 69, 69),
                          ),
                          onPressed: () async {
                            if (message.text.isNotEmpty) {
                              var spamResponse = await SpamRepository(
                                dio: Dio(),
                              ).checkSpam(message.text);

                              // Ensure chat box exists
                              try {
                                await Hive.openBox<ResponceMsg>(
                                  'chat_${current_chat.id}',
                                );
                              } catch (e) {
                                // Box already open
                              }

                              // Add message to current chat box
                              await box.add(
                                ResponceMsg(
                                  message: message.text,
                                  spamResponse: spamResponse,
                                ),
                              );

                              setState(() {
                                rmessages.add(
                                  ResponceMsg(
                                    message: message.text,
                                    spamResponse: spamResponse,
                                  ),
                                );
                                message.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> saveFilePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.split('/').last;
    final newFile = File('${directory.path}/$name');

    return File(path).copy(newFile.path);
  }
}
