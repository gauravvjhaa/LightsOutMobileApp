import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  final List<Map<String, dynamic>> leaderboardData;

  const LeaderboardPage({super.key, required this.leaderboardData});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late List<Map<String, dynamic>> filteredData;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData = widget.leaderboardData; // Initialize filtered data with all leaderboard data
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredData = widget.leaderboardData.where((player) {
        return player['userName'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Leaderboard', style: TextStyle(fontSize: 29, fontFamily: 'Game'),),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 52, // Set the desired height of the TextField
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search player...',
                  filled: true,
                  fillColor: Colors.black45,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  alignLabelWithHint: true,
                  isDense: true,
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Top Players',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Game', // Custom font
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final player = filteredData[index];
                  final rank = player['rank'];
                  final userName = player['userName'];
                  final accuracy = player['averageAccuracy'];

                  return _buildLeaderboardItem(rank, userName, accuracy);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(int rank, String userName, double accuracy) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800], // Custom item background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rank $rank',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Game', // Custom font
              color: Colors.white, // Custom text color
            ),
          ),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            '${accuracy.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
