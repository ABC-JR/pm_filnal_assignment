import 'package:first_video/core/error/failure.dart';
import 'package:first_video/core/usecases/usecases.dart';
import 'package:first_video/features/auth/domain/entities/user.dart';
import 'package:first_video/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignup implements Usecases<User, UsecasesSignup> {
  final AuthRepository repository;

  UserSignup(this.repository);

  @override
  Future<Either<Failure, User>> call(UsecasesSignup params) async {
    return await repository.signUpWithEmailAndPasswordAndName(
      email: params.email,
      password: params.password,
      name: params.name,
    );
    
 
  
}

}


class UsecasesSignup {
  final String email ;
  final String password ;
  final String name ;
  UsecasesSignup({required this.email , required this.password , required this.name}) ;

}