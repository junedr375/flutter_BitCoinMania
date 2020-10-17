import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

double dropdownValue = 3.0;

class _SettingsState extends State<Settings> {
  DropdownButton dropdownButton() {
    return DropdownButton<double>(
      value: dropdownValue,
      icon: Icon(
        Icons.arrow_downward,
        color: Colors.black,
      ),
      iconSize: 24,
      elevation: 16,
      dropdownColor: Colors.indigo[100],
      style: TextStyle(color: Colors.black, fontSize: 20),
      onChanged: (double newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <double>[3.0, 5.0, 10.0, 30.0, 60.0, 120.0]
          .map<DropdownMenuItem<double>>((double value) {
        return DropdownMenuItem<double>(
          value: value,
          child: Center(child: Text(value.toString())),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('Settings'),
        ),
        body: Column(children: [
          SizedBox(
            height: 250,
          ),
          Text(
            'Choose time in seconds for traking page',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.indigo[200],
                    border: Border.all(color: Colors.indigo[900], width: 3),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(child: dropdownButton()),
              )),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.red[500],
                  border: Border.all(color: Colors.indigo[900], width: 2),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  'SET TIME',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            onTap: () {
              print('hello');
              setTime();
              String msg = 'Time in seconds updated Successfully';
              _showMyDialog(msg);
            },
          ),
        ]));
  }

  setTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.setInt('trackerTime', dropdownValue.toInt());
  }

  Future<void> _showMyDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Divider(
                  height: 1,
                  color: Colors.indigo[200],
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Center(
                child: Text(
                  'DONE',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
