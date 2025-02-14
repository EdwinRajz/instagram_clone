import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instagram_clone/src/actions/auth/login.dart';

import 'package:instagram_clone/src/models/app_state.dart';
import 'package:instagram_clone/src/presentation/forgot_password_screen.dart';
import 'package:instagram_clone/src/presentation/registration/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  static const String id = 'Login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            const SizedBox(height: 32.0),
            Container(
              alignment: AlignmentDirectional.center,
              child: Image.asset(
                'res/logo.png',
                height: 56.0,
              ),
            ),
            const SizedBox(height: 32.0),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                hintText: 'Email address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: FlatButton(
                padding: EdgeInsets.zero,
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.id);
                },
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 24.0),
            RaisedButton(
              elevation: 0.0,
              color: Theme.of(context).accentColor,
              colorBrightness: Brightness.light,
              onPressed: () async {
                final String email = this.email.text;
                final String password = this.password.text;

                if (email.isNotEmpty && password.isNotEmpty) {
                  StoreProvider.of<AppState>(context).dispatch(Login(email, password));
                }
              },
              child: const Text('Log in'),
            ),
            const SizedBox(height: 24.0),
            Container(
              alignment: AlignmentDirectional.center,
              child: Text.rich(
                TextSpan(
                  text: 'Don\'t have an account? ',
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, SignUpScreen.id);
                        },
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 16.0),
            Container(
              alignment: AlignmentDirectional.center,
              child: const Text('Instagram dummy'),
            ),
          ],
        ),
      ),
    );
  }
}
