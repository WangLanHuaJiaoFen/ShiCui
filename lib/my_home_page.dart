import 'package:ShiCui/favorites_page.dart';
import 'package:ShiCui/generator_page.dart';
import 'package:ShiCui/setting_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = SettingPage();
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }

    var mainArea = ColoredBox(
      color: colorScheme.primaryContainer, 
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500), 
        child: page,),
      );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return Column(
              children: [
                Expanded(child: mainArea), 
                SafeArea(
                  top: false,
                  child: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"), 
                    BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: "Favorites"), 
                    BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings")
                  ],
                  currentIndex: selectedIndex, 
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },

                ))
              ],
            );
          } else {
            return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 650 ,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_rounded),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_rounded), 
                      label: Text("Settings"))
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ), 
              Expanded(child: mainArea)
            ],
          );
          }
        }
      ),
    );
  }
}