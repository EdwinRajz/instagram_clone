import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/src/models/auth/app_user.dart';
import 'package:instagram_clone/src/models/auth/registration_info.dart';

class AuthApi {
  AuthApi({@required FirebaseAuth auth, this.firestore})
      : assert(auth != null),
        _auth = auth;

  final FirebaseAuth _auth;
  final Firestore firestore;

  /// Returns the current login in user or null if there is no user logged in.
  Future<AppUser> getUser() async {
    final FirebaseUser user = await _auth.currentUser();
    return _buildUser(user);
  }

  /// Tries to log the user in using his email and password
  Future<AppUser> login(String email, String password) async {
    final AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (result != null) {}
    return _buildUser(result.user);
  }

  /// Sign out
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Send an email containing the forgotten password to the user
  Future<void> sendForgottenPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  ///Create a user
  Future<AppUser> createUser(RegistrationInfo info) async {
    AuthResult result;
    if (info.email != null) {
      result = await _auth.createUserWithEmailAndPassword(email: info.email, password: info.password);
    } else {
      assert(info.phone != null);
      assert(info.verificationId != null);
      assert(info.smsCode != null);

      final AuthCredential credential =
          PhoneAuthProvider.getCredential(verificationId: info.verificationId, smsCode: info.smsCode);
      result = await _auth.signInWithCredential(credential);
    }
    return _buildUser(result.user, info);
  }

  /// Send SMS to the user and return the verificationId to be used for login
  Future<String> sendSms(String phone) async {
    final Completer<String> completer = Completer<String>();

    _auth.verifyPhoneNumber(
      phoneNumber: '+4$phone',
      timeout: Duration.zero,
      verificationCompleted: (_) {},
      codeAutoRetrievalTimeout: (_) {},
      codeSent: (String verificationId, [_]) {
        completer.complete(verificationId);
      },
      verificationFailed: (AuthException error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  ///User
  Future<AppUser> _buildUser(FirebaseUser firebaseUser, [RegistrationInfo info]) async {
    if (firebaseUser == null) {
      return null;
    }
    final DocumentSnapshot snapshot = await firestore.document('users/${firebaseUser.uid}').get();

    if (snapshot.exists && info == null) {
      return AppUser.fromJson(snapshot.data);
    }

    assert(info != null);
    final AppUser appUser = AppUser((AppUserBuilder b) {
      b
        ..uid = firebaseUser.uid
        ..displayName = info.displayName
        ..username = info.username
        ..email = info.email
        ..birthDate = info.birthDate
        ..phone = info.phone;
    });
    await firestore.document('users/${firebaseUser.uid}').setData(appUser.json);
    return appUser;
  }

  Future<String> reserveUsername({@required String email, @required String displayName}) async {
    if (email != null) {
      final String username = email.split('@')[0];

      final QuerySnapshot snapshot = await firestore
          .collection('users') //
          .where('username', isEqualTo: username)
          .getDocuments();

      if (snapshot.documents.isEmpty) {
        return username;
      }
    }

    String username = displayName.split(' ').join('.').toLowerCase();
    final QuerySnapshot snapshot = await firestore
        .collection('users') //
        .where('username', isEqualTo: username)
        .getDocuments();

    if (snapshot.documents.isEmpty) {
      return username;
    }

    final Random random = Random();
    if (email != null) {
      username = email.split('@')[0] + '${random.nextInt(1 << 32)}';
    } else {
      username = displayName.split(' ').join('.') + '${random.nextInt(1 << 32)}';
    }
    return username;
  }

  Future<AppUser> getContact(String uid) async {
    final DocumentSnapshot snapshot = await firestore.document('users/$uid').get();
    return AppUser.fromJson(snapshot.data);
  }
}
