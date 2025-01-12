import 'package:zeus/modal_class/episode_modal.dart';

import '../../../modal_class/continue_watching_modal.dart';
import '../../../modal_class/home_modal.dart';
import '../../../modal_class/video_modal.dart';

//Slider State
abstract class SliderState{}

class SliderDataInitial extends SliderState{}
class SliderDataLoading extends SliderState{}

class SliderDataLoaded extends SliderState{
  final List<VideoModal> list;

  SliderDataLoaded(this.list);
}

class SliderDataError extends SliderState{}

//Home State
abstract class HomeState{}

class HomeDataInitial extends HomeState{}
class HomeDataLoading extends HomeState{}

class HomeDataLoaded extends HomeState{
  final List<HomeModal> list;

  HomeDataLoaded(this.list);
}

class HomeDataError extends HomeState{}


abstract class ContinueWatchingEpisodesState{}

class ContinueEpisodesInitial extends ContinueWatchingEpisodesState{}
class ContinueEpisodesLoading extends ContinueWatchingEpisodesState{}
class ContinueEpisodesLoaded extends ContinueWatchingEpisodesState{
  final List<ContinueWatchingModal> list;

  ContinueEpisodesLoaded(this.list);
}