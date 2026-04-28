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
}