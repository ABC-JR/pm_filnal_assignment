
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:first_video/core/network/api.dart';
import 'package:first_video/features/home/data/model/retrain.dart';
import 'package:first_video/features/home/data/model/retrain_result.dart';
import 'package:first_video/features/home/data/model/spam_response.dart';

class SpamRepository {
  final Dio dio;
  

  SpamRepository({required this.dio}) {
    // Configure timeout - increased to 60 seconds
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
    dio.options.sendTimeout = const Duration(seconds: 60);
  }

  Future<SpamResponse> checkSpam(String message) async {
    try {
       final response = await dio.post(
        Api.baseUrl + '/check/spam',
        data: {'text': message},
        options: Options(
          connectTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 120),
        ),
      );

      if (response.statusCode == 200) {
        return SpamResponse(
          verdict: response.data['verdict'],
          confidence: response.data['confidence'],
          score: response.data['score'],
          reasons: List<String>.from(response.data['reasons']),
          summary: response.data['summary'],
        );
      } else {
        throw Exception('Failed to check spam: ${response.statusCode}');
      }
    } catch (e) {
      print('Detailed error: $e');
      print('Backend URL: ${Api.baseUrl}');
      throw Exception('Error checking spam: $e');
    }
  }



  Future<List<SpamResponse>> checkMultipleMessages(List<String> messages) async {
    try {
      final response = await dio.post(
        Api.baseUrl + '/check/spam/batch',
        data: {'texts': messages},
      );
      var final_response = response.data['results']; 

      if (response.statusCode == 200) {
       

        return (final_response as List).map((item) {
          return SpamResponse(
            verdict: item['verdict'],
            confidence: item['confidence'],
            score: item['score'],
            reasons: List<String>.from(item['reasons']),
            summary: item['summary'],
          );
        }).toList();
      } else {
        throw Exception('Failed to check spam: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking spam: $e');
    }
  }


  Future<Retrain> retrain(String text , bool isSpam) async {
    try {
      final response = await dio.post(
        Api.baseUrl + '/retrain/spam/feedback',
        data: {'text': text, 'is_spam': isSpam},
      );

      if (response.statusCode == 200) {
        return Retrain(
          status: response.data['status'],
          buffer_size: response.data['buffer_size'],
        );
      } else {
        throw Exception('Failed to retrain model: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error retraining model: $e');
    }
  }

  Future<RetrainResult> getModelStatus() async {
    try {
      final response = await dio.get(Api.baseUrl + '/retrain/spam/retrain');

      if (response.statusCode == 200) {
        return RetrainResult(
          status: response.data['status'],
          samples_used: response.data['samples_used'],
        );

      } else {
        throw Exception('Failed to get model status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting model status: $e');
    }
  }


    Future<SpamResponse> checkSpamMicro(File audiofile) async {
    try {



       final response = await dio.post(
        Api.baseUrl + '/file/toText',
        data: {'audio': audiofile},
        options: Options(
          connectTimeout: const Duration(seconds: 360),
          receiveTimeout: const Duration(seconds: 360),
          sendTimeout: const Duration(seconds: 360),
        ),

      );

      final checkspam  =  await dio.post(
        Api.baseUrl + '/check/spam',
        data: {'text': response},
        options: Options(
          connectTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 120),
        ),
      );
      

      if (checkspam.statusCode == 200) {
        return SpamResponse(
          verdict: checkspam.data['verdict'],
          confidence: checkspam.data['confidence'],
          score: checkspam.data['score'],
          reasons: List<String>.from(checkspam.data['reasons']),
          summary: checkspam.data['summary'],
        );
      } else {
        throw Exception('Failed to check spam: ${checkspam.statusCode}');
      }
    } catch (e) {
      print('Detailed error: $e');
      print('Backend URL: ${Api.baseUrl}');
      throw Exception('Error checking spam: $e');
    }
  }



  
}