import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:connectivity/connectivity.dart';

class Tracker extends StatefulWidget {
  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  String myAddedList;
  List myFinalList;
  int i = 0;
  bool isLoading = true;
  var arr;
  Map data;
  bool noData = false;
  Timer timer;
  int duration = 3;
  bool isInternetConnected = true;
  @override
  void initState() {
    super.initState();
    checkConnection();
    getMyList();
    timer = Timer.periodic(
        Duration(seconds: duration), (Timer t) => loadfinalData());
    loadfinalData();
  }

  Future checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isInternetConnected = true;
      });
    } else {
      setState(() {
        isInternetConnected = false;
      });
    }
  }

  getMyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myAddedList = prefs?.getString('myAddedList') ?? '';
      duration = prefs?.getInt('trackerTime') ?? 3;
    });

    print(myAddedList);
    setState(() {
      myAddedList = myAddedList.toLowerCase();
      arr = myAddedList.split('|');
    });
    if (myAddedList == 'dummy') {
      setState(() {
        noData = true;
      });
    } else {
      noData = false;
    }
  }

  void loadfinalData() async {
    String url = 'https://api.coingecko.com/api/v3/exchange_rates';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (data != null) {
        setState(() {
          isLoading = false;
        });
        print(data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tracker'),
        backgroundColor: Colors.black,
      ),
      body: (!isInternetConnected)
          ? Container(
              child: Center(
                child: Card(
                  color: Colors.indigo[200],
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.signal_cellular_connected_no_internet_4_bar,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Check Internet Connection\n                    Retry',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Neucha',
                          color: Colors.brown),
                    ),
                    onTap: () {
                      checkConnection();
                    },
                  ), //ListTile
                ),
              ),
            )
          : (isLoading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: (noData)
                            ? Center(
                                child: Text(
                                  'No Currency added, Add now on from chat screen',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    (arr.length == 0) ? 0 : arr.length - 1,
                                itemBuilder:
                                    (BuildContext context, int indexChild) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    height: 100,
                                    child: GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.indigo[200],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.red[200])),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  '${arr[indexChild + 1].split(',')[0].toUpperCase()}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Spacer(),
                                                Text(
                                                  'to',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${arr[indexChild + 1].split(',')[1].toUpperCase()}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Value: ${data['rates']['${arr[indexChild + 1].split(',')[1]}']['value']}',
                                              style: TextStyle(
                                                  color: Colors.brown[800],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Spacer(),
                                            Divider(
                                              height: 1,
                                              thickness: 2,
                                              color: Colors.black,
                                            ),
                                            SizedBox(
                                              height: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      onLongPress: () {
                                        print('hello');
                                        String msg =
                                            'Are you sure, Delete this currency ?';
                                        _showMyDialog(msg, indexChild + 1);
                                      },
                                    ),
                                  );
                                }))
                  ],
                ),
    );
  }

  Future<void> _showMyDialog(String msg, int index) async {
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
                  'DELETE',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              onPressed: () {
                print(myAddedList);
                print(arr[index]);
                String myString = '|' + arr[index];
                String updatedList;
                print(myString);
                setState(() {
                  updatedList = myAddedList.replaceAll(myString, '');
                });
                print('aftr');
                print(updatedList);

                setMyAddedList(updatedList);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Center(
                child: Text(
                  'BACK',
                  style: TextStyle(color: Colors.black, fontSize: 20),
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

  setMyAddedList(String updatedString) async {
    myAddedList = myAddedList.toLowerCase();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs?.setString('myAddedList', updatedString);
    getMyList();
  }
}
