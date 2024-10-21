abstract class PasswordState{}

class PasswordVisible extends PasswordState{}
class PasswordInvisible extends PasswordState{}

abstract class LoginState{}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginSuccess extends LoginState{}

class LoginFailed extends LoginState{
  final String errorMsg;

  LoginFailed(this.errorMsg);
}