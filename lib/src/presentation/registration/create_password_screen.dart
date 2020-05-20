import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instagram_clone/src/actions/auth/update_registration_info.dart';
import 'package:instagram_clone/src/containers/registration_info_container.dart';
import 'package:instagram_clone/src/models/app_state.dart';
import 'package:instagram_clone/src/models/auth/registration_info.dart';


class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({Key key, this.onNext}) : super(key: key);
  final VoidCallback onNext;
  static const String id = 'createPassword';

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RegistrationInfoContainer(
        builder: (BuildContext context, RegistrationInfo info) {
          return Column(
            children: <Widget>[
              const Text(
                'Create a password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 13.0),
              Container(
                padding: const EdgeInsetsDirectional.only(start: 16.0),
                child: const Text(
                  'We\'ll remember the login info, so you won\'t need to enter it on your iCloud® devices.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsetsDirectional.only(start: 16.0),
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'password',
                  ),
                  validator: (String value) {
                    if (value.length < 6) {
                      return 'Password is too weak';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String value) {
                    final RegistrationInfo newInfo = info.rebuild((RegistrationInfoBuilder b) => b.password = value);
                    StoreProvider.of<AppState>(context).dispatch(UpdateRegistrationInfo(newInfo));
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: info.savePassword,
                    onChanged: (bool value) {
                      final RegistrationInfo newInfo =
                          info.rebuild((RegistrationInfoBuilder b) => b.savePassword = value);
                      StoreProvider.of<AppState>(context).dispatch(UpdateRegistrationInfo(newInfo));
                    },
                  ),
                  const Text('Save password'),
                ],
              ),
              const SizedBox(height: 24.0),
              Container(
                constraints: const BoxConstraints.expand(height: 48.0),
                padding: const EdgeInsetsDirectional.only(start: 16.0),
                child: RaisedButton(
                  elevation: 0.0,
                  color: Theme.of(context).accentColor,
                  colorBrightness: Brightness.light,
                  onPressed: () {
                    if (Form.of(context).validate()) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.onNext();
                    }
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
