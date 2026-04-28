
import 'package:first_video/core/provider/current_user_notifier.dart';

import 'package:first_video/features/auth/data/repositories/auth_local_repository.dart';
import 'package:first_video/features/auth/data/repositories/auth_repositoryimp.dart';
import 'package:first_video/features/auth/domain/entities/user.dart';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRepositoryImpl _authRepository;
  late AuthLocalRepository _authLocalRepository;


  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  @override
  AsyncValue<User>? build() {
    _authRepository = ref.read(authRepositoryImplProvider);
    _authLocalRepository = ref.read(authLocalRepositoryProvider);
    return null;
  }

  Future<void> singIn({required String email, required String password}) async {
    state = const AsyncValue.loading();

    final res = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print('testing token: ${res.fold(
      (failure) => null,
      (user) => user.token,
    )}');

    res.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message.toString(),
          StackTrace.current,
        );
      },
      (user) {
        _loginsucces(user);
      },
    );
  }

  AsyncValue<User>? _loginsucces(User user) {

    print('testing token: ${user.token}');
    _authLocalRepository.setToken(user.token);
    ref.read(currentUserNotifierProvider.notifier).addUser(user);
    state = AsyncValue.data(user);
    return state;
  }

  Future<void> singUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRepository.signUpWithEmailAndPasswordAndName(
      email: email,
      password: password,
      name: name,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  Future<User?> getcurrenuser() async {
    state = const AsyncValue.loading();
    final token = await _authLocalRepository.getToken() ?? '';
    if (!token.isEmpty) {
      final res = await _authRepository.getCurrentUser(token);
      switch (res) {
        case Left(value: final l):
          state = AsyncValue.error(
            l.message,
            StackTrace.current,
          );
          return null;
        case Right(value: final r):
          getDataSucces(r!);
          return r;
      }
    }
    return null;

  }


  AsyncValue<User> getDataSucces(User user){
    ref.read(currentUserNotifierProvider.notifier).addUser(user);
    return state = AsyncValue.data(user);

  }
}
