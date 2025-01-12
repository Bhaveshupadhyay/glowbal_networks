class SubscriptionModal{
  final bool isCustomerExist;
  final bool? isSubActive;
  final int? startDate;
  final int? endDate;
  final String? subId;

  SubscriptionModal.fromJson(Map<String,dynamic> json):
        isCustomerExist=json['isCustomerExist'],
        isSubActive=json['isSubActive'],
        startDate=json['start_date'],
        endDate=json['end_date'],
        subId=json['subId'];
}