import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeus/bottom_navigation/navigation_state.dart';

class NavigationCubit extends Cubit<int>{

  NavigationCubit():super(0);

  void changeIndex(int index){
    emit(index);
  }
}