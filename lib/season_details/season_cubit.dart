import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeus/backend/my_api.dart';
import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/season_details/season_state.dart';

class SeasonCubit extends Cubit<SeasonState>{

  SeasonCubit():super(SeasonInitial());
  final List<String> seasonList=[];

  Future<void> seasonCount(String videoId) async {
    emit(SeasonLoading());
    int seasonCount= await MyApi.getInstance().getSeasonCount(videoId);
    if(seasonCount==0) return;
    for(int i=1;i<=seasonCount;i++){
      seasonList.add(i.toString());
    }
    // emit(SeasonListLoaded(seasonList,seasonList[0]));
    seasonChanged(seasonList[0], videoId);
    // emit(SeasonLoading(value));
    // List<EpisodeModal> list= await MyApi().getSeasonEpisodes(value, videoId);
    // emit(SeasonLoaded(list));
  }

  Future<void> seasonChanged(String value,String videoId) async {
    if(!isClosed) {
      emit(SeasonListLoaded(seasonList,value));
    }

  }
}

class EpisodesCubit extends Cubit<EpisodesState>{
  EpisodesCubit():super(EpisodesInitial());


  Future<void> loadEpisodes(String seasonNumber,String videoId,String seasonTitle,) async {
    emit(EpisodesLoading());
    List<EpisodeModal> list= await MyApi.getInstance().getSeasonEpisodes(seasonNumber, videoId);
    // print("$seasonNumber $videoId");
    if(!isClosed) {
      emit(EpisodesLoaded(list, seasonNumber, seasonTitle,false));
    }
  }

  Future<void> loadNextEpisodes(String seasonNumber,String seasonTitle,String seasonId,String episodeId) async {
    emit(EpisodesLoading());
    List<EpisodeModal> list= await MyApi.getInstance().getNextEpisodes(seasonId, episodeId);
    if(!isClosed){
      emit(EpisodesLoaded(list,seasonNumber,seasonTitle,false));
    }
  }


  void playFirstEpisode(){
    if(state is EpisodesLoaded && !isClosed) {
      List<EpisodeModal> list=(state as EpisodesLoaded).episodesList;
      EpisodesLoaded eState= state as EpisodesLoaded;
      if(list.isNotEmpty) {
        emit(EpisodesLoaded(eState.episodesList,eState.seasonNumber,eState.seasonTitle,true));
      }
    }
  }

}
