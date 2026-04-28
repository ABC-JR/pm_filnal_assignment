import 'package:first_video/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecases<Success , Params> {
  Future<Either<Failure, Success>> call(Params params) ;
}


class NoParams {}