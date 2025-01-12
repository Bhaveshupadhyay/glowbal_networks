import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeus/backend/my_api.dart';
import 'package:zeus/modal_class/continue_watching_modal.dart';
import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/home_modal.dart';
import 'package:zeus/modal_class/video_modal.dart';

import 'home_state.dart';

class SliderCubit extends Cubit<SliderState>{
  SliderCubit():super(SliderDataInitial());

  Future<void> loadSlider() async {
    emit(SliderDataLoading());
    List<VideoModal> list= await MyApi.getInstance().getSlider();
    if(!isClosed) {
      emit(SliderDataLoaded(list));
    }
  }
}

class HomeCubit extends Cubit<HomeState>{

  HomeCubit():super(HomeDataInitial());

  Future<void> loadHomeData(int offset) async {
    emit(HomeDataLoading());
    List<HomeModal> list= await MyApi.getInstance().getHomeVideos(offset.toString());
    if(!isClosed) {
      emit(HomeDataLoaded(list));
    }
  }

}

class ContinueWatchingCubit extends Cubit<ContinueWatchingEpisodesState>{

  ContinueWatchingCubit():super(ContinueEpisodesInitial());


  Future<void> loadContinueEpisodes() async {
    emit(ContinueEpisodesLoading());
    List<ContinueWatchingModal> list= await MyApi.getInstance().getContinueWatchingEpisodes();
    if(!isClosed) {
      emit(ContinueEpisodesLoaded(list));
    }
  }

}