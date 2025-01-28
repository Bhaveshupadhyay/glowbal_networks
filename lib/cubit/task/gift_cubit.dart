import 'package:flutter_bloc/flutter_bloc.dart';

class GiftSelectCubit extends Cubit<bool>{
  GiftSelectCubit():super(false);

  void changeState(){
    emit(!state);
  }

}