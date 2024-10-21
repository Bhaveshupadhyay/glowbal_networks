import 'package:zeus/backend/my_api.dart';

class EpisodeModal{
  final String episodeId;
  final String seasonId;
  final String title;
  final String description;
  final String image;
  final String video;
  final String videoLength;

  EpisodeModal.fromJson(Map<String,dynamic> json):
        episodeId=json['id'].toString(),
        seasonId=json['season_id'].toString(),
        title=json['title'],
        description=json['description'],
        image='${MyApi.imgUrl}/${json['image']}',
        video='${MyApi.imgUrl}/${json['video']}',
        videoLength=json['video_length'].toString();
}