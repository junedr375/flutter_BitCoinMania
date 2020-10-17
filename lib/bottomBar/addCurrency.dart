import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class AddCurrency extends StatefulWidget {
  @override
  _AddCurrencyState createState() => _AddCurrencyState();
}

class _AddCurrencyState extends State<AddCurrency> {
  //String message;
  TextEditingController messageController = new TextEditingController();
  bool loading = true;
  String myAddedList = 'dummy';
  String myCoinForAddedList;
  String myCurrencyForAddedList;
  bool isInternetConnected = true;

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

  List botIntent = [
    {"isMe": false, "text": "Hello, Wanna add New Currency ? Yes or No !!!"},
    {
      "isMe": false,
      "text": "Okay, You can track your crypto-currency in tracker page"
    },
    {
      "isMe": false,
      "text":
          "Enter the name of the crypto-currency ,in this format  add cc before name"
    },
    {"isMe": false, "text": "for example 'ccBYTN', 'ccABO' or 'ccbizzcoin'"},
    {"isMe": false, "text": "Sorry,Crypto-Currency name doesn't matched!!!"},
    {
      "isMe": false,
      "text":
          "Enter Real world currency, for which you want the price, in this format add rc before name"
    },
    {"isMe": false, "text": "for example 'rcBMD', 'rcINR','rcUSD"},
    {"isMe": false, "text": "Sorry,Real-Currency name doesn't matched!!!"},
    {"isMe": false, "text": "Curreny Added!!!"},
    {
      "isMe": false,
      "text":
          "Sorry, that doesn't mean anything. Start adding currency by typing Yes"
    },
  ];

  List list = [];
  Map myBTCData;
  List btcCoinIdList = [];
  List myBtcCoinList = [];
  List btcCurrenciesList = [];
  List myBtcCurrenciesList = [];

