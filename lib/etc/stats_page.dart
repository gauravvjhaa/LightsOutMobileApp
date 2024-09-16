import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'delay.dart';
import 'leaderboard_helper.dart';

import 'leaderboard_page.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = 'LOADING';
  String phone = 'LOADING';
  String email = 'LOADING';
  String bio = 'LOADING';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void dispose() {
    // Dispose text editing controllers when the state is disposed
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        name = userData['name'] ?? 'Not Named';
        email = userData['email'] ?? '';
        phone = userData['phone'] ?? '';
        bio = userData['bio'] ?? '';
      });
    }
  }

  String _selectedMode = 'Free Mode';

  List<Map<String, dynamic>> convertLeaderboardDataList(List<LeaderboardData> leaderboardData) {
    List<Map<String, dynamic>> convertedList = [];
    for (var data in leaderboardData) {
      convertedList.add({
        'userName': data.userName,
        'averageAccuracy': data.averageAccuracy,
        'rank': data.rank,
      });
    }
    return convertedList;
  }

  bool isNavigating = false;

  void navigateToLeaderboard(BuildContext context) async {
    if (isNavigating) {
      return;
    }

    await DelayedExecution.executeWithDelay(context, 200, 'Updating..');

    try {
      setState(() {
        isNavigating = true; // Set navigation state to true
      });

      List<LeaderboardData> leaderboardData = await LeaderboardDataProvider.fetchLeaderboardData();
      List<Map<String, dynamic>> convertedData = convertLeaderboardDataList(leaderboardData);

      // Navigate to LeaderboardPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeaderboardPage(leaderboardData: convertedData),
        ),
      );
    } finally {
      setState(() {
        isNavigating = false; // Reset navigation state to false
      });
    }
  }

  void _showEditDetailsOption() {

    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
    bioController.text = bio;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditTextField('Name', nameController, name),
              _buildEditTextField('Email', emailController, email),
              _buildEditTextField('Phone Number', phoneController, phone),
              _buildEditTextField('Bio', bioController, bio),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate and save edited details
              if (_isValidInput()) {
                _saveEditedDetails();
                Navigator.of(context).pop(); // Close the dialog
              } else {
                // Show error message or handle invalid input
              }
            },
            child: const Text('OK', style: TextStyle(color: Colors.yellowAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildEditTextField(String labelText, TextEditingController controller, String initialValue) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText, hintText: initialValue),
    );
  }

  bool _isValidInput() {
    // Implement validation logic here (e.g., check email format)
    return true; // Return true if input is valid; otherwise, return false
  }

  void _saveEditedDetails() {
    Map<String, dynamic> updatedDetails = {};

    if (nameController.text != name) {
      updatedDetails['name'] = nameController.text;
      setState(() {
        name = nameController.text;
      });
    }

    if (emailController.text != email) {
      updatedDetails['email'] = emailController.text;
      setState(() {
        email = emailController.text;
      });
    }

    if (phoneController.text != phone) {
      updatedDetails['phone'] = phoneController.text;
      setState(() {
        phone = phoneController.text;
      });
    }

    if (bioController.text != bio) {
      updatedDetails['bio'] = bioController.text;
      setState(() {
        bio = bioController.text;
      });
    }

    // Update Firestore only for the changed fields
    if (updatedDetails.isNotEmpty) {
      // Create a map of only the fields that are being updated
      Map<String, dynamic> fieldsToUpdate = {};

      // Update Firestore with the changed fields
      if (updatedDetails.containsKey('name')) {
        fieldsToUpdate['name'] = updatedDetails['name'];
      }
      if (updatedDetails.containsKey('email')) {
        fieldsToUpdate['email'] = updatedDetails['email'];
      }
      if (updatedDetails.containsKey('phone')) {
        fieldsToUpdate['phone'] = updatedDetails['phone'];
      }
      if (updatedDetails.containsKey('bio')) {
        fieldsToUpdate['bio'] = updatedDetails['bio'];
      }

      FirebaseFirestore.instance.collection('users').doc(_userId).update(fieldsToUpdate);
    }

    // Clear text controllers
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    bioController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'U S E R   P R O F I L E',
          style: TextStyle(fontFamily: 'Game', fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 5,),
                    GestureDetector(
                      onTap: _showEditDetailsOption,
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 5,),
                          Text('E D I T', style: TextStyle(fontSize: 18, color: Colors.yellowAccent, fontFamily: 'Game'),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 8,),
                    //profile pic
                    const Icon(Icons.person, size: 120),
                    const SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //user details
                          const Text('N a m e :  ', textAlign: TextAlign.center, style: TextStyle(color: Colors.yellowAccent, fontSize: 18,fontFamily: 'Game',),),
                          Text(name, textAlign: TextAlign.center,style: TextStyle(fontSize: 17,),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //user details
                          const Text('E m a i l :  ', textAlign: TextAlign.center, style: TextStyle(color: Colors.yellowAccent, fontSize: 18, fontFamily: 'Game'),),
                          Text(email, textAlign: TextAlign.center, style: TextStyle(fontSize: 17,),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //user details
                          const Text('P h o n e  N u m b e r :  ', textAlign: TextAlign.center, style: TextStyle(color: Colors.yellowAccent ,fontSize: 18, fontFamily: 'Game'),),
                          Text(phone, textAlign: TextAlign.center,style: const TextStyle(fontSize: 17, fontFamily: 'Game'),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //user details
                          const Text('B i o :  ', textAlign: TextAlign.center, style: TextStyle(color: Colors.yellowAccent, fontSize: 18, fontFamily: 'Game'),),
                          Text(bio, textAlign: TextAlign.center, style: TextStyle(fontSize: 17,),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),

              const SizedBox(height: 15,),
              const Divider(
                height: 20,
                thickness: 4,
                color: Colors.black,
              ),
              const SizedBox(height: 15,),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 120),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.yellow[200] : Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'USER Stats',
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Game',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: ToggleButtons(
                    isSelected: _selectedMode == 'Free Mode'
                        ? [true, false]
                        : [false, true],
                    selectedColor: Colors.yellowAccent,
                    selectedBorderColor: isDarkMode? Colors.yellow : Colors.red,
                    borderWidth: 2,
                    onPressed: (index) {
                      setState(() {
                        _selectedMode = index == 0 ? 'Free Mode' : 'Level Mode';
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Free Mode Stats', style: TextStyle(fontFamily: 'Game', fontSize: 15, color: isDarkMode? Colors.white : Colors.black),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Level Mode Stats', style: TextStyle(fontFamily: 'Game', fontSize: 15, color: isDarkMode? Colors.white : Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(_userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('User data not found.'));
                  }

                  Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;

                  if (userData == null) {
                    return const Center(child: Text('Invalid user data.'));
                  }
                  print('User Data: $userData');


                  return Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black87 : Colors.yellowAccent[100],
                      border: Border.all(
                        color: Colors.black,
                        width: 5.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            "$name's Performance so far",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Game',
                              color: isDarkMode? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _selectedMode == 'Free Mode'
                            ? _buildFreeModeStats(userData, isDarkMode)
                            : _buildLevelModeStats(userData, isDarkMode),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {

                  navigateToLeaderboard(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                ),
                child: const Text(
                  'SEE LEADERBOARD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 29,
                    fontFamily: 'Game',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreeModeStats(Map<String, dynamic> userData, bool isDarkMode) {
    List<Widget> stateWidgets = [];

    // Display stats for each state and dimension in Free Mode
    for (int state = 2; state <= 5; state++) {
      List<Widget> dimensionWidgets = [];
      for (int dimension = 3; dimension <= 8; dimension++) {
        String keyAccuracy = 'accuracyForDim$dimension''State$state';   //'state$state-dimension$dimension';
        String keyTime = 'timeForDim$dimension''State$state';
        String keyNumber = 'numberForDim$dimension''State$state';
        num statsAccuracy = userData[keyAccuracy] ?? {};
        num statsTime = userData[keyTime] ?? {};
        num statsNumber = userData[keyNumber] ?? {};
        dimensionWidgets.add(_buildFreeModeStatsTile(state, dimension, statsAccuracy, statsTime, statsNumber, isDarkMode));
      }
      stateWidgets.add(
        ExpansionTile(
          title: Text('State $state', style: const TextStyle(
              fontFamily: 'Game', fontSize: 19
          ),),
          children: dimensionWidgets,
        ),
      );
    }

    return Column(children: stateWidgets);
  }

  Widget _buildFreeModeStatsTile(int state, int dimension, num statsAccuracy, num statsTime, num statsNumber, bool isDarkMode) {
    return ListTile(
      title: Text('Dimension $dimension', style: TextStyle(fontFamily: 'Game', fontSize: 26, color: isDarkMode? Colors.yellowAccent[100] : Colors.black)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('G A M E S  P L A Y E D : $statsNumber', style: const TextStyle(fontFamily: 'Game')),
          Text('A V E R A G E  A C C U R A C Y : ${statsAccuracy.toStringAsFixed(2)}%', style: const TextStyle(fontFamily: 'Game')),
          Text('A V E R A G E  T I M E : ${statsTime.toStringAsFixed(3)} seconds', style: const TextStyle(fontFamily: 'Game')),
        ],
      ),
    );
  }

  Widget _buildLevelModeStats(Map<String, dynamic> userData, bool isDarkMode) {
    List<Widget> levelTiles = [];

    // Initialize default values
    const double defaultAccuracy = 0.0;
    const String defaultRecordedOn = 'Unknown';

    // Iterate through levels 1 to 30
    for (int level = 1; level <= 20; level++) {
      String key = 'bestAccuracyLevel$level';

      // Check if levelStats contains data for the current level
      if (userData.containsKey(key)) {
        num bestAccuracy = userData[key] ?? defaultAccuracy;

        // Create ListTile widget for the level
        levelTiles.add(
          ListTile(
            title: Text('Level $level', style: TextStyle(fontFamily: 'Game', fontSize: 26, color: isDarkMode? Colors.yellowAccent[100] : Colors.black)),
            subtitle: Text(
              'B E S T  A C C U R A C Y : ${bestAccuracy.toStringAsFixed(2)}', style: const TextStyle(fontFamily: 'Game',
            ),
          ),
        )
        );
      } else {
        // If data not found for the current level, display with default values
        levelTiles.add(
          ListTile(
            title: Text('Level $level', style: TextStyle(fontFamily: 'Game', fontSize: 26, color: isDarkMode? Colors.yellowAccent[100] : Colors.black)),
            subtitle: Text(
              'B E S T  A C C U R A C Y : ${defaultAccuracy.toStringAsFixed(2)}', style: const TextStyle(fontFamily: 'Game', fontSize: 24),
            ),
          ),
        );
      }
    }

    return Column(children: levelTiles);
  }

}