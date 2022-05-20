abstract class LoginState{}
class IntiLogein extends LoginState{}

class LodingRegiste extends LoginState{}
class ScRegiste extends LoginState{}
class ErrorRegiste extends LoginState{
  final String error;
  ErrorRegiste(this.error);
}

class LodingCreateUser extends LoginState{}
class ScCreateUser extends LoginState{
  final String uId;
  ScCreateUser(this.uId);
}
class ErrorCreateUser extends LoginState{
  final String error;
  ErrorCreateUser(this.error);
}

class ChangeShowPassRegiste extends LoginState{}
class ChangeShowPass extends LoginState{}

class LodingLogin extends LoginState{}
class ScLogin extends LoginState{
  final String uId;
  ScLogin(this.uId);
}
class ErrorLogin extends LoginState{
  final String error;
  ErrorLogin(this.error);
}

class LodingverifyUser extends LoginState{}


class ScSendverifyingId extends LoginState{
  final String verifyingId;
  ScSendverifyingId(this.verifyingId);
}
class ErrorverifyUser extends LoginState{
  final String error;
  ErrorverifyUser(this.error);
}

class ScverifyUser extends LoginState{}
class PhoneOTPVerified extends LoginState{}
class ErrorOccurred extends LoginState{
  final String error;
  ErrorOccurred(this.error);
}

