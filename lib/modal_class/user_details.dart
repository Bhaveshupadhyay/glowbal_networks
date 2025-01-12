

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
        image=json['image']!=null && json['image'].toString().isNotEmpty?"${MyApi.imgUrl}/${json['image']}":null,
        ip=json['ip_address'];
}

