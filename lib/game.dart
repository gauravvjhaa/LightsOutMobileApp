import 'dart:async';
import 'dart:math';
import 'package:LightsOut/services/edit_and_push_to_backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'maths/math.dart';

enum CellState {
  off, //states = 0
  red, //states = 1
  green, //states = 2
  blue, //states = 3
  orange, //states = 4
}

class Game extends StatefulWidget {
  const Game({super.key, required this.dim, required this.states});
  final int dim;
  final int states;

  @override
  _GameState createState() => _GameState(dim: dim, states: states);
}

class _GameState extends State<Game> {
  _GameState({required this.dim, required this.states});

  late List<List<CellState>> _states;
  late List<List<CellState>> _initialStates;
  late List<List<int>> _toggleCount =
      List.generate(dim, (_) => List.filled(dim, 0));
  int dim;
  int states;
  bool _gameOver = false;
  int _numSteps = 0;
  String _timeUsed = '00:00:00';
  double _timeUsedDecimal = 0.0;
  DateTime? _startTime;
  DateTime? _stopTime;
  bool _showingSolution = false; // Initialize to false
  int _minimumMovesNeeded = 0;
  late double curAccuracy;
  late String curTimeTaken;
  late List<List<int>> minSumArray;
  bool viewedSolution = false;
  bool allowSound = true;
  final playerAudio = AudioPlayer();


  @override
  void initState() {
    super.initState();
    _states = List.generate(dim, (_) => List.filled(dim, CellState.off));
    _initialStates = List.generate(dim, (_) => List.filled(dim, CellState.off));
    _randomize();
  }

  void updateUser() async {
    UserRepository userRepository = UserRepository();
    final User? user = FirebaseAuth.instance.currentUser; // Get the currently authenticated user

    if (user != null) {
      String userId = user.uid;
      int state = states;
      int dimension = dim;
      double currAccuracy = calculateAccuracyInDouble(_minimumMovesNeeded, _numSteps);
      double currTimeTaken = _timeUsedDecimal;

      await userRepository.updateUserDataYes(userId, currAccuracy, currTimeTaken, state, dimension);
    } else {
      print('No user is currently logged in.');
    }
  }

  void resetToggleMatrix() {
    _toggleCount = List.generate(dim, (_) => List.filled(dim, 0));
  }

  void startTimer() {
    _startTime = DateTime.now();
    Timer.periodic(const Duration(milliseconds: 1), (_) {
      _updateTimeUsed();
    });
  }

  void stopTimer() {
    _stopTime = DateTime.now();
  }

  void resetTimer() {
    _startTime = null;
    _stopTime = null;
  }

  Duration? getElapsedTime() {
    if (_startTime != null) {
      if (_stopTime != null) {
        return _stopTime!.difference(_startTime!);
      } else {
        return DateTime.now().difference(_startTime!);
      }
    }
    return null;
  }

  double convertDurationToDouble(Duration duration) {
    double totalSeconds = duration.inMilliseconds / 1000.0;
    return double.parse(totalSeconds.toStringAsFixed(2));
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds = twoDigits(
        duration.inMilliseconds.remainder(1000) ~/
            10); // Take the first two characters
    return "$twoDigitMinutes:$twoDigitSeconds:$twoDigitMilliseconds";
  }

  void _updateTimeUsed() {
    Duration? elapsedTime = getElapsedTime();
    if (elapsedTime != null && (mounted)) {
      setState(() {
        _timeUsed = formatDuration(elapsedTime);
        _timeUsedDecimal = convertDurationToDouble(elapsedTime);
      });
    } else {
      _timeUsed = '00:00:00';
    }
  }

  String _winFormatTime(int timeUsedInMilliseconds) {
    try {
      int minutes = timeUsedInMilliseconds ~/ 60000;
      int seconds = (timeUsedInMilliseconds % 60000) ~/ 1000;
      int milliseconds = timeUsedInMilliseconds % 1000;

      if (minutes == 0) {
        if (milliseconds == 0) {
          return "$seconds s";
        } else {
          return "$seconds s & $milliseconds ms";
        }
      } else {
        if (seconds == 0) {
          return "$minutes m";
        } else if (milliseconds == 0) {
          return "$minutes m & $seconds s";
        } else {
          return "$minutes m, $seconds s, & $milliseconds ms";
        }
      }
    } catch (e) {
      return 'Invalid time format';
    }
  }

