import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  const MyListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap
});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(text, style: const TextStyle(color: Colors.white, fontFamily: 'Game', fontSize: 18),), //style: const TextStyle(fontFamily: 'Game'), //can be added
      onTap: onTap,
    );
  }
}
