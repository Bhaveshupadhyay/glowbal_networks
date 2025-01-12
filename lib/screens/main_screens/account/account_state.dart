
import '../../../modal_class/user_details.dart';

abstract class AccountState{}

class AccountInitial extends AccountState{}

class AccountUserDetails extends AccountState{
  final UserDetails userDetails;

  AccountUserDetails(this.userDetails);
}

class AccountNotLoggedIn extends AccountState{}
class AccountLoggedOut extends AccountState{}