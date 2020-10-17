import 'package:flutter/material.dart';
import 'package:mycryptoapp/bottomBar/addCurrency.dart';
import 'package:mycryptoapp/bottomBar/settings.dart';
import 'package:mycryptoapp/bottomBar/tracker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  List<Widget> _children() => [Tracker(), AddCurrency(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _children();

    return Scaffold(
      body: ListView(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.90,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: children[_selectedIndex],
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity, size: 27),
            title: new Text('Tracker'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on, size: 27),
            title: new Text('Currency'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 27),
            title: new Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(size: 35),
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.red[800],
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
