import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository2 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserFields(String userId, int level) async {
    String accuracyLevelFieldName = 'bestAccuracyLevel$level';

    // Reference to the user document
    DocumentReference userDocRef = _firestore.collection('users').doc(userId);

    try {
      // Retrieve the entire user document
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        // Extract the specific fields from the document snapshot
        Map<String, dynamic> userData = {
          'accuracyForLevel': docSnapshot.get(accuracyLevelFieldName),
          'currentLevel': docSnapshot.get('currentLevel'),
        };
        return userData;
      } else {
        // Document doesn't exist
        print('User document not found');
        return null;
      }
    } catch (e) {
      // Handle error
      print('Error retrieving user fields: $e');
      return null;
    }
  }

  Future<void> updateLevelAndAccuracy(String userId, int level, double currAccuracy) async {
    String accuracyLevelFieldName = 'bestAccuracyLevel$level';

    try {
      Map<String, dynamic>? userData = await getUserFields(userId, level);

      if (userData != null) {
        num currentLevelAccuracy = userData['accuracyForLevel'];
        num currentLevel = userData['currentLevel'];

        num updatedCurrentLevelAccuracy = currAccuracy > currentLevelAccuracy ? currAccuracy : currentLevelAccuracy;
        num updatedCurrentLevel = level > currentLevel ? level : currentLevel;

        // Prepare update data
        Map<String, dynamic> updateData = {
          accuracyLevelFieldName: updatedCurrentLevelAccuracy,
          'currentLevel': updatedCurrentLevel,
        };

        // Update user document in Firestore
        await _firestore.collection("users").doc(userId).update(updateData);
      } else {
        print('User data not found or could not be retrieved.');
      }
    } catch (e) {
      // Handle error
      print('Error updating user data: $e');
    }
  }


}
