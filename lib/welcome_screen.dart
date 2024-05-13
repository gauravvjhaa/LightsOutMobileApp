import 'dart:async';
import 'dart:io';
import 'package:LightsOut/etc/stats_page.dart';
import 'package:LightsOut/services/pushing_for_levelwise.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:LightsOut/choose_state.dart';
import 'package:LightsOut/Auth/login.dart';
import 'package:LightsOut/etc/delay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'level_wise.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:LightsOut/components/drawer.dart';

class WelcomeScreen extends StatefulWidget {
  final bool goodUser;
  const WelcomeScreen({super.key, required this.goodUser});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final playerAudio = AudioPlayer();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Start a timer to change isLoading after 2 seconds
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _launchUrl() async {
    const String url = 'https://www.wikihow.com/Solve-Lights-Out-Game';
    Uri uri = Uri.parse(url); // Convert the string URL to a Uri object
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> _launchUrl2() async {
    const String url = 'https://github.com/gauravvjhaa/LightsOutMobileApp';
    Uri uri = Uri.parse(url); // Convert the string URL to a Uri object
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> signOut() async {
    await DelayedExecution.executeWithDelay(context, 600, 'Logged Out Successfully');
    await FirebaseAuth.instance.signOut();
  }

  void goToSignOut(){
    widget.goodUser ? signOut()
        : back();
  }

  void goToProfilePage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    if (widget.goodUser) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StatsPage(),
        ),
      );
    } else {
      _badUser(context);
    }
  }

  void back() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PhoneHome()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'L i g h t s  O u t  -  M u l t i S t a t e',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Game'
          ),
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: goToSignOut,
        goodUser: widget.goodUser,
      ),
      body: PopScope(
        canPop: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image with Opacity
            Opacity(
              opacity: isDarkMode? 0.1 : 0.5, // Adjusting opacity here (0.0 to 1.0)
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background_image_two.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Content
            _isLoading
            ? const LoadingOverlayPro(
                isLoading: true,
                child: Center(

                ),
            )
            : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black87, //background color
                      ),
                      child: const Center(
                        child: Text(
                          'Welcome User',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 45,
                            color: Colors.greenAccent,
                            fontFamily: 'Game',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    _buildButton(40, 'SELECT VARIANT', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChooseState()),
                      );
                    }),
                    const SizedBox(height: 10),
                    _buildButton(40, 'LEVEL PLAY', () {
                      _callLevelWiseGame(1, widget.goodUser);
                    }),
                    const SizedBox(height: 10),
                    _buildButton(52, 'HOW TO PLAY', () {
                      //
                      _launchUrl();
                    }),
                    const SizedBox(height: 10),
                    _buildButton(52, 'ABOUT US', () {
                      //
                      _launchUrl2();
                    }),
                    const SizedBox(height: 10),
                    _buildButton(50, 'EXIT', () {
                      exit(0);
                    }),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _badUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '404 NOT FOUND',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'Game'
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Feature not for you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Game',
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int> databaseLevel() async {
    UserRepository2 objectHelper = UserRepository2();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User not logged in');
      return 0;
    }

    String userId = user.uid;

    Map<String, dynamic>? userData = await objectHelper.getUserFields(userId, 1);

    if (userData == null || userData['currentLevel'] == null) {
      print('User data not found or invalid');
      return 0;
    }

    return userData['currentLevel'] as int;
  }

  Future<void> _callLevelWiseGame(int count, bool achaUser) async {
    int count = await databaseLevel();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LevelWise(initialLevel: count, goodUser: achaUser)),
    );
  }

  Widget _buildButton(double val, String text, void Function()? onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black87, // Set background color here
      ),
      padding: const EdgeInsets.only(top: 7),
      child: MaterialButton(
        height: 40,
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: val),
          child: Text(
            text, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26.0, color: Colors.white, fontFamily: 'Game'),
          ),
        ),
      ),
    );
  }


}