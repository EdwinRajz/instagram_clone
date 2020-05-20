library update_registration_info;

import 'package:built_value/built_value.dart';
import 'package:instagram_clone/src/actions/actions.dart';
import 'package:instagram_clone/src/models/auth/registration_info.dart';


part 'update_registration_info.g.dart';

abstract class UpdateRegistrationInfo
    implements Built<UpdateRegistrationInfo, UpdateRegistrationInfoBuilder>, AppAction {
  factory UpdateRegistrationInfo(RegistrationInfo info) {
    return _$UpdateRegistrationInfo((UpdateRegistrationInfoBuilder b) {
      b.info = info.toBuilder();
    });
  }

  UpdateRegistrationInfo._();

  RegistrationInfo get info;
}
