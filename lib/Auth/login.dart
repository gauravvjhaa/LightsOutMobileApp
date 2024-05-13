import 'package:LightsOut/etc/delay.dart';
import 'package:LightsOut/services/auth_service.dart';
import 'package:LightsOut/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../components/square_tile.dart';
import 'otp.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneHome extends StatefulWidget {
  PhoneHome({super.key});


  @override
  _PhoneHomeState createState() => _PhoneHomeState();
}

class _PhoneHomeState extends State<PhoneHome> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _phoneNumber = '';

  void _sendCode() async {
    String fullPhoneNumber = '$_phoneNumber';

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          //
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error Occurred', e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.to(() => OtpPage(vid: verificationId, phone: fullPhoneNumber));
          // Get.to(OtpPage(vid: verificationId, phone: fullPhoneNumber));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          //
        },
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error Occurred', e.code);
    } catch (e) {
      Get.snackbar('Error Occurred', e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image with Opacity
            Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background_image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  const SizedBox(height: 80.0),
                  const Center(
                    child: Text(
                      'Lights Out Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                        fontFamily: 'Game',
                      ),
                    ),
                  ),
                  const SizedBox(height: 1,),
                  Center(
                    child: Text(
                      'Logging in helps us save your progress',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepOrange.shade100,
                        fontFamily: 'Game'
                      ),
                    ),
                  ),
                  const SizedBox(height: 70.0),
                  Text(
                    'We will send you an OTP on this\n   \u261F mobile number',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.green.shade300,
                      fontFamily: 'Game'
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        _phoneNumber = number.phoneNumber ?? ''; // Using null check to ensure safe access
                      });
                    },
                    spaceBetweenSelectorAndTextField: 8,
                    inputDecoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Game',
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                    selectorConfig: const SelectorConfig(
                      trailingSpace: false,
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _sendCode();
                        await DelayedExecution.executeWithDelay(context, 3000, 'Do not tap anywhere..');
                        await DelayedExecution.executeWithDelay(context, 200, 'Redirecting..');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    ),
                    child: const Text(
                      'Receive OTP',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.yellow,
                        fontFamily: 'Game'
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      await DelayedExecution.executeWithDelay(context, 1000, 'Almost there');
                      // Get.snackbar(
                      //   'You will miss out on features like Personal Stats and Global Leaderboard without logging in',
                      //   'Team Lights Out',
                      //   snackStyle: SnackStyle.FLOATING, // Using FLOATING style for better readability
                      //   backgroundColor: Colors.brown[300],
                      //   colorText: Colors.black,
                      //   borderRadius: 12,
                      //   duration: const Duration(seconds: 3),
                      // );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomeScreen(goodUser: false)),
                            (route) => false, // Removing all existing routes from the stack
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      child: Text(
                        'Play as Guest',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Game',
                          color: Colors.white,
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.7,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.blueGrey.shade200, fontFamily: 'Game', fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.7,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(imagePath: 'assets/google.png', onTap:() async {
                        await DelayedExecution.executeWithDelay(context, 500, 'Hold On');
                            AuthService().signInWithGoogle();
                      }),
                      const SizedBox(width: 25),
                      // apple button
                      SquareTile(imagePath: 'assets/facebook.jpg', onTap: () async {
                        await DelayedExecution.executeWithDelay(context, 500, 'Hold On');
                        //AuthService().signInWithGoogle();
                        //AuthService().signInWithFacebook();
                        //AuthService().signInWithGithub();
                      },)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
