import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String uid;
  final bool isEmailVerified;
  const AuthUser({
    required this.uid,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        uid: user.uid,
        isEmailVerified: user.emailVerified,
      );
}
