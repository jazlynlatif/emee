
import 'package:emee/pages/home-page/profile_api.dart';
import 'package:emee/pages/home-page/widgets/history.dart';
import 'package:emee/pages/home-page/widgets/home.dart';
import 'package:emee/pages/home-page/widgets/profile.dart';
import 'package:flutter/material.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currPageIndex = 1;
  List <Widget> pages = [
    History(),
    HomePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: currPageIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currPageIndex = index;
          });
        },
        indicatorShape: CircleBorder(
          side : BorderSide(
            width: 30,
            color: theme.colorScheme.primary
          ),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history), 
            label: 'History'
          ),
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              size: 45,
            ), 
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined), 
            selectedIcon: Icon(Icons.account_circle),
            label: 'Profile'
          )
        ]
      ),
    );
      
      
    
  }
}