//
// import 'package:flutter/material.dart';
// import 'package:settings_ui/settings_ui.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:LightsOut/theme/dark_mode.dart';
// import 'package:LightsOut/theme/light_mode.dart';
//
// class SettingsPage extends StatefulWidget {
//
//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//
//   void _launchURL(String url) async {
//     if (await canLaunchUrl(url as Uri)) {
//       await launchUrl(url as Uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   void _toggleTheme (context) {
//     setState (){
//       ThemeData theme = Theme.of(context);
//       bool isDarkMode = theme.brightness == Brightness.dark;
//       if (isDarkMode){
//         theme = lightMode;
//       } else {
//         theme = darkMode;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     bool isDarkMode = theme.brightness == Brightness.dark;
//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       appBar: AppBar(
//         title: const Text('Settings', style: TextStyle(fontFamily: 'Game')),
//       ),
//       body: SettingsList(
//         sections: [
//           SettingsSection(
//             title: Text('Common'),
//             tiles: [
//               SettingsTile.navigation(
//                 leading: Icon(Icons.language),
//                 title: Text('Language'),
//                 value: Text('English'),
//                 onPressed: (BuildContext context) {
//                   // Navigate to language settings page
//                 },
//               ),
//               SettingsTile.switchTile(
//                 leading: Icon(Icons.music_video),
//                 title: Text('Allow Background Music'),
//                 onToggle: (value) {
//                   // Handle toggle action (e.g., update custom theme setting)
//                 },
//                 initialValue: true,
//               ),
//               SettingsTile.switchTile(
//                 leading: Icon(Icons.brightness_4),
//                 title: Text('Dark theme'),
//                 onToggle: (value) {
//                   _toggleTheme(context);
//                 },
//                 initialValue: true,
//               ),
//               SettingsTile.switchTile(
//                 leading: Icon(Icons.remove_red_eye),
//                 title: Text('Disable Solutions'),
//                 onToggle: (value) {
//                   // Handle toggle action (e.g., update custom theme setting)
//                 },
//                 initialValue: false,
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: Text('Notifications'),
//             tiles: [
//               SettingsTile.switchTile(
//                 leading: Icon(Icons.notifications),
//                 title: Text('Subscribe to our newsletter'),
//                 onToggle: (value) {
//                   //
//                 },
//                 initialValue: true,
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.notifications_active),
//                 title: Text('Notification sound'),
//                 trailing: DropdownButton<String>(
//                   value: 'Default',
//                   onChanged: (value) {
//                     // Handle dropdown selection (e.g., update notification sound setting)
//                   },
//                   items: ['Default', 'Chime', 'Bell', 'Gay'].map<DropdownMenuItem<String>>(
//                         (String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     },
//                   ).toList(),
//                 ),
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: Text('Account'),
//             tiles: [
//               SettingsTile.navigation(
//                 leading: Icon(Icons.phone),
//                 title: Text('Phone number'),
//                 onPressed: (BuildContext context) {
//                   // Navigate to the LicensePage when "Licenses" tile is pressed
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.email),
//                 title: Text('Add Email'),
//                 onPressed: (BuildContext context) {
//                   // Navigate to the LicensePage when "Licenses" tile is pressed
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.logout),
//                 title: Text('Sign Out'),
//                 onPressed: (BuildContext context) {
//                   //WelcomeScreen.signOutFromSettings; //bloc will be needed here i guess
//                 },
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: Text('Misc'),
//             tiles: [
//               SettingsTile.navigation(
//                 leading: Icon(Icons.assignment),
//                 title: Text('Terms of Service'),
//                 onPressed: (BuildContext context) {
//                   // Navigate to the LicensePage when "Licenses" tile is pressed
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.book),
//                 title: Text('Licenses'),
//                 onPressed: (BuildContext context) {
//                   // Navigate to the LicensePage when "Licenses" tile is pressed
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.rate_review),
//                 title: Text('Rate Us'),
//                 onPressed: (BuildContext context) {
//                   // Navigate to the LicensePage when "Licenses" tile is pressed
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.info),
//                 title: Text('About Us'),
//                 onPressed: (BuildContext context) {
//                   try {
//                     _launchURL('https://www.wikihow.com/Solve-Lights-Out-Game');
//                   } catch (e) {
//                     print('Error launching URL: $e');
//                   }
//                 },
//
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
