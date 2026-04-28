import 'package:first_video/features/auth/domain/entities/user.dart';


class Usermodel extends User{
  Usermodel({required super.password, required super.email, required super.name  , required super.token }) ;



  factory Usermodel.fromJson(Map<String , dynamic> json){
    return Usermodel(
   
      email: json['email'] ?? ' ' ,
      password: json['password'] ?? ' ' ,
      name: json['name'] ?? ' ' , 
      token : json['token'] ?? '' ,
    );
  }
  Map<String, dynamic> toJson(){
    return <String , dynamic>{
      'email' : email ,
      'password' : password ,
      'name' : name ,
      'token' : token 
    }  ; 
  }


  @override
  String toString() {
    return 'Usermodel{password: $password, email: $email, name: $name, token: $token}';
  }



   Usermodel copyWith({
    String? password,
    String? email,
    String? name,
    String? token  , 

  }) {
    return Usermodel(
      password: password ?? this.password,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,

    );
  }


  
}