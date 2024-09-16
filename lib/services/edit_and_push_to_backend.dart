import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserFields(String userId, int state, int dimension) async {
    String accuracyFieldName = 'accuracyForDim${dimension}State${state}';
    String timeFieldName = 'timeForDim${dimension}State${state}';
    String numberFieldName = 'numberForDim${dimension}State${state}';

    // Reference to the user document
    DocumentReference userDocRef = _firestore.collection('users').doc(userId);

    try {
      // Retrieve the entire user document
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        // Extract the specific fields from the document snapshot
        Map<String, dynamic> userData = {
          'accuracy': docSnapshot.get(accuracyFieldName),
          'time': docSnapshot.get(timeFieldName),
          'number': docSnapshot.get(numberFieldName),
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

  Future<void> updateUserDataYes(String userId, double currAccuracy, double currTimeTaken, int state, int dimension) async {
    String accuracyFieldName = 'accuracyForDim${dimension}State${state}';
    String timeFieldName = 'timeForDim${dimension}State${state}';
    String numberFieldName = 'numberForDim${dimension}State${state}';

    try {
      // Retrieve current user data fields
      Map<String, dynamic>? userData = await getUserFields(userId, state, dimension);

      if (userData != null) {
        // Perform calculations to update accuracy, time, and number
        double currentAccuracy = userData['accuracy'] as double;
        double currentTime = userData['time'] as double;
        int currentNumber = userData['number'] as int;

        double updatedAccuracy = ((currentAccuracy * currentNumber) + currAccuracy) / (currentNumber + 1);
        double updatedTime = ((currentTime * currentNumber) + currTimeTaken) / (currentNumber + 1);
        int updatedNumber = currentNumber + 1;

        // Prepare update data
        Map<String, dynamic> updateData = {
          accuracyFieldName: updatedAccuracy,
          timeFieldName: updatedTime,
          numberFieldName: updatedNumber,
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
