library sign_up;

import 'package:built_value/built_value.dart';
import 'package:instagram_clone/src/models/auth/app_user.dart';



import '../actions.dart';

part 'sign_up.g.dart';
abstract class SignUp //
    implements
        Built<SignUp, SignUpBuilder>,
        AppAction //
{
  factory SignUp(ActionResult result) {
    return _$SignUp((SignUpBuilder b) {
      b.result = result;
    });
  }

  SignUp._();

  ActionResult get result;
}

abstract class SignUpSuccessful //
    implements
        Built<SignUpSuccessful, SignUpSuccessfulBuilder>,
        UserAction,
        AppAction //
{
  factory SignUpSuccessful(AppUser user) {
    return _$SignUpSuccessful((SignUpSuccessfulBuilder b) {
      b.user = user.toBuilder();
    });
  }

  SignUpSuccessful._();

  @override
  AppUser get user;
}
abstract class SignUpError //
    implements
        Built<SignUpError, SignUpErrorBuilder>,
        ErrorAction //
{
  factory SignUpError(Object error) {
      return _$SignUpError((SignUpErrorBuilder b) => b.error = error);
  }
  SignUpError._();
  @override
  Object get error;
}