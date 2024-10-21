import '../backend/my_api.dart';

class ReplyModal{
  String? id;
  String? userId;
  String? text;
  String? likes;
  String? dislikes;
  String? date;
  String? name;
  String? image;
  String? commId;
  int? usaTimestamp;

  ReplyModal.fromJson(Map<String,dynamic> json, this.usaTimestamp):
        id=json['id'],
        userId=json['user_id'],
        commId=json['comm_id'],
        text=json['text'],
        likes=json['likes'],
        dislikes=json['dislikes'],
        date=json['date'],
        name=json['name'],
        image=json['image']!=''?"${MyApi.imgUrl}/${json['image']}":'';
}