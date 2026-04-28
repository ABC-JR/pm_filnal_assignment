part of 'app_cubit_cubit.dart';

@immutable
sealed class AppCubitState {}

final class AppCubitInitial extends AppCubitState {}



final class AppLoggedInState extends AppCubitState {
  final User user ;
  AppLoggedInState({required this.user });
}
