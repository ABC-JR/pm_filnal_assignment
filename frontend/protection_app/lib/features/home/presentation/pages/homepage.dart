import 'package:dio/dio.dart';
import 'package:first_video/features/home/data/model/spam_response.dart';
import 'package:first_video/features/home/data/repository/spam_repository.dart';
import 'package:first_video/features/home/domain/model/responce_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  var message = TextEditingController();
  var formkey = GlobalKey<FormState>();

  List<ResponceMsg> rmessages = [
    ResponceMsg(
      spamResponse: SpamResponse(
        verdict: "Spam",
        confidence: 95,
        score: 95,
        reasons: ["Contains suspicious links", "Unsolicited offer"],
        summary: "This message is likely to be spam.",
      ),
      message:
          "Congratulations! You've won a free vacation to the Bahamas! Click here to claim your prize.",
    ),
  ];
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
                                      style: TextStyle(fontSize: 18 , 
                                      fontStyle: FontStyle.italic , 
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
                                      "Recommendation:\nUsers are strongly advised to exercise caution when interacting with this message. \nAvoid clicking unknown links, sharing sensitive information, or engaging with suspicious content. \n\nSummary:\n${rmessages[index].spamResponse.summary}" , 
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                      ),
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
                            message.text.isEmpty ? Icons.mic : Icons.send,
                          ),
                          onPressed: () async {
                            if (message.text.isNotEmpty) {
                              var spamResponse = await SpamRepository(
                                dio: Dio(),
                              ).checkSpam(message.text);

                              setState(() {
                                rmessages.add(
                                  ResponceMsg(
                                    spamResponse: spamResponse,
                                    message: message.text,
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
}
