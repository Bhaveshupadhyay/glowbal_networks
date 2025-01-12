abstract class SubscriptionState{}

class SubscriptionLoading extends SubscriptionState{}

class SubscriptionActive extends SubscriptionState{
  final int startDate;
  final int endDate;
  final String subId;

  SubscriptionActive({required this.startDate, required this.endDate, required this.subId});
}

class SubscriptionNotActive extends SubscriptionState{

}
class SubscriptionNotExist extends SubscriptionState{}