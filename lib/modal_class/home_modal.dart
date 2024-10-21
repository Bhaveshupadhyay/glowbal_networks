import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/video_modal.dart';

class HomeModal{

  final VideoModal videoModal;
  final List<EpisodeModal> episodeList;
  final String latestSeasonNumber;

  HomeModal(this.videoModal, this.episodeList, this.latestSeasonNumber);
}