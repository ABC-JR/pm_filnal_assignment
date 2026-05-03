

import 'package:first_video/core/error/failure.dart';
import 'package:first_video/core/network/api.dart';
import 'package:first_video/features/auth/data/model/usermodel.dart';

import 'package:first_video/features/auth/domain/entities/user.dart';
import 'package:first_video/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repositoryimp.g.dart';

@riverpod
AuthRepositoryImpl authRepositoryImpl(AuthRepositoryImplRef ref) {
  final dio = Dio();
  dio.options.followRedirects = true;
  dio.options.maxRedirects = 5;
  return AuthRepositoryImpl(dio: dio);
} 

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;

  AuthRepositoryImpl({required this.dio});

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var responce = await dio.post(
        Api.newurl + '/auth/login',
        data: {'email': email, 'password': password},
      );

      final resbodmap = responce.data as Map<String, dynamic>;

      if (responce.statusCode != 200) {
        return Left(Failure(resbodmap['detail'] ?? 'Unknown error'));
      }

      print('testing token: ${resbodmap["token"]}');
      
      return Right(
        Usermodel.fromJson(
          resbodmap['user'] as Map<String, dynamic>,
        ).copyWith(token: resbodmap['token'] as String?),
      );


    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      return Left(Failure(errorMessage));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPasswordAndName({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      var responce = await dio.post(
        Api.newurl + '/auth/signup',
        data: {'email': email, 'password': password, 'name': name},
      );

      final resbodmap = responce.data as Map<String, dynamic>;

      if (responce.statusCode != 201) {
        return Left(Failure(resbodmap['detail'] ?? 'Unknown error'));
      }

      return Right(
        Usermodel.fromJson(resbodmap['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      return Left(Failure(errorMessage));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser(String token) async {
    try {
      var responce = await dio.get(
        Api.newurl + '/auth/',
        options: Options(headers: {'x-auth-token': token}),
      );

      final resbodmap = responce.data as Map<String, dynamic>;

      return Right(Usermodel.fromJson(resbodmap['user'] as Map<String, dynamic>));
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      return Left(Failure(errorMessage));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  /// Helper method to extract meaningful error messages from DioException
  String _getErrorMessage(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data;

      // Try to get error message from response body
      if (responseData is Map<String, dynamic>) {
        final detail = responseData['detail'] ?? responseData['error'] ?? responseData['message'];
        if (detail != null) {
          return detail.toString();
        }
      }

      // Provide status-code specific messages
      switch (statusCode) {
        case 400:
          return 'Bad request - Invalid data format';
        case 401:
          return 'Unauthorized - Invalid credentials';
        case 422:
          return 'Unprocessable Entity - Check your input data (email format, password strength, name format, etc.)';
        case 500:
          return 'Server error - Please try again later';
        default:
          return 'Error: $statusCode - ${e.message ?? "Unknown error"}';
      }
    }

    // Network errors
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout - Check your internet connection';
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return 'Response timeout - Server took too long to respond';
    }
    if (e.type == DioExceptionType.unknown) {
      return 'Network error - Check your internet connection';
    }

    return e.message ?? 'An unknown error occurred';
  }
}
