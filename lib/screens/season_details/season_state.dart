import 'package:zeus/modal_class/episode_modal.dart';

abstract class SeasonState{}

class SeasonInitial extends SeasonState{}
class SeasonLoading extends SeasonState{}

class SeasonListLoaded extends SeasonState{
  final List<String> seasonList;
  final String selectedValue;

  SeasonListLoaded(this.seasonList, this.selectedValue);
}
class SeasonSelected extends SeasonState{
  final String value;

  SeasonSelected(this.value);
}


abstract class EpisodesState{}

class EpisodesInitial extends EpisodesState{}
class EpisodesLoading extends EpisodesState{}

class EpisodesLoaded extends EpisodesState{
  final String seasonNumber;
  final String seasonTitle;
  final List<EpisodeModal> episodesList;
  final bool isPlay;

  EpisodesLoaded(this.episodesList, this.seasonNumber, this.seasonTitle, this.isPlay);
}