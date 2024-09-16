import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardData {
  String userName;
  num averageAccuracy;
  int rank; // Define a rank property

  LeaderboardData({
    required this.userName,
    required this.averageAccuracy,
    this.rank = 0, // Initialize rank to 0 (or any default value)
  });
}

class LeaderboardDataProvider {
  // Fetch user data from Firestore and calculate average accuracy
  static Future<List<LeaderboardData>> fetchLeaderboardData() async {
    try {
      List<LeaderboardData> leaderboardData = [];

      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot document in querySnapshot.docs) {
          String userName = document['name'];
          Map<String, dynamic> userData = document.data() as Map<String, dynamic>;

          num totalAccuracySum = 0; // Changed to 'num' type
          num totalNumberSum = 0; // Changed to 'num' type

          for (int state = 2; state <= 5; state++) {
            for (int dimension = 3; dimension <= 8; dimension++) {
              String accuracyKey = 'accuracyForDim$dimension''State$state';
              String numberKey = 'numberForDim$dimension''State$state';

              if (userData.containsKey(accuracyKey) && userData.containsKey(numberKey)) {
                num accuracy = userData[accuracyKey]; // Changed to 'num' type
                num number = userData[numberKey]; // Changed to 'num' type

                totalAccuracySum += accuracy * number;
                totalNumberSum += number;
              }
            }
          }

          if (totalNumberSum > 0) {
            num overallAvgAccuracy = totalAccuracySum / totalNumberSum;

            print('User: $userName, Average Accuracy: $overallAvgAccuracy');

            LeaderboardData leaderboardEntry = LeaderboardData(
              userName: userName,
              averageAccuracy: overallAvgAccuracy.isNaN ? 0.0 : overallAvgAccuracy.toDouble(),
            );

            leaderboardData.add(leaderboardEntry);
          }
        }

        leaderboardData.sort((a, b) => b.averageAccuracy.compareTo(a.averageAccuracy));

        for (int i = 0; i < leaderboardData.length; i++) {
          leaderboardData[i].rank = i + 1;
        }
      }

      return leaderboardData;
    } catch (e) {
      print('Error fetching leaderboard data: $e');
      return [];
    }
  }
}
