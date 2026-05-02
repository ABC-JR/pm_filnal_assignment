import 'dart:io';

import 'package:dio/dio.dart';
import 'package:first_video/core/utils/pickers.dart';
import 'package:first_video/features/home/data/model/spam_response.dart';
import 'package:first_video/features/home/data/repository/spam_repository.dart';
import 'package:first_video/features/home/domain/chat.dart';
import 'package:first_video/features/home/domain/model/responce_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  var message = TextEditingController();
  var formkey = GlobalKey<FormState>();

  late List<ResponceMsg> rmessages;


  File? selectedAudio;

  final chatsBox = Hive.box<Chat>('chats');
  var current_chat = Chat(id: 'default', message: 'Default Chat');

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
    // Load messages for current chat
    _loadMessages();
    // If no chats exist, create a default one
    if (chatsBox.isEmpty) {
      chatsBox.add(current_chat);
    }
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

  String buildAiAnalysis(SpamResponse res) {
    return '''
AI Analysis Report

After conducting a comprehensive evaluation of the provided message, our system has classified it as "${res.verdict}".

Confidence Level: ${res.confidence}%
Risk Score: ${res.score}/100

Explanation:
The analysis is based on multiple machine learning models and pattern recognition techniques. 
The system detected several indicators commonly associated with spam or potentially harmful content.

Key Factors:
${res.reasons.map((e) => "- $e").join("\n")}

Interpretation:
A confidence level of ${res.confidence}% suggests that there is a strong likelihood that this message matches known spam patterns. 
Higher scores typically indicate increased risk and reduced trustworthiness.


''';
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
              return ListTile(
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
              );
            }

            // 📦 Обычные чаты
            final chat = chatsBox.getAt(index - 1)!;

            return ListTile(
              leading: CircleAvatar(child: Text(chat.message[0].toUpperCase())),

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
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                        255,
                                        75,
                                        75,
                                        75,
                                      ),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  rmessages[index].message,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Verdict: ${rmessages[index].spamResponse.verdict}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            rmessages[index]
                                                    .spamResponse
                                                    .confidence <=
                                                30
                                            ? Colors.green
                                            : rmessages[index]
                                                      .spamResponse
                                                      .confidence <=
                                                  70
                                            ? Colors.orange
                                            : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      buildAiAnalysis(
                                        rmessages[index].spamResponse,
                                      ),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,

                                        // fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    SizedBox(
                                      height: 180, // 👈 только для gauge
                                      child: SfRadialGauge(
                                        axes: [
                                          RadialAxis(
                                            minimum: 0,
                                            maximum: 100,
                                            ranges: [
                                              GaugeRange(
                                                startValue: 0,
                                                endValue: 30,
                                                color: Colors.green,
                                              ),
                                              GaugeRange(
                                                startValue: 30,
                                                endValue: 70,
                                                color: Colors.orange,
                                              ),
                                              GaugeRange(
                                                startValue: 70,
                                                endValue: 100,
                                                color: Colors.red,
                                              ),
                                            ],
                                            pointers: [
                                              NeedlePointer(
                                                value: rmessages[index]
                                                    .spamResponse
                                                    .confidence
                                                    .toDouble(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    Text(
                                      "Recommendation:\nUsers are strongly advised to exercise caution when interacting with this message. \nAvoid clicking unknown links, sharing sensitive information, or engaging with suspicious content. \n\nSummary:\n${rmessages[index].spamResponse.summary}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),

                                    Divider(
                                      thickness: 1,
                                      color: Colors.grey[300],
                                    ),

                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
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
                                          onPressed: () {
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            message.text.isEmpty ? Icons.music_video_rounded : Icons.send,
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
                            else{
                              final pickedAudio = await pickAudio();

                              if (pickedAudio != null) {
                                final savedAudio = await saveFilePermanently(pickedAudio.path);

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


  void _selectFile() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      final savedAudio = await saveFilePermanently(pickedAudio.path);

      setState(() {
        selectedAudio = savedAudio;
      });
    }
  }


  Future<File> saveFilePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.split('/').last;
    final newFile = File('${directory.path}/$name');

    return File(path).copy(newFile.path);
  }
}
