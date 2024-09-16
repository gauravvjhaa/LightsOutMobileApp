import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../etc/delay.dart';
import 'login.dart';
import 'package:LightsOut/wrapper.dart';

class OtpPage extends StatefulWidget {
  final String vid;
  final String phone;

  OtpPage({Key? key, required this.vid, required this.phone}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var code = '';

  void back() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PhoneHome()),
          (route) => false,
    );
  }

  signIn() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.vid,
      smsCode: code,
    );

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        await DelayedExecution.executeWithDelay(context, 500, 'Hold on.. \nLogging in...');
        Get.to(() => const Wrapper());
        await DelayedExecution.executeWithDelay(context, 500, 'Successfully Logged in...');
      } else {
        Get.snackbar('Error', 'Failed to sign in. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error Occurred', e.code);
    } catch (e) {
      Get.snackbar('Error Occurred', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: PopScope(
          canPop: false,
          child: Stack(
            children: [
              // Background Image with Opacity
              Opacity(
                opacity: 0.1, // Adjusting opacity here (0.0 to 1.0)
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200, bottom: 20),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.transparent.withOpacity(0.5), // Adjust opacity here (0.0 - 1.0)
                          BlendMode.srcATop,
                        ),
                        child: Image.asset(
                          'assets/otp.png',
                          height: 120,
                          width: 120,
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    const Text(
                      "OTP Verification",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Game', // Use custom font
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: textCodeInput(),
                    ),
                    const SizedBox(height: 80),
                    buildVerifyButton(),
                    const SizedBox(height: 5),
                    buildBackButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textCodeInput() {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Pinput(
        length: 6,
        onChanged: (value) {
          setState(() {
            code = value;
          });
        },
      ),
    );
  }

  Widget buildVerifyButton() {
    return ElevatedButton(
      onPressed: signIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: const Text(
        'Verify and Proceed',
        style: TextStyle(
          fontSize: 22,
          color: Colors.yellow,
          fontWeight: FontWeight.bold,
          fontFamily: 'Game', // Use custom font
        ),
      ),
    );
  }

  Widget buildBackButton() {
    return ElevatedButton(
      onPressed: back,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: const Text(
        'Back',
        style: TextStyle(
          fontSize: 24,
          color: Colors.yellow,
          fontWeight: FontWeight.bold,
          fontFamily: 'Game', // Use custom font
        ),
      ),
    );
  }
}
