import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Wrapper.dart';

class AuthService {

  // Google Sign-In
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn(clientId: '552426309385-57pisu1h8m7o90td26ol3o8sn0oil1t0.apps.googleusercontent.com').signIn();
      if (gUser == null) {
        // Handle sign-in cancellation
        print('Google sign-in canceled.');
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
      User? userDetails = result.user;


      if (userDetails != null) {
        // Check if user data needs initialization
        bool userDataInitialized = await checkUserDataInitialized(userDetails.uid);

        if (!userDataInitialized) {
          // User data has never been initialized, proceed with initialization
          Map<String, dynamic> userInfoMap = {
            "email": userDetails.email,
            "name": userDetails.displayName,
            "imgUrl": userDetails.photoURL,
            "id": userDetails.uid,
          };

          FirebaseFirestore.instance.collection("users").doc(userDetails.uid).set(userInfoMap);

          // Successful login
          print('User logged in: ${userDetails.displayName}');
        }

        Get.to(() => const Wrapper());
        return result;
      } else {
        // Handle unsuccessful login
        print('Failed to sign in.');
        Get.snackbar('Error', 'Failed to sign in. Please try again.');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Error occurred during sign-in: $e');
      Get.snackbar('Error Occurred', e.toString());
      return null;
    }
  }

  // Helper function to check if user data has been initialized
  Future<bool> checkUserDataInitialized(String userId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        // Check if required fields exist in the user document
        Map<String, dynamic>? userData = docSnapshot.data() as Map<String, dynamic>?;

        if (userData != null &&
            userData.containsKey('accuracyForDim3State2') &&
            userData.containsKey('bestAccuracyLevel20')) {
          // User data has been initialized
          return true;
        }
      }

      // User data needs initialization
      return false;
    } catch (e) {
      print('Error checking user data initialization: $e');
      return false; // Assume data needs initialization if error occurs
    }
  }

}
