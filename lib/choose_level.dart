import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:LightsOut/game.dart';

class ChooseLevel extends StatefulWidget {
  final int states;

  const ChooseLevel({required this.states});

  @override
  _ChooseLevelState createState() => _ChooseLevelState();
}

class _ChooseLevelState extends State<ChooseLevel> {
  int _currIndex = 0;
  final int minLevel = 3;
  final int maxLevel = 8;
  late Card _currLevel;
  final playerAudio = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _generateLevels();
  }

  void _generateLevels() {
    _currIndex = _currIndex.clamp(0, maxLevel - minLevel);
    _currLevel = _buildLevelCard(_currIndex);
  }

  Card _buildLevelCard(int index) {
    int miniLevel = 3;
    int level = miniLevel+index;
    return Card(
      color: Colors.blueGrey,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          '${level}x$level',
          style: const TextStyle(color: Colors.black, fontSize: 40),
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
        title: const Text('Lights Out - Intense', style: TextStyle(fontFamily: 'Game')),
        backgroundColor: isDarkMode? Colors.black54 : Colors.grey.shade600,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Opacity
          Opacity(
            opacity: isDarkMode? 0.1: 0.5, // Adjusting opacity here (0.0 to 1.0)
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_image_two.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Choose Grid Size',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade200,
                        fontFamily: 'Game'
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Center(
                    child: Container(
                      color: Colors.black87,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _currLevel,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 85),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.navigate_before, size: 32.0),
                          onPressed: () {
                            if (_currIndex > 0) {
                              setState(() {
                                _currIndex -= 1;
                                _currLevel = _buildLevelCard(_currIndex);
                              });
                            }
                          },
                        ),
                        Text(
                          'Dim',
                          style: TextStyle(fontSize: 25.0, color: isDarkMode ? Colors.white : Colors.black, fontFamily: 'Game'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.navigate_next, size: 32.0),
                          onPressed: () {
                            if (_currIndex < maxLevel - minLevel) {
                              setState(() {
                                _currIndex += 1;
                                _currLevel = _buildLevelCard(_currIndex);
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Game(dim: _currIndex + minLevel, states: widget.states),
                        ),
                      );
                    },
                    child: const Text(
                      'START GAME',
                      style: TextStyle(fontSize: 28.0, color: Colors.white, fontFamily: 'Game'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(fontSize: 24.0, color: Colors.white, fontFamily: 'Game'),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
