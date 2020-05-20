import 'package:instagram_clone/src/models/auth/app_user.dart';

abstract class AppAction {}

abstract class ErrorAction extends AppAction {
  Object get error;
}

typedef ActionResult = void Function(dynamic action);

abstract class UserAction implements AppAction {
  AppUser get user;
}
