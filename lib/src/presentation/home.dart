import 'package:flutter/material.dart';
import 'package:instagram_clone/src/containers/user_container.dart';
import 'package:instagram_clone/src/models/auth/app_user.dart';
import 'package:instagram_clone/src/presentation/home/home_screen.dart';

import 'package:instagram_clone/src/presentation/login_screen.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserContainer(
      builder: (BuildContext context, AppUser user) {
        print('user: $user');
        return user != null ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}