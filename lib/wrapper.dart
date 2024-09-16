import 'package:LightsOut/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:LightsOut/welcome_screen.dart';
import 'package:LightsOut/Auth/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            InitializeUser.initializeUserData();
            return const WelcomeScreen(goodUser: true,);
          } else {
            return PhoneHome();
          }
        },
      ),
    );
  }
}
