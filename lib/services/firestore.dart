import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LightsOut/Auth/login.dart';

class InitializeUser {
  static Future<void> initializeUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDocRef = firestore.collection('users').doc(user.uid);

      try {
        // Retrieve the user document snapshot
        DocumentSnapshot docSnapshot = await userDocRef.get();

        // Check if the document exists and contains specific attributes
        if (docSnapshot.exists) {
          Map<String, dynamic>? userData = docSnapshot.data() as Map<String, dynamic>?;

          if (userData != null &&
              userData.containsKey('accuracyForDim3State2') &&
              userData.containsKey('bestAccuracyLevel20')) {
            // Attributes exist, user data is already initialized
            print('User data already initialized.');
            return; // Exit function to prevent reinitialization
          }
        }

        // Document does not exist or missing attributes, initialize user data

        // Initialize accuracy attributes for different dimensions and states
        Map<String, dynamic> accuracyMap = {
          'accuracyForDim3State2': 0.0,
          'accuracyForDim4State2': 0.0,
          'accuracyForDim5State2': 0.0,
          'accuracyForDim6State2': 0.0,
          'accuracyForDim7State2': 0.0,
          'accuracyForDim8State2': 0.0,

          'accuracyForDim3State3': 0.0,
          'accuracyForDim4State3': 0.0,
          'accuracyForDim5State3': 0.0,
          'accuracyForDim6State3': 0.0,
          'accuracyForDim7State3': 0.0,
          'accuracyForDim8State3': 0.0,

          'accuracyForDim3State4': 0.0,
          'accuracyForDim4State4': 0.0,
          'accuracyForDim5State4': 0.0,
          'accuracyForDim6State4': 0.0,
          'accuracyForDim7State4': 0.0,
          'accuracyForDim8State4': 0.0,

          'accuracyForDim3State5': 0.0,
          'accuracyForDim4State5': 0.0,
          'accuracyForDim5State5': 0.0,
          'accuracyForDim6State5': 0.0,
          'accuracyForDim7State5': 0.0,
          'accuracyForDim8State5': 0.0,

          'timeForDim3State2': 0.0,
          'timeForDim4State2': 0.0,
          'timeForDim5State2': 0.0,
          'timeForDim6State2': 0.0,
          'timeForDim7State2': 0.0,
          'timeForDim8State2': 0.0,

          'timeForDim3State3': 0.0,
          'timeForDim4State3': 0.0,
          'timeForDim5State3': 0.0,
          'timeForDim6State3': 0.0,
          'timeForDim7State3': 0.0,
          'timeForDim8State3': 0.0,

          'timeForDim3State4': 0.0,
          'timeForDim4State4': 0.0,
          'timeForDim5State4': 0.0,
          'timeForDim6State4': 0.0,
          'timeForDim7State4': 0.0,
          'timeForDim8State4': 0.0,

          'timeForDim3State5': 0.0,
          'timeForDim4State5': 0.0,
          'timeForDim5State5': 0.0,
          'timeForDim6State5': 0.0,
          'timeForDim7State5': 0.0,
          'timeForDim8State5': 0.0,


          'numberForDim3State2': 0,
          'numberForDim4State2': 0,
          'numberForDim5State2': 0,
          'numberForDim6State2': 0,
          'numberForDim7State2': 0,
          'numberForDim8State2': 0,
          'numberForDim3State3': 0,
          'numberForDim4State3': 0,
          'numberForDim5State3': 0,
          'numberForDim6State3': 0,
          'numberForDim7State3': 0,
          'numberForDim8State3': 0,
          'numberForDim3State4': 0,
          'numberForDim4State4': 0,
          'numberForDim5State4': 0,
          'numberForDim6State4': 0,
          'numberForDim7State4': 0,
          'numberForDim8State4': 0,
          'numberForDim3State5': 0,
          'numberForDim4State5': 0,
          'numberForDim5State5': 0,
          'numberForDim6State5': 0,
          'numberForDim7State5': 0,
          'numberForDim8State5': 0,

          'bestAccuracyLevel1': 0,
          'bestAccuracyLevel2': 0,
          'bestAccuracyLevel3': 0,
          'bestAccuracyLevel4': 0,
          'bestAccuracyLevel5': 0,
          'bestAccuracyLevel6': 0,
          'bestAccuracyLevel7': 0,
          'bestAccuracyLevel8': 0,
          'bestAccuracyLevel9': 0,
          'bestAccuracyLevel10': 0,
          'bestAccuracyLevel11': 0,
          'bestAccuracyLevel12': 0,
          'bestAccuracyLevel13': 0,
          'bestAccuracyLevel14': 0,
          'bestAccuracyLevel15': 0,
          'bestAccuracyLevel16': 0,
          'bestAccuracyLevel17': 0,
          'bestAccuracyLevel18': 0,
          'bestAccuracyLevel19': 0,
          'bestAccuracyLevel20': 0,

          'currentLevel': 0,
        };

        String? fetchedNumber = user.phoneNumber ?? '+91 XXXXXXXXXX';

        String? fetchedName = user.displayName;
        String userName = fetchedName ?? "Not Named";

        // Merge user details and accuracy map into a single userInfoMap
        Map<String, dynamic> userInfoMap = {
          "email": user.email,
          "name": userName, //here i want to check if google provides it null, i wanna name it Lets say "Ram" for now
          "imgUrl": user.photoURL,
          "id": user.uid,
          "phone": fetchedNumber,
          'bio': 'Hey There!',
          ...accuracyMap,
        };

        // Set the user document with the initialized data
        await userDocRef.set(userInfoMap);
      } catch (e) {
        print('Error checking or setting user data: $e');
        // Handle any errors that occur during document check or set
      }
    } else {
      print('User is not authenticated.');
      // Handle scenario where no user is authenticated
    }
  }
}
