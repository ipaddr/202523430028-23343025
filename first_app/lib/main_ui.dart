import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'login_view.dart';
import 'notes_view.dart';
import 'verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (user.emailVerified) {
        return const NotesView();
      } else {
        return const VerifyEmailView();
      }
    } else {
      return const LoginView();
    }
  }
}
