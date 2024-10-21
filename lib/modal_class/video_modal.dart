import '../backend/my_api.dart';

class VideoModal{
  final String id;
  final String title;
  final String description;
  final String image;
  final String video;
  final String videoLength;

  VideoModal.fromJson(Map<String,dynamic> json):
      id=json['id'],
      title=json['title'],
      description=json['description'],
      image='${MyApi.imgUrl}/${json['image']}',
      video='${MyApi.imgUrl}/${json['video']}',
      videoLength=json['video_length'];

  VideoModal.fromHomeJson(Map<String,dynamic> json):
      id=json['videoId'],
      title=json['videoTitle'],
      description=json['videoDescription'],
      image='${MyApi.imgUrl}/${json['videoImage']}',
      video='${MyApi.imgUrl}/${json['videoUrl']}',
      videoLength=json['videoLength'];
}