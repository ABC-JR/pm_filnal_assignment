import 'package:first_video/features/auth/domain/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'auth_local_repository.g.dart';





@Riverpod(keepAlive: true)

AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref)  {
  final repository = AuthLocalRepository();
  return repository;
}




class AuthLocalRepository{
  late SharedPreferences _preferences;


  Future<void> init() async{
    _preferences = await SharedPreferences.getInstance();
  }
  Future<String?> getToken() async {
    return _preferences.getString('token');
  }

  Future<void> setToken(String token) async{
    await _preferences.setString('token', token);
  }



  Future<User?> getUser() async {
    final email = _preferences.getString('email');
    final password = _preferences.getString('password');

    if (email != null && password != null) {
      return User(email: email, password: password, token: await getToken() ?? '' , name: "");
    }
    return null;
  }


  Future<void> setUser(User user) async {
    await _preferences.setString('email', user.email);
    await _preferences.setString('password', user.password);
  }


}