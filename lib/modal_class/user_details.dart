

import '../backend/my_api.dart';

class UserDetails{
  static String? id;
  final String? email;
  final String? name;
  final String? image;
  final String? ip;



  UserDetails.fromJson(Map<String,dynamic> json):
        email=json['email'],
        name=json['name'],
        image="${MyApi.imgUrl}/${json['image']}",
        ip=json['ip_address'];
}

