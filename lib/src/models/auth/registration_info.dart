library registration_info;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:instagram_clone/src/models/serializers.dart';

part 'registration_info.g.dart';

abstract class RegistrationInfo implements Built<RegistrationInfo, RegistrationInfoBuilder> {
  factory RegistrationInfo() {
    return _$RegistrationInfo((RegistrationInfoBuilder b) => b.savePassword = false);
  }

  RegistrationInfo._();

  factory RegistrationInfo.fromJson(Map<dynamic, dynamic> json) => serializers.deserializeWith(serializer, json);



  @nullable
  String get email;

  @nullable
  String get phone;

  @nullable
  String get verificationId;

  @nullable
  String get smsCode;

  @nullable
  String get displayName;

  @nullable
  String get password;

  @nullable
  DateTime get birthDate;

  @nullable
  String get username;


  bool get savePassword;

  Map<String, dynamic> get json => serializers.serializeWith(serializer, this);

  static Serializer<RegistrationInfo> get serializer => _$registrationInfoSerializer;
}
