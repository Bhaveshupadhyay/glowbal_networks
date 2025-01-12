import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/search_modal.dart';
import 'package:zeus/screens/main_screens/search/search_state.dart';

import '../../../backend/my_api.dart';


class SearchCubit extends Cubit<SearchState>{
  final String _key="SEARCHES";
  String searchText='';
  List<String> searchList=[];

  SearchCubit():super(SearchInitial());

  Future<void> search(String s)async {
    searchText=s;
    if(s.trim().isEmpty){
      emit(RecentLoaded(searchList));
      return;
    };

    emit(SearchLoading());
    SearchModal searchModal= await MyApi().search(s);
    if(searchText.isEmpty){
      emit(RecentLoaded(searchList));
      return;
    };
    if(state is SearchLoading || searchText==s) {
      // print(searchText);
      emit(SearchLoaded(searchModal));
    }
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    searchList= prefs.getStringList(_key) ?? [];
    emit(RecentLoaded(searchList));
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    searchList= prefs.getStringList(_key) ?? [];
    for(String a in searchList){
      if(a.toLowerCase()==searchText.toLowerCase()){
        return;
      }
    }
    searchList.add(searchText);
    await prefs.setStringList(_key, searchList);
    // emit(RecentLoaded(searchList));
  }

  Future<void> clearPrefs() async {
    searchList.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    emit(RecentLoaded([]));
  }


}