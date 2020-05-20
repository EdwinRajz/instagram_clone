import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/src/presentation/registration/birthday_screen.dart';
import 'package:instagram_clone/src/presentation/registration/create_password_screen.dart';
import 'package:instagram_clone/src/presentation/registration/phone_or_email_screen.dart';
import 'package:instagram_clone/src/presentation/registration/sms_code_screen.dart';
import 'package:instagram_clone/src/presentation/registration/name_screen.dart';
import 'package:instagram_clone/src/presentation/registration/welcome_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);
  static const String id = 'signUp';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController controller = PageController();
  RegisterType registerType = RegisterType.email;
  void nextPage() {
    controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Form(
                child: PageView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    PhoneOrEmailScreen(
                      onNext: nextPage,
                      onChanged: (RegisterType value) {
                        setState(() => registerType = value);
                      },
                    ),
                    if (registerType == RegisterType.phone) SmsCodeScreen(onNext: nextPage),
                    NameScreen(onNext: nextPage),
                    if (registerType == RegisterType.email) CreatePasswordScreen(onNext: nextPage),
                    BirthdayScreen(onNext: nextPage),
                    WelcomeScreen(onNext: nextPage)
                  ],
                ),
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign in',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
