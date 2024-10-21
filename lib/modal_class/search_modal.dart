import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/video_modal.dart';

class SearchModal{
  final List<EpisodeModal> episodesList;
  final List<VideoModal> videoList;

  SearchModal(this.episodesList, this.videoList);
}