  //
  void _randomize() {
    setState(() {
      for (int i = 0; i < _states.length; i++) {
        for (int j = 0; j < _states[i].length; j++) {
          _states[i][j] = CellState.values[0];
        }
      }
      _generateRandomPattern();
      _initialStates = List.from(_states);
      _numSteps = 0;
      _showingSolution = false;
      _gameOver = false;
      startTimer();
    });
  }

  String calculateAccuracy(int min, int max) {
    curAccuracy = (min * 100) / max;
    String formattedValue = curAccuracy.toStringAsFixed(2);
    return formattedValue;
  }

  double calculateAccuracyInDouble(int min, int max, {int decimalPlaces = 2}) {
    if (max == 0) {
      throw ArgumentError('Max value must be greater than zero.');
    }
    double accuracy = (min * 100) / max;
    double formattedValue = double.parse(accuracy.toStringAsFixed(decimalPlaces));
    return formattedValue;
  }

  void _generateRandomPattern() {
    late int numLights;
    switch (dim) {
      case 3:
        switch (states) {
          case 2:
            numLights = 3 * 1;
            break;
          case 3:
            numLights = 3 * 2;
            break;
          case 4:
            numLights = 3 * 3;
            break;
          case 5:
            numLights = 3 * 4;
            break;
        }

      case 4:
        switch (states) {
          case 2:
            numLights = 4 * 1;
            break;
          case 3:
            numLights = 4 * 2;
            break;
          case 4:
            numLights = 4 * 3;
            break;
          case 5:
            numLights = 4 * 4;
            break;
        }

      case 5:
        switch (states) {
          case 2:
            numLights = 6 * 1;
            break;
          case 3:
            numLights = 6 * 2;
            break;
          case 4:
            numLights = 6 * 3;
            break;
          case 5:
            numLights = 6 * 4;
            break;
        }

      case 6:
        switch (states) {
          case 2:
            numLights = 10 * 1;
            break;
          case 3:
            numLights = 10 * 2;
            break;
          case 4:
            numLights = 10 * 3;
            break;
          case 5:
            numLights = 10 * 4;
            break;
        }

      case 7:
        switch (states) {
          case 2:
            numLights = 13 * 1;
            break;
          case 3:
            numLights = 13 * 2;
            break;
          case 4:
            numLights = 13 * 3;
            break;
          case 5:
            numLights = 13 * 4;
            break;
        }

      case 8:
        switch (states) {
          case 2:
            numLights = 16 * 1;
            break;
          case 3:
            numLights = 16 * 2;
            break;
          case 4:
            numLights = 16 * 3;
            break;
          case 5:
            numLights = 16 * 4;
            break;
        }

      case 9:
        switch (states) {
          case 2:
            numLights = 22 * 1;
            break;
          case 3:
            numLights = 22 * 2;
            break;
          case 4:
            numLights = 22 * 3;
            break;
          case 5:
            numLights = 22 * 4;
            break;
        }

      case 10:
        switch (states) {
          case 2:
            numLights = 30 * 1;
            break;
          case 3:
            numLights = 30 * 2;
            break;
          case 4:
            numLights = 30 * 3;
            break;
          case 5:
            numLights = 30 * 4;
            break;
        }
    }

    List<List<int>> clickCounts = List.generate(
      dim,
      (_) => List.filled(dim, 0),
    ); // Track click counts for each cell

    while (numLights > 0) {
      int x = Random().nextInt(dim);
      int y = Random().nextInt(dim);
      if (clickCounts[x][y] < states) {
        for (int k = 1; k < states; k++) {
          _preToggleCell(x, y); // Toggle the cell
          clickCounts[x][y] = clickCounts[x][y] +
              states; // Increment the click count for the cell
          numLights--;
        }
      }
    }
  }

  void _reset() {
    setState(() {
      _toggleCount = [];
      _states = List.from(_initialStates);
      resetTimer();
      Navigator.of(context).pop();
    });
  }

