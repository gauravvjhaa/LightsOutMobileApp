import 'package:LightsOut/services/pushing_for_levelwise.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


enum CellState {
  off,
  green,
  red,
}

class LevelWise extends StatefulWidget {
  const LevelWise({Key? key, required this.initialLevel, required this.goodUser}) : super(key: key);

  final int initialLevel;
  final bool goodUser;

  @override
  _LevelWiseState createState() => _LevelWiseState(initialLevel: initialLevel, goodUser: goodUser);
}

class _LevelWiseState extends State<LevelWise> {

  late List<List<CellState>> _states;
  late int _dimVal;
  late int minimumMovesNeeded;
  int movesPlayed = 0;
  late double currAccuracy;
  late int _currentLevel;
  late int _globalLimitLevel;
  bool allowSound = true;
  late bool isLoggedIn;
  late int badUserLimit;

  _LevelWiseState({required int initialLevel, required bool goodUser}) {
    _currentLevel = initialLevel;
    _globalLimitLevel = initialLevel;
    isLoggedIn = goodUser;
  }

  final playerAudio = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _currentLevel = isLoggedIn? widget.initialLevel : 0;
    minimumMovesNeeded = 0;
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    try {
      setState(() {
        _currentLevel = _currentLevel+1;
        updateMinimumMovesNeeded(_currentLevel);
        if (isLoggedIn && _currentLevel > 20){
          _globalLimitLevel = 20;
          _currentLevel = 1;
          updateMinimumMovesNeeded(_currentLevel);
          _initializeLevel(_currentLevel);
        } else if (isLoggedIn && _currentLevel <= 20) {
          _initializeLevel(_currentLevel);
        } else {
          badUserLimit = _currentLevel;
          _initializeLevel(_currentLevel);
        }
      });
    } catch (e) {
      print('Error initializing game: $e');
    }
  }

  Future<int> databaseLevel() async {
    UserRepository2 objectHelper = UserRepository2();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('user not logegd in');
      return 0;
    }

    String userId = user.uid;

    Map<String, dynamic>? userData = await objectHelper.getUserFields(userId, 1);

    if (userData == null || userData['currentLevel'] == null) {
      print('user data not found or doesnot exist');
      return 0;
    }

    return userData['currentLevel'] as int;
  }

  Future<void> updateLocally() async {
    int count = await databaseLevel();
    _globalLimitLevel = count;
  }

  void updateMinimumMovesNeeded(int level){
    if (level == 1){
      minimumMovesNeeded = 3;
    } else if (level == 2){
      minimumMovesNeeded = 3;
    } else if (level == 3){
      minimumMovesNeeded = 4;
    } else if (level == 4){
      minimumMovesNeeded = 4;
    } else if (level == 5){
      minimumMovesNeeded = 7;
    } else if (level == 6){
      minimumMovesNeeded = 3;
    } else if (level == 7){
      minimumMovesNeeded = 3;
    } else if (level == 8){
      minimumMovesNeeded = 4;
    } else if (level == 9){
      minimumMovesNeeded = 4;
    } else if (level == 10){
      minimumMovesNeeded = 7;
    } else if (level == 11){
      minimumMovesNeeded = 7;
    } else if (level == 12){
      minimumMovesNeeded = 11;
    } else if (level == 13){
      minimumMovesNeeded = 11;
    } else if (level == 14){
      minimumMovesNeeded = 11;
    } else if (level == 15){
      minimumMovesNeeded = 13;
    } else if (level == 16){
      minimumMovesNeeded = 7;
    } else if (level == 17){
      minimumMovesNeeded = 11;
    } else if (level == 18){
      minimumMovesNeeded = 11;
    } else if (level == 19){
      minimumMovesNeeded = 11;
    } else if (level == 20){
      minimumMovesNeeded = 13;
    } else {
      minimumMovesNeeded = 100;
    }
  }

  void _initializeLevel(int? level) {
    // Define your level configurations using CellState values
    switch (level) {
      case 1:
        _states = [[CellState.off, CellState.green, CellState.off], [CellState.off, CellState.green, CellState.green], [CellState.green, CellState.green, CellState.green],
          //[100 100 001]
        ];
        break;
      case 2:
        _states = [[CellState.green, CellState.off, CellState.green], [CellState.green, CellState.off, CellState.off], [CellState.off, CellState.green, CellState.green],
          // [101 000 001]
        ];
        break;
      case 3:
        _states = [
          [CellState.off, CellState.off, CellState.green, CellState.green], [CellState.off, CellState.off, CellState.off, CellState.green], [CellState.green, CellState.green, CellState.green, CellState.off], [CellState.off, CellState.green, CellState.off, CellState.green],
          // [0001 0000 0000 1110]
        ];
        break;
      case 4:
        _states = [
          [CellState.off, CellState.green, CellState.green, CellState.green],[CellState.green, CellState.off, CellState.green, CellState.off], [CellState.green, CellState.off, CellState.green, CellState.off], [CellState.off, CellState.off, CellState.off, CellState.green],
          // [0010 0000 1000 0110]
        ];
        break;
      case 5:
        _states = [
          [CellState.green, CellState.off, CellState.green, CellState.green, CellState.green], [CellState.green, CellState.green, CellState.off, CellState.off, CellState.green], [CellState.off, CellState.off, CellState.off, CellState.off, CellState.off], [CellState.green, CellState.off, CellState.green, CellState.green, CellState.green], [CellState.green, CellState.off, CellState.off, CellState.green, CellState.green],
          // [00010 10000 00011 10100 00010]
        ];
        break;
      case 6:
        _states = [
          [CellState.off, CellState.green, CellState.green], [CellState.red, CellState.green, CellState.off], [CellState.off, CellState.red, CellState.red],
          // [001 011 000]
        ];
        break;
      case 7:
        _states = [
          [CellState.red, CellState.off, CellState.red], [CellState.green, CellState.green, CellState.red], [CellState.green, CellState.red, CellState.red],
          // [000 101 100]
        ];
        break;
      case 8:
        _states = [
          [CellState.off, CellState.off, CellState.red, CellState.off], [CellState.red, CellState.red, CellState.red, CellState.red], [CellState.green, CellState.red, CellState.green, CellState.off], [CellState.green, CellState.green, CellState.red, CellState.red],
          // [0000 0010 1000 1010]
        ];
        break;
      case 9:
        _states = [
          [CellState.off, CellState.off, CellState.off, CellState.red],
          [CellState.red, CellState.red, CellState.red, CellState.red],
          [CellState.green, CellState.off, CellState.red, CellState.red],
          [CellState.green, CellState.green, CellState.red, CellState.off],
          // [0000 0001 1100 0100]
        ];
        break;
      case 10:
        _states = [
          [CellState.red, CellState.off, CellState.off, CellState.off, CellState.red],
          [CellState.red, CellState.red, CellState.off, CellState.red, CellState.green],
          [CellState.red, CellState.red, CellState.off, CellState.red, CellState.off],
          [CellState.green, CellState.red, CellState.red, CellState.green, CellState.green],
          [CellState.red, CellState.green, CellState.red, CellState.red, CellState.green],
          // [00000 10001 00001 01001 10010]
        ];
        break;
      case 11:
        _states = [
          [CellState.off, CellState.green, CellState.green, CellState.off, CellState.off],
          [CellState.green, CellState.green, CellState.off, CellState.green, CellState.off],
          [CellState.green, CellState.off, CellState.off, CellState.off, CellState.green],
          [CellState.off, CellState.green, CellState.green, CellState.off, CellState.off],
          [CellState.off, CellState.green, CellState.off, CellState.green, CellState.green],
          // [00000 01100 01000 00001 00111]
        ];
        break;
      case 12:
        _states = [
          [CellState.green, CellState.off, CellState.off, CellState.off, CellState.green, CellState.green],
          [CellState.off, CellState.green, CellState.off, CellState.green, CellState.green, CellState.green],
          [CellState.green, CellState.green, CellState.green, CellState.off, CellState.off, CellState.green],
          [CellState.green, CellState.off, CellState.off, CellState.off, CellState.off, CellState.off],
          [CellState.off, CellState.off, CellState.off, CellState.off, CellState.off, CellState.green],
          [CellState.off, CellState.off, CellState.off, CellState.green, CellState.green, CellState.off],
          // [000001 100000 100110 100000 110110 100000]
        ];
        break;
      case 13:
        _states = [
          [CellState.off, CellState.off, CellState.off, CellState.green, CellState.green, CellState.green],
          [CellState.off, CellState.off, CellState.green, CellState.off, CellState.off, CellState.off],
          [CellState.off, CellState.green, CellState.green, CellState.green, CellState.off, CellState.green],
          [CellState.off, CellState.off, CellState.off, CellState.green, CellState.off, CellState.green],
          [CellState.green, CellState.off, CellState.green, CellState.off, CellState.off, CellState.off],
          [CellState.green, CellState.green, CellState.green, CellState.green, CellState.off, CellState.off],
          // [000010 000000 001010 000110 000110 100111]
        ];
        break;
      case 14:
        _states = [
          [CellState.green, CellState.off, CellState.off, CellState.off, CellState.green, CellState.off],
          [CellState.green, CellState.off, CellState.off, CellState.off, CellState.off, CellState.off],
          [CellState.off, CellState.green, CellState.off, CellState.green, CellState.off, CellState.green],
          [CellState.off, CellState.green, CellState.green, CellState.green, CellState.off, CellState.off],
          [CellState.off, CellState.off, CellState.green, CellState.green, CellState.off, CellState.green],
          [CellState.off, CellState.off, CellState.off, CellState.green, CellState.off, CellState.green],
          // [000000 100010 010111 000101 000110 000001]
        ];
        break;
      case 15:
        _states = [
          [CellState.off, CellState.off, CellState.green, CellState.off, CellState.off, CellState.green, CellState.off],
          [CellState.off, CellState.off, CellState.off, CellState.green, CellState.green, CellState.green, CellState.green],
          [CellState.off, CellState.green, CellState.green, CellState.green, CellState.green, CellState.off, CellState.green],
          [CellState.green, CellState.off, CellState.off, CellState.off, CellState.off, CellState.off, CellState.off],
          [CellState.off, CellState.off, CellState.off, CellState.green, CellState.green, CellState.off, CellState.green],
          [CellState.off, CellState.off, CellState.green, CellState.green, CellState.green, CellState.green, CellState.green],
          [CellState.off, CellState.off, CellState.green, CellState.off, CellState.off, CellState.off, CellState.off],
          // [0001100 0000000 0000011 0111001 0010100 0000010 0001100]
        ];
        break;
      case 16:
        _states = [
          [CellState.off, CellState.off, CellState.red, CellState.green, CellState.red],
          [CellState.off, CellState.red, CellState.off, CellState.green, CellState.off],
          [CellState.off, CellState.red, CellState.off, CellState.off, CellState.red],
          [CellState.off, CellState.red, CellState.off, CellState.red, CellState.red],
          [CellState.off, CellState.red, CellState.green, CellState.red, CellState.off],
          // [00001 00110 00101 00100 00100]
        ];
        break;
      case 17:
        _states = [
          [CellState.off, CellState.off, CellState.red, CellState.green, CellState.red, CellState.red],
          [CellState.red, CellState.red, CellState.green, CellState.green, CellState.green, CellState.red],
          [CellState.red, CellState.green, CellState.green, CellState.red, CellState.red, CellState.red],
          [CellState.off, CellState.off, CellState.green, CellState.red, CellState.red, CellState.red],
          [CellState.green, CellState.off, CellState.green, CellState.red, CellState.green, CellState.red],
          [CellState.red, CellState.red, CellState.off, CellState.red, CellState.green, CellState.red],
          // [000010 001100 100001 011000 110010 000010]
        ];
        break;
      case 18:
        _states = [
          [CellState.green, CellState.green, CellState.green, CellState.red, CellState.red, CellState.red],
          [CellState.off, CellState.red, CellState.green, CellState.red, CellState.red, CellState.red],
          [CellState.green, CellState.green, CellState.green, CellState.off, CellState.red, CellState.red],
          [CellState.red, CellState.green, CellState.red, CellState.red, CellState.off, CellState.green],
          [CellState.red, CellState.red, CellState.green, CellState.red, CellState.red, CellState.red],
          [CellState.off, CellState.red, CellState.red, CellState.red, CellState.red, CellState.red],
          // [010010 111000 100001 001000 010001 000100]
        ];
        break;
      case 19:
        _states = [
          [CellState.off, CellState.off, CellState.green, CellState.green, CellState.off, CellState.red],
          [CellState.off, CellState.green, CellState.green, CellState.off, CellState.green, CellState.red],
          [CellState.red, CellState.green, CellState.off, CellState.red, CellState.red, CellState.off],
          [CellState.red, CellState.green, CellState.red, CellState.off, CellState.red, CellState.off],
          [CellState.off, CellState.green, CellState.green, CellState.red, CellState.red, CellState.red],
          [CellState.green, CellState.off, CellState.red, CellState.red, CellState.red, CellState.off],
          // [000110 001010 011000 000000 110010 101000]
        ];
        break;
      case 20:
        _states = [
          [CellState.red, CellState.green, CellState.green, CellState.green, CellState.red, CellState.green, CellState.red],
          [CellState.red, CellState.red, CellState.red, CellState.green, CellState.green, CellState.off, CellState.red],
          [CellState.green, CellState.off, CellState.off, CellState.green, CellState.off, CellState.off, CellState.off],
          [CellState.red, CellState.off, CellState.red, CellState.off, CellState.off, CellState.off, CellState.off],
          [CellState.green, CellState.green, CellState.green, CellState.off, CellState.off, CellState.off, CellState.red],
          [CellState.red, CellState.off, CellState.green, CellState.red, CellState.off, CellState.red, CellState.red],
          [CellState.off, CellState.red, CellState.red, CellState.off, CellState.off, CellState.off, CellState.red],
          // [0100101 0111000 0110000 1000000 0100000 0110001 0000000]
        ];
        break;
    }
    _dimVal = _states.length;
  }

  bool isTwoState(int currlevel){
    if (currlevel>=1 && currlevel<=5){
      return true;
    } else if (currlevel>=11 && currlevel<=15){
      return true;
    } else {
      return false;
    }
  }

  void _navigateToLevel(int newLevel) {
    print('allowSound is: $allowSound');
    if (allowSound) {
      print('Playing sound...');
      playerAudio.play(AssetSource('tap.mp3'));
    } else {
      print('Sound is disabled.');
    }
    setState(() {
      _currentLevel = newLevel;
      updateMinimumMovesNeeded(_currentLevel);
      _initializeLevel(_currentLevel);
      movesPlayed = 0;
    });
  }

  void _nextLevel() {
    print('allowSound is: $allowSound');
    if (allowSound) {
      print('Playing sound...');
      playerAudio.play(AssetSource('tap.mp3'));
    } else {
      print('Sound is disabled.');
    }

    updateLocally();
    if(isLoggedIn){
      if (_currentLevel < (_globalLimitLevel)) {
        setState(() {
          _currentLevel++;
          _initializeLevel(_currentLevel);
        });
      } else {
        if(_currentLevel==20){
          _showCompletionDialog(context);
        } else {
          showAccessDeniedDialog(context);
        }
      }
    } else {
      if (badUserLimit < _currentLevel){
        print('bhai');
        showAccessDeniedDialog(context);
      } else {
        print('you are in, bro');
        setState(() {
          _currentLevel++;
          _initializeLevel(_currentLevel);
        });
      }
    }
    movesPlayed = 0;
  }

  void _currLevel() {
    print('allowSound is: $allowSound');
    if (allowSound) {
      print('Playing sound...');
      playerAudio.play(AssetSource('tap.mp3'));
    } else {
      print('Sound is disabled.');
    }

    if (_currentLevel > 0) {
      _navigateToLevel(_currentLevel);
    }
    movesPlayed = 0;
  }

  void _prevLevel() {
    print('allowSound is: $allowSound');
    if (allowSound) {
      print('Playing sound...');
      playerAudio.play(AssetSource('tap.mp3'));
    } else {
      print('Sound is disabled.');
    }

    if (_currentLevel > 1) {
      _navigateToLevel(_currentLevel - 1);
    }
    movesPlayed = 0;
  }

  void showAccessDeniedDialog(BuildContext context) {
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
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Access Denied',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Solve previous levels to access next ones.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Congratulations on Finishing all the challenges!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'More Levels will be added soon... Till then enjoy Free Mode Puzzles',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
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

  double calculateAccuracyInDouble(int min, int max, {int decimalPlaces = 2}) {
    if (max == 0) {
      throw ArgumentError('Max value must be greater than zero.');
    }
    double accuracy = (min * 100) / max;
    double formattedValue = double.parse(accuracy.toStringAsFixed(decimalPlaces));
    return formattedValue;
  }

  void updateUser() async {
    UserRepository2 userRepository = UserRepository2();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;
      int level = _currentLevel;
      double currAccuracy = calculateAccuracyInDouble(minimumMovesNeeded, movesPlayed);

      await userRepository.updateLevelAndAccuracy(userId, level, currAccuracy);
    } else {
      print('No user is currently logged in.');
    }
  }

  bool _checkFinished(states) {
    for (int i = 0; i < states.length; i++) {
      for (int j = 0; j < states.length; j++) {
        if (states[i][j] != CellState.off) {
          print(_currentLevel);
          print(badUserLimit);
          return false;
        }
      }
    }
    currAccuracy = calculateAccuracyInDouble(minimumMovesNeeded, movesPlayed);
    if(allowSound){
      playerAudio.play(AssetSource('success.mp3'));
    }
    setState(() {
      if(isLoggedIn==false){
        badUserLimit = _currentLevel;
      }
      _showSuccessDialog(context);
    });
    updateUser();
    return true;
  }

  void _showSuccessDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            constraints: const BoxConstraints(maxWidth: 300.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Congratulations! Puzzle Solved',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Moves Taken: $movesPlayed',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Target Moves: $minimumMovesNeeded',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_currentLevel<20){
                      Navigator.of(context).pop();
                      _navigateToLevel(_currentLevel + 1);
                    } else {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      _showCompletionDialog(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                  ),
                  child: const Text(
                    'Next Level',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
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

  void _toggleCell(int x, int y) {
    if (x >= 0 && x < _dimVal && y >= 0 && y < _dimVal) {
      setState(() {
        _toggleSingleCell(x, y);
        _toggleSingleCell(x - 1, y); // Left
        _toggleSingleCell(x + 1, y); // Right
        _toggleSingleCell(x, y - 1); // Up
        _toggleSingleCell(x, y + 1); // Down
      });
    }
    if(allowSound){
      playerAudio.play(AssetSource('tap.mp3'));
    }
    movesPlayed++;
    _checkFinished(_states);
  }

  void _toggleSingleCell(int x, int y) {
    if (x >= 0 && x < _dimVal && y >= 0 && y < _dimVal && isTwoState(_currentLevel) == true) {
      if (_states[x][y] == CellState.off) {
        _states[x][y] = CellState.green;
      } else if (_states[x][y] == CellState.green) {
        _states[x][y] = CellState.off;
      }
    } else if (x >= 0 && x < _dimVal && y >= 0 && y < _dimVal && isTwoState(_currentLevel) == false){
      if (_states[x][y] == CellState.off) {
        _states[x][y] = CellState.green;
      } else if (_states[x][y] == CellState.green) {
        _states[x][y] = CellState.red;
      } else {
        _states[x][y] = CellState.off;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text('Level $_currentLevel', style: const TextStyle(fontFamily: 'Game'),),
        actions: [
          //mute button
          IconButton(
            onPressed: () {
              setState(() {
                allowSound = !allowSound;
                print('Sound Enabled: $allowSound'); // Add this line for debugging
                if (allowSound == true) {
                  playerAudio.play(AssetSource('tap.mp3'));
                }
              });
            },
            icon: allowSound? const Icon(Icons.volume_up_sharp) : const Icon(Icons.volume_off),
            padding: const EdgeInsets.only(right: 25),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/background_image_two.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Game Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 140),
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Text(
              //         'Minimum Moves Req : ',
              //         style: TextStyle(
              //           fontSize: 29,
              //           fontFamily: 'Game',
              //         ),
              //       ),
              //       Text(
              //         '$minimumMovesNeeded',
              //         style: const TextStyle(
              //           fontSize: 33,
              //           fontFamily: 'Game',
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 10.0),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.brown[200],
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _dimVal,
                    ),
                    itemCount: _dimVal * _dimVal,
                    itemBuilder: (context, index) {
                      final x = index % _dimVal;
                      final y = index ~/ _dimVal;
                      final cellState = _states[y][x];
                      return GridCell(
                        state: cellState,
                        onTap: () => _toggleCell(y, x),
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _prevLevel,
                    child: const Text(
                      'Previous Level',
                      style: TextStyle(
                        fontFamily: 'Game',
                        fontSize: 24,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextLevel,
                    child: const Text(
                      'Next Level',
                      style: TextStyle(
                        fontFamily: 'Game',
                        fontSize: 24,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _currLevel,
                child: Text(
                  'Restart Level',
                  style: TextStyle(
                    fontFamily: 'Game',
                    fontSize: 22,
                    color: Colors.blue[200],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GridCell extends StatelessWidget {
  final CellState state;
  final VoidCallback onTap;
  final bool isDarkMode;

  GridCell({Key? key, required this.state, required this.onTap, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (state) {
      case CellState.off:
        color = Colors.black;
        break;
      case CellState.green:
        color = Colors.lightGreenAccent;
        break;
      case CellState.red:
        color = Colors.red;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: isDarkMode ? Colors.black : Colors.black, width: isDarkMode? 5 : 4),
        ),
      ),
    );
  }
}