  void loadCoinLIstData() async {
    String url = 'https://api.coingecko.com/api/v3/coins/list';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        myBtcCoinList = jsonDecode(response.body);
      });

      if (myBtcCoinList != null) {
        setState(() {
          for (int i = 0; i < myBtcCoinList.length; i++) {
            btcCoinIdList.add(myBtcCoinList[i]['id']);
          }
        });
        print(btcCoinIdList);
      }
    }
  }

  void loadCurrenciesLIstData() async {
    String url =
        'https://api.coingecko.com/api/v3/simple/supported_vs_currencies';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        btcCurrenciesList = jsonDecode(response.body);
      });
      print('statring currencies list ///////////////////');
      print('statring currencies list ///////////////////');
      print('statring currencies list ///////////////////');
      print('statring currencies list ///////////////////');
      print('statring currencies list ///////////////////');
      print('statring currencies list ///////////////////');
      print(btcCurrenciesList);
    }
  }

  @override
  void initState() {
    setState(() {
      loading = false;
    });
    checkConnection();
    loadCoinLIstData();
    loadCurrenciesLIstData();
    list.add(botIntent[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          : (!loading)
              ? ListView(
                  children: [
                    Container(
                      height: 60,
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Text(
                              'ADD CURRENCY',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            child: Icon(
                              Icons.account_balance,
                              color: Colors.red[800],
                              size: 40,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45)),
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Container(
                                width: 280,
                                height: 50,
                                color: Colors.indigo[100],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat,
                                      color: Colors.red[500],
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'CRYPTO CHAT BOT',
                                      style: TextStyle(
                                          color: Colors.red[500],
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    )
                                  ],
                                ))),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.57,
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            scrollDirection: Axis.vertical,
                            itemCount: list.length,
                            itemBuilder:
                                (BuildContext context, int indexChild) {
                              return Container(
                                padding: EdgeInsets.only(
                                    left: list[indexChild]['isMe'] ? 0 : 10,
                                    right: list[indexChild]['isMe'] ? 10 : 0),
                                margin: EdgeInsets.symmetric(vertical: 2),
                                width: MediaQuery.of(context).size.width,
                                alignment: list[indexChild]['isMe']
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  decoration: BoxDecoration(
                                      color: list[indexChild]['isMe']
                                          ? Colors.red[100]
                                          : Colors.indigo[100],
                                      borderRadius: list[indexChild]['isMe']
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(23),
                                              topRight: Radius.circular(23),
                                              bottomLeft: Radius.circular(23))
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(23),
                                              topRight: Radius.circular(23),
                                              bottomRight:
                                                  Radius.circular(23))),
                                  child: Text(
                                    list[indexChild]['text'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              );
                            })),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.keyboard,
                            color: Colors.red[500],
                            size: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.60,
                            child: TextField(
                              controller: messageController,
                              cursorColor: Colors.red[500],
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Your Message Here',
                                  hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            child: Icon(
                              Icons.send,
                              color: Colors.red[500],
                              size: 35,
                            ),
                            onTap: () {
                              print(messageController.text);
                              validateMyMessage(messageController.text);
                              print(list);
                            },
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    )
                  ],
                )
              : CircularProgressIndicator(),
    );
  }

  void validateMyMessage(String myMeassge) {
    if (myMeassge == 'No' ||
        myMeassge == 'Naah' ||
        myMeassge == 'no' ||
        myMeassge == 'nope') {
      messageController.clear();
      setState(() {
        list.add({"isMe": true, "text": myMeassge});
        list.add(botIntent[1]); //check currency in tracker page
      });
    }
    if (myMeassge == 'Yes' ||
        myMeassge == 'yes' ||
        myMeassge == 'Ok' ||
        myMeassge == 'Okay' ||
        myMeassge == 'Yeah') {
      messageController.clear();
      setState(() {
        list.add({"isMe": true, "text": myMeassge});
        list.add(botIntent[2]); //enter crypto currency
        list.add(botIntent[3]); //format example
      });
    }

    if (myMeassge.substring(0, 2) == 'cc' ||
        myMeassge.substring(0, 2) == 'rc') {
      if (myMeassge.substring(0, 2) == 'cc') {
        setState(() {
          myMeassge = myMeassge.substring(2, myMeassge.length);
        });
        if (btcCoinIdList.contains(myMeassge.toLowerCase())) {
          messageController.clear();
          setState(() {
            list.add({"isMe": true, "text": myMeassge});
            list.add(botIntent[5]);
            list.add(botIntent[6]);
            myCoinForAddedList = myMeassge;
          });
        } else {
          messageController.clear();
          setState(() {
            list.add({"isMe": true, "text": myMeassge});
            list.add(botIntent[4]);
          });
        }
      }
      if (myMeassge.substring(0, 2) == 'rc') {
        setState(() {
          myMeassge = myMeassge.substring(2, myMeassge.length);
        });
        if (btcCurrenciesList.contains(myMeassge.toLowerCase())) {
          messageController.clear();
          setState(() {
            list.add({"isMe": true, "text": myMeassge});
            list.add(botIntent[8]); //currency added
            list.add(botIntent[1]);
            myCurrencyForAddedList = myMeassge;
          });
          addToList();
        } else {
          messageController.clear();
          setState(() {
            list.add({"isMe": true, "text": myMeassge});
            list.add(botIntent[7]);
          });
        }
      }
    }
    // if (myMeassge != 'No' &&
    //     myMeassge != 'Naah' &&
    //     myMeassge != 'no' &&
    //     myMeassge != 'nope' &&
    //     myMeassge != 'Yes' &&
    //     myMeassge != 'yes' &&
    //     myMeassge != 'Ok' &&
    //     myMeassge != 'Okay' &&
    //     myMeassge != 'Yeah' &&
    //     myMeassge.substring(0, 2) != 'cc' &&
    //     myMeassge.substring(0, 2) != 'rc') {
    //   messageController.clear();
    //   setState(() {
    //     list.add({"isMe": true, "text": myMeassge});
    //     list.add(botIntent[9]);
    //   });
    // }
  }

  void addToList() async {
    if (myCoinForAddedList.length > 0 && myCurrencyForAddedList.length > 0) {
      String oldList;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      oldList = prefs?.getString('myAddedList') ?? '';
      setState(() {
        myAddedList =
            oldList + '|' + myCoinForAddedList + ',' + myCurrencyForAddedList;
      });
      setState(() {
        myCoinForAddedList = '';
        myCurrencyForAddedList = '';
      });
      print(myAddedList);
      setMyAddedList();
    }
  }

  setMyAddedList() async {
    myAddedList = myAddedList.toLowerCase();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs?.setString('myAddedList', myAddedList);
  }
}
