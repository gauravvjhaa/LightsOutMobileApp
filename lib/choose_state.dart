import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:LightsOut/choose_level.dart';

class ChooseState extends StatefulWidget {
  const ChooseState({Key? key}) : super(key: key);

  @override
  _ChooseStateState createState() => _ChooseStateState();
}

class _ChooseStateState extends State<ChooseState> {
  int _currIndex = 0;
  final playerAudio = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Lights Out - Intense',
          style: TextStyle(fontFamily: 'Game'),
        ),
        backgroundColor: isDarkMode? Colors.black54 : Colors.grey.shade600,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Opacity
          Opacity(
            opacity: isDarkMode? 0.1 : 0.5, // Adjusting opacity here (0.0 to 1.0)
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 60),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Choose State',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade200,
                        fontFamily: 'Game',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      buildImage('assets/two.png', 2),
                      buildImage('assets/three.png', 3),
                      buildImage('assets/four.png', 4),
                      buildImage('assets/five.png', 5),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CHOSEN STATE : ',
                        style: TextStyle(fontSize: 30, fontFamily: 'Game', color: isDarkMode? Colors.white : Colors.black),
                      ),
                      Text(
                        '${_currIndex + 2}',
                        style: const TextStyle(fontSize: 35, fontFamily: 'Game'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChooseLevel(states: _currIndex + 2),
                          ),
                        );
                      },
                      child: const Text(
                        'CHOOSE STATE',
                        style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Game'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 9),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'BACK',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Game'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currIndex = index - 2;
        });
      },
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(
            color: _currIndex == index - 2 ? Colors.white : Colors.transparent,
            width: _currIndex == index - 2 ? 4 : 2,
          ),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
