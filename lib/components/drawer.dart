import 'package:flutter/material.dart';
import 'package:LightsOut/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final bool goodUser;
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({super.key, this.onProfileTap, this.onSignOut, required this.goodUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 90,
                ),
              ),

              //home list tile
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 25.0),
                child: MyListTile(
                  icon: Icons.home,
                  text: 'H O M E',
                  onTap: () => Navigator.pop(context),
                ),
              ),

              //profile list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: MyListTile(
                    icon: Icons.person,
                    text: 'P R O F I L E',
                    onTap: onProfileTap,
                ),
              ),
            ],
          ),

          //logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 34.0, left: 25.0),
            child: MyListTile(
              icon: goodUser? Icons.logout : Icons.login,
              text: goodUser? 'L O G O U T' : 'G O  T O  L O G I N',
              onTap: onSignOut,
            ),
          )

        ],
      ),
    );
  }
}
