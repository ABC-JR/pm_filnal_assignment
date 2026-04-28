import 'package:first_video/core/error/failure.dart';
import 'package:first_video/core/usecases/usecases.dart';
import 'package:first_video/features/auth/domain/entities/user.dart';
import 'package:first_video/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignin implements Usecases<User, UsecasesSignin> {
  final AuthRepository repository;

  UserSignin(this.repository);

  @override
  Future<Either<Failure, User>> call(UsecasesSignin params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,

    );
    
 
  
}

}


class UsecasesSignin {
  final String email ;
  final String password ;

  UsecasesSignin({required this.email , required this.password}) ;

}