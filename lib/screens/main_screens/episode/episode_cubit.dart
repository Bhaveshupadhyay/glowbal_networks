import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/my_api.dart';
import '../../../modal_class/episode_modal.dart';
import '../../season_details/season_state.dart';

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