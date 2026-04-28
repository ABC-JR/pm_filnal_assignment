import 'package:bloc/bloc.dart';

import 'package:first_video/features/auth/domain/entities/user.dart';
import 'package:meta/meta.dart';

part 'app_cubit_state.dart';

class AppCubitCubit extends Cubit<AppCubitState> {
  AppCubitCubit() : super(AppCubitInitial());
  void updateUser(User? user) {
    if(user == null){
      emit(AppCubitInitial());
    }else{
      emit(AppLoggedInState(user: user));
    }
  }
}


