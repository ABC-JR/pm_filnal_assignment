import 'package:first_video/core/error/failure.dart';
import 'package:first_video/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure  , User>> signInWithEmailAndPassword({ required String email , required String password}) ;
  Future<Either<Failure  , User>> signUpWithEmailAndPasswordAndName({ required String email , required String password , required String name}) ;
  Future<Either<Failure, User?>> getCurrentUser(String token); 

}

