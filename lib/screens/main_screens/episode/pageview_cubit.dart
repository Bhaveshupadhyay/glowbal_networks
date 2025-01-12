import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageViewCubit extends Cubit<int>{

  PageViewCubit():super(0);


  void initPage(){

  }
  void pageChanged(int currentPage){
    emit(currentPage);
  }

  void animatePage(PageController pageController,int index){
    emit(index);
  }

}