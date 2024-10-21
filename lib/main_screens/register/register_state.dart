abstract class RegisterState{}

class RegisterInitial extends RegisterState{}

class RegisterLoading extends RegisterState{}

class RegisterSuccess extends RegisterState{}

class RegisterFailed extends RegisterState{
  final String errorMsg;

  RegisterFailed(this.errorMsg);
}