  void _preToggleCell(int x, int y) {
    _toggleState(x, y);
    _toggleStateIfValid(x - 1, y);
    _toggleStateIfValid(x + 1, y);
    _toggleStateIfValid(x, y - 1);
    _toggleStateIfValid(x, y + 1);
    _toggleCount[x][y]++;
    _minimumMovesNeeded = calculateSum(_toggleCount);

    if (states == 2 && dim == 5) {
      minSumArray = processArrayForFive(_toggleCount, 2);
      _minimumMovesNeeded = calculateSum(minSumArray);
    }
  }

  int calculateSum(List<List<int>> inputList) {
    int numRows = inputList.length;
    int numCols = inputList.isEmpty ? 0 : inputList[0].length;
    int sum = 0;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        int value = inputList[i][j];
        if (value == 0) {
          sum += 0;
        } else {
          sum += (states - value);
        }
      }
    }
    return sum;
  }

  void _tappedItems(int x, int y) {
    setState(() {
      _toggleCell(x, y);
      _numSteps++;
      if (_checkFinished()) {
        _gameOver = true;
        stopTimer();
      }
    });
  }

  List<List<int>> processArrayForFiveAgain(List<List<int>> inputArray, modulo) {
    final v1 = [
      [0,2,1,1,1],
      [1,0,2,0,1],
      [2,1,0,2,1],
      [2,0,1,0,2],
      [2,2,2,1,0],
    ];

    final v2 = [
      [2,0,1,0,2],
      [1,0,2,0,1],
      [0, 0, 0, 0, 0],
      [2,0,1,0,2],
      [1,0,2,0,1],
    ];

    List<List<int>> result01 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result02 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result03 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result10 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result11 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result12 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result13 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result20 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result21 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result22 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result23 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result30 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result31 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result32 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result33 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));

    for (int i = 0; i < inputArray.length; i++) {
      for (int j = 0; j < inputArray[i].length; j++) {
        result01[i][j] = (inputArray[i][j] + v2[i][j]) % states;
        result02[i][j] = (inputArray[i][j] + (2*v2[i][j])) % states;
        result03[i][j] = (inputArray[i][j] + (3*v2[i][j])) % states;
        result21[i][j] = (inputArray[i][j] + (2*v1[i][j]) + (1*v2[i][j])) % states;
        result22[i][j] = (inputArray[i][j] + (2*v1[i][j]) + (2*v2[i][j])) % states;
        result23[i][j] = (inputArray[i][j] + (2*v1[i][j]) + (3*v2[i][j])) % states;
        result30[i][j] = (inputArray[i][j] + (3*v1[i][j])) % states;
        result31[i][j] = (inputArray[i][j] + (3*v1[i][j]) + (1*v2[i][j])) % states;
        result32[i][j] = (inputArray[i][j] + (3*v1[i][j]) + (2*v2[i][j])) % states;
        result33[i][j] = (inputArray[i][j] + (3*v1[i][j]) + (3*v2[i][j])) % states;
        result10[i][j] = (inputArray[i][j] + v1[i][j]) % states;
        result11[i][j] = (inputArray[i][j] + v1[i][j] + v2[i][j]) % states;
        result12[i][j] = (inputArray[i][j] + v1[i][j] + (2*v2[i][j])) % states;
        result13[i][j] = (inputArray[i][j] + v1[i][j] + (3*v2[i][j])) % states;
        result20[i][j] = (inputArray[i][j] + (2*v1[i][j])) % states;
      }
    }

    return MathHelper.findMinSumArray16(result01, result02, result03, result10,
        result11, result12, result13, result20,
        result21, result22, result23, result30,
        result31, result32, result33, inputArray);
  }

  List<List<int>> processArrayFor3State5Dim(List<List<int>> inputArray, modulo) {
    final v1 = [
      [0,2,1,1,1],
      [1,0,2,0,1],
      [2,1,0,2,1],
      [2,0,1,0,2],
      [2,2,2,1,0],
    ];

    final v2 = [
      [2,0,1,0,2],
      [1,0,2,0,1],
      [0,0,0,0,0],
      [2,0,1,0,2],
      [1,0,2,0,1],
    ];

    List<List<int>> result01 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result02 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result10 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result11 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result12 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result20 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result21 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result22 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));

    for (int i = 0; i < inputArray.length; i++) {
      for (int j = 0; j < inputArray[i].length; j++) {
        result01[i][j] = (inputArray[i][j] + v2[i][j]) % states;
        result02[i][j] = (inputArray[i][j] + (2*v2[i][j])) % states;
        result21[i][j] = (inputArray[i][j] + (2*v1[i][j]) + (1*v2[i][j])) % states;
        result22[i][j] = (inputArray[i][j] + (2*v1[i][j]) + (2*v2[i][j])) % states;
        result10[i][j] = (inputArray[i][j] + v1[i][j]) % states;
        result11[i][j] = (inputArray[i][j] + v1[i][j] + v2[i][j]) % states;
        result12[i][j] = (inputArray[i][j] + v1[i][j] + (2*v2[i][j])) % states;
        result20[i][j] = (inputArray[i][j] + (2*v1[i][j])) % states;
      }
    }

    return MathHelper.findMinSumArrayFor9(result01, result02, result10,
        result11, result12, result20,
        result21, result22, inputArray);
  }

  List<List<int>> processArrayForFive(List<List<int>> inputArray, modulo) {
    final v1 = [
      [0, 1, 1, 1, 0],
      [1, 0, 1, 0, 1],
      [1, 1, 0, 1, 1],
      [1, 0, 1, 0, 1],
      [0, 1, 1, 1, 0],
    ];

    final v2 = [
      [1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1],
      [0, 0, 0, 0, 0],
      [1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1],
    ];

    List<List<int>> result10 =
        List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result01 =
        List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result11 =
        List.generate(dim, (index) => List<int>.filled(dim, 0));

    for (int i = 0; i < inputArray.length; i++) {
      for (int j = 0; j < inputArray[i].length; j++) {
        result10[i][j] = (inputArray[i][j] + v1[i][j]) % states;
        result01[i][j] = (inputArray[i][j] + v2[i][j]) % states;
        result11[i][j] = (inputArray[i][j] + v1[i][j] + v2[i][j]) % states;
      }
    }

    return MathHelper.findMinSumArray(result01, result10, result11, inputArray);
  }

  List<List<int>> processArrayForFour(List<List<int>> inputArray, modulo) {
    final v1 = [
      [0,1,1,1],
      [1,0,1,0],
      [1,1,0,0],
      [1,0,0,0]
    ];

    final v2 = [
      [1,1,0,1],
      [0,0,0,1],
      [1,1,1,0],
      [0,1,0,0]
    ];

    final v3 = [
      [1,0,1,1],
      [1,0,0,0],
      [0,1,1,1],
      [0,0,1,0]
    ];

    final v4 = [
      [1,1,1,0],
      [0,1,0,1],
      [0,0,1,1],
      [0,0,0,1]
    ];

    List<List<int>> result0001 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result0010 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result0011 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result0100 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result0101 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result0110 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result0111 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result1000 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result1001 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result1010 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result1011 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result1100 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result1101 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result1110 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));
    List<List<int>> result1111 =
    List.generate(dim, (index) => List<int>.filled(dim, 0));

    for (int i = 0; i < inputArray.length; i++) {
      for (int j = 0; j < inputArray[i].length; j++) {
        result0001[i][j] = (inputArray[i][j] + v4[i][j]) % states;
        result0010[i][j] = (inputArray[i][j] + v3[i][j]) % states;
        result0011[i][j] = (inputArray[i][j] + v3[i][j] + v4[i][j]) % states;
        result0100[i][j] = (inputArray[i][j] + v2[i][j]) % states;
        result0101[i][j] = (inputArray[i][j] + v2[i][j] + v4[i][j]) % states;
        result0110[i][j] = (inputArray[i][j] + v2[i][j] + v3[i][j]) % states;
        result0111[i][j] = (inputArray[i][j] + v2[i][j] + v3[i][j]+ v4[i][j]) % states;
        result1000[i][j] = (inputArray[i][j] + v1[i][j]) % states;
        result1001[i][j] = (inputArray[i][j] + v1[i][j] + v4[i][j]) % states;
        result1010[i][j] = (inputArray[i][j] + v1[i][j] + v3[i][j]) % states;
        result1011[i][j] = (inputArray[i][j] + v1[i][j] + v3[i][j] + v4[i][j]) % states;
        result1100[i][j] = (inputArray[i][j] + v1[i][j] + v2[i][j]) % states;
        result1101[i][j] = (inputArray[i][j] + v1[i][j] + v2[i][j] + v4[i][j]) % states;
        result1110[i][j] = (inputArray[i][j] + v1[i][j] + v2[i][j] + v3[i][j]) % states;
        result1111[i][j] = (inputArray[i][j] + v1[i][j] + v2[i][j] + v3[i][j] + v4[i][j]) % states;
      }
    }

    return MathHelper.findMinSumArray16(result0001, result0010, result0011, result0100,
        result0101, result0110, result0111, result1000,
        result1001, result1010, result1011, result1100,
        result1101, result1110, result1111, inputArray);
  }

  void _toggleCell(int x, int y) {
    _toggleState(x, y);
    _toggleStateIfValid(x - 1, y);
    _toggleStateIfValid(x + 1, y);
    _toggleStateIfValid(x, y - 1);
    _toggleStateIfValid(x, y + 1);

    _toggleCount[x][y] = (_toggleCount[x][y] + 1) % states;
    //_minimumMovesNeeded = _calculateTotalOnes(_toggleCount);
    generateConstantsAndUpdate();
  }

  void generateConstantsAndUpdate() {
    List<double> constants = [];
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        int stateValue = _states[i][j].index;
        constants.add(stateValue.toDouble());
      }
    }
  }

  void _toggleStateIfValid(int x, int y) {
    if (x >= 0 && x < dim && y >= 0 && y < dim) {
      _toggleState(x, y);
    }
  }

  void _toggleState(int x, int y) {
    if (_states[x][y] == CellState.off) {
      _states[x][y] = CellState.values[1];
    } else {
      int nextIndex = (_states[x][y].index + 1) % states;
      _states[x][y] = CellState.values[nextIndex];
    }
  }

  bool _checkFinished() {
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        if (_states[i][j] != CellState.off) {
          return false;
        }
      }
    }
    if (allowSound == true){
      playerAudio.play(AssetSource('success.mp3'));
    }
    stopTimer();
    calculateAccuracy(_minimumMovesNeeded, _numSteps);
    curTimeTaken = _winFormatTime(getElapsedTime()!.inMilliseconds);
    if (viewedSolution == false){
      updateUser();
    }
    return true;
  }

  Widget _buildGridItems(BuildContext context, int index, bool isDarkMode) {
    int stateLength = _states.length;
    int x = (index / stateLength).floor();
    int y = (index % stateLength);
    Color color;
    Color textColor = Colors.white; // Default text color
    String? numberText; // Initialize to null
    switch (_states[x][y]) {
      case CellState.off:
        color = Colors.black;
        break;
      case CellState.red:
        color = Colors.red;
        break;
      case CellState.green:
        color = Colors.lightGreenAccent;
        if (states > 2) {
          textColor =
              Colors.black; // Set text color to black for better visibility
        }
        break;
      case CellState.blue:
        color = Colors.blue;
        if (states > 2) {
          textColor =
              Colors.black; // Set text color to black for better visibility
        }
        break;
      case CellState.orange:
        color = Colors.orange;
        if (states > 2) {
          textColor =
              Colors.black; // Set text color to black for better visibility
        }
        break;
    }


    //via state management (fast) //now kind of hybrid
    if (_showingSolution == true &&
        _toggleCount.isNotEmpty &&
        _toggleCount.length > x &&
        _toggleCount[x].length > y &&
        states == 2 &&
        dim == 5) {
      minSumArray = processArrayForFive(_toggleCount, 2);
      //_minimumMovesNeeded = _calculateTotalOnes(minSumArray);
      numberText =
          minSumArray[x][y] == 0 ? '0' : '${states - minSumArray[x][y]}';
    } else if ((_showingSolution == true &&
        _toggleCount.isNotEmpty &&
        _toggleCount.length > x &&
        _toggleCount[x].length > y &&
        states == 3 &&
        dim == 5)){
      minSumArray = processArrayFor3State5Dim(_toggleCount, 3);
      //_minimumMovesNeeded = _calculateTotalOnes(minSumArray);
      numberText =
      minSumArray[x][y] == 0 ? '0' : '${states - minSumArray[x][y]}';
    } else if ((_showingSolution == true &&
        _toggleCount.isNotEmpty &&
        _toggleCount.length > x &&
        _toggleCount[x].length > y &&
        states == 4 &&
        dim == 5)){
      minSumArray = processArrayForFiveAgain(_toggleCount, 4);
      //_minimumMovesNeeded = _calculateTotalOnes(minSumArray);
      numberText =
      minSumArray[x][y] == 0 ? '0' : '${states - minSumArray[x][y]}';
    } else if (_showingSolution == true &&
        _toggleCount.isNotEmpty &&
        _toggleCount.length > x &&
        _toggleCount[x].length > y) {
      //_minimumMovesNeeded = _calculateTotalOnes(_toggleCount);
      numberText =
      _toggleCount[x][y] == 0 ? '0' : '${states - _toggleCount[x][y]}';
    }


    return GestureDetector(
      onTap: () {
        if(allowSound==true){
          playerAudio.play(AssetSource('tap.mp3'));
        }
        _tappedItems(x, y);
      },
      child: GridTile(
        child: Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
                color: isDarkMode ? Colors.white : Colors.black, width: isDarkMode? 1 : 3),
          ),
          child: Stack(
            children: [
              Container(
                color: color,
              ),
              if (numberText != null) // Display the number if it's not null
                Center(
                  child: Text(
                    numberText,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // Set a bigger font size for the numbers
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: isDarkMode? Colors.black45 :Colors.grey.shade400,
        title: const Text(
          'L i g h t s   O u t',
          style: TextStyle(fontFamily: 'Game', fontSize: 19),
        ),
        actions: [
          //mute
          IconButton(
              onPressed: (){
                allowSound = !allowSound;
                if (allowSound==true){
                  playerAudio.play(AssetSource('tap.mp3'));
                }
              },
              icon: allowSound? const Icon(Icons.volume_up_sharp) : const Icon(Icons.volume_off),
            padding: const EdgeInsets.only(right: 28),
          )
        ],
      ),
      body: _gameOver
          ? PopScope(
              canPop: true,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image with Opacity
                  Opacity(
                    opacity: isDarkMode ? 0.1 : 0.4, // Adjusting opacity here (0.0 to 1.0)
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background_image_two.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 70),
                          Text(
                            'Congrats',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDarkMode? Colors.lightGreenAccent : Colors.black,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Game"),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0), // Adjust padding as needed
                            decoration: BoxDecoration(
                              color: isDarkMode? Colors.black87 : Colors.white,
                              border: Border.all(
                                color: Colors.black, // Set border color here
                                width: 5.0, // Set border width here
                              ),
                              borderRadius: BorderRadius.circular(10.0), // Optional: Adds rounded corners
                            ),
                            child: Text(
                              'You Solved the puzzle',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDarkMode ? Colors.pinkAccent : Colors.brown,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Game',
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 43),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.black87 : Colors.yellowAccent[100],
                              border: Border.all(
                                color: Colors.black,
                                width: 5.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Minimum Steps Req.:',
                                      style: TextStyle(fontSize: 25.0, fontFamily: 'Game'),
                                    ),
                                    Text(
                                      '$_minimumMovesNeeded',
                                      style: const TextStyle(fontSize: 25.0, fontFamily: 'Game'),
                                    ),
                                  ],
                                ),
                                // Row for "Steps Taken"
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Steps Taken:',
                                      style: TextStyle(fontSize: 25.0, fontFamily: 'Game'),
                                    ),
                                    Text(
                                      '$_numSteps',
                                      style: const TextStyle(fontSize: 25.0, fontFamily: 'Game'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Accuracy:',
                                      style: TextStyle(fontSize: 25.0, fontFamily: 'Game'),
                                    ),
                                    Text(
                                      '${calculateAccuracy(_minimumMovesNeeded, _numSteps)} %',
                                      style: const TextStyle(fontSize: 25.0, fontFamily: 'Game'),
                                    ),
                                  ],
                                ),
                                // Row for "Time Taken"
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Time Taken:',
                                        style: TextStyle(fontSize: 25.0, fontFamily: 'Game'),
                                      ),
                                      const SizedBox(width: 30),
                                      Text(
                                        curTimeTaken,
                                        style: const TextStyle(fontSize: 25.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 66),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: MaterialButton(
                                  height: 50,
                                  color: isDarkMode? Colors.black87 : Colors.lightGreen[200],
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (allowSound == true){
                                      playerAudio.play(AssetSource('tap.mp3'));
                                    }
                                    viewedSolution = false;
                                    resetTimer();
                                    resetToggleMatrix();
                                    _randomize();
                                  },
                                  child: Text(
                                    'Try Another?',
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: isDarkMode? Colors.white : Colors.black,
                                      fontFamily: 'Game',
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: MaterialButton(
                                  height: 50,
                                  color: isDarkMode? Colors.black87 : Colors.lightGreen[200],
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (allowSound==true){
                                      playerAudio.play(AssetSource('tap.mp3'));
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'BACK',
                                    style: TextStyle(
                                      fontSize: 28.0,
                                      color: isDarkMode? Colors.white : Colors.black,
                                      fontFamily: 'Game',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : PopScope(
              canPop: true,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Opacity(
                    opacity: 0.1, // Adjusting opacity here (0.0 to 1.0)
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background_image_two.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Moves Required : ',
                                style: TextStyle(
                                  fontSize: 29,
                                  fontFamily: 'Game',
                                ),
                              ),
                              Text(
                                '$_minimumMovesNeeded',
                                style: const TextStyle(
                                  fontSize: 33,
                                  fontFamily: 'Game',
                                ),
                              ),
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border: Border.all(width: 10.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: dim,
                                ),
                                itemCount: (dim * dim),
                                itemBuilder: (context, index) {
                                  // Calculate x and y coordinates from index
                                  int x = (index / dim).floor();
                                  int y = index % dim;
                                  // Pass isDarkMode to _buildGridItems
                                  return _buildGridItems(
                                      context, index, isDarkMode);
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _showingSolution
                                  ? Colors.green
                                  : Colors.blueGrey
                                      .shade800, // Change color based on the _showingSolution flag
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      5.0), // Curved from top left corner
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                viewedSolution = true;
                                if (_showingSolution == false && allowSound == true){
                                  playerAudio.play(AssetSource('weak.mp3'));
                                }
                                _showingSolution = !_showingSolution;
                              });
                            },
                            icon: Icon(
                              _showingSolution
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            label: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 20),
                              child: Text(
                                _showingSolution
                                    ? 'HIDE SOLUTION'
                                    : 'SHOW SOLUTION',
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontFamily: 'Game'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: MaterialButton(
                                  color: Colors.blueGrey.shade800,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      'RESHUFFLE',
                                      style: TextStyle(
                                          fontSize: 21.0,
                                          color: Colors.white,
                                          fontFamily: 'Game'),
                                    ),
                                  ),
                                  onPressed: () {
                                    playerAudio.play(AssetSource('tap.mp3'));
                                    resetToggleMatrix();
                                    _randomize();
                                    viewedSolution = false;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: MaterialButton(
                                  color: Colors.blueGrey.shade800,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          5.0), // Curved from bottom right corner
                                      topRight: Radius.circular(
                                          5.0), // Curved from top right corner
                                    ),
                                  ),
                                  onPressed: _reset,
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      'BACK',
                                      style: TextStyle(
                                          fontSize: 21.0,
                                          color: Colors.white,
                                          fontFamily: 'Game'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Number of steps: $_numSteps',
                            style: const TextStyle(
                                fontSize: 25.0, fontFamily: 'Game'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 120),
                              const Text(
                                'Time Used: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25.0, fontFamily: 'Game'),
                              ),
                              Text(
                                _timeUsed,
                                style: const TextStyle(
                                    fontSize: 25.0, fontFamily: 'Game'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
