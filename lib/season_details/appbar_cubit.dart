import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppBarState{}
class Expanded extends AppBarState{}
class Collapsed extends AppBarState{}

class AppbarCubit extends Cubit<AppBarState>{
  AppbarCubit():super(Expanded());

  void onScroll(ScrollController scrollController){
    scrollController.addListener((){
      if(scrollController.offset>100){
        emit(Collapsed());
      }
      else{
        emit(Expanded());
      }
    });
  }

}