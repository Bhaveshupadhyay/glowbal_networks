import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/backend/my_api.dart';
import 'package:zeus/modal_class/subscription_modal.dart';
import 'package:zeus/screens/subscription/subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState>{
  SubscriptionCubit():super(SubscriptionLoading());

  Future<void> checkSubscription() async {
    final prefs= await SharedPreferences.getInstance();
    String email=prefs.getString('email')??'';
    if(email.isNotEmpty){
      SubscriptionModal subscriptionModal= await MyApi.getInstance().getSubscription(email);
      if(!isClosed){
        if(subscriptionModal.isCustomerExist){
          if(subscriptionModal.isSubActive==true){
            emit(SubscriptionActive(startDate: subscriptionModal.startDate!, endDate: subscriptionModal.endDate!, subId: subscriptionModal.subId!));
          }
          else{
            emit(SubscriptionNotActive());
          }
        }
        else{
          emit(SubscriptionNotActive());
        }
      }
    }
  }
}