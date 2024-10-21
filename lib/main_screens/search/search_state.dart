
import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/search_modal.dart';

abstract class SearchState{}

class SearchInitial extends SearchState{}
class SearchLoading extends SearchState{}
class SearchLoaded extends SearchState{
  final SearchModal searchModal;

  SearchLoaded(this.searchModal);
}

class RecentLoaded extends SearchState{
  final List<String> list;

  RecentLoaded(this.list);
}