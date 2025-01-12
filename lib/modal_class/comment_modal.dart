import '../backend/my_api.dart';

class CommentModal{
  String? id;
  String? userId;
  String? postId;
  String? text;
  String? likes;
  String? dislikes;
  String? date;
  String? name;
  String? image;
  bool showReplies=false;
  int? usaTimestamp;

  CommentModal.fromJson(Map<String,dynamic> json, this.usaTimestamp):
        id=json['id'],
        userId=json['user_id'],
        postId=json['post_id'],
        text=json['text'],
        likes=json['likes'],
        dislikes=json['dislikes'],
        date=json['date'],
        name=json['name'],
        image=json['image']!=null && json['image']!=''?"${MyApi.imgUrl}/${json['image']}":null,
        showReplies=int.parse(json['replies'].toString())>0;

  CommentModal(
      {this.id,
      this.userId,
      this.postId,
      this.text,
      this.likes,
      this.dislikes,
      this.date,
      this.name,
      this.image,
      required this.showReplies,
      this.usaTimestamp});
}