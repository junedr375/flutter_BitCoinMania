import 'package:flutter/material.dart';
import 'package:mycryptoapp/Home/home.dart';
import 'package:mycryptoapp/splash/animation/fadeanimation.dart';

//modules
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;

  Widget defaultHome;

  bool hideIcon = false;

  @override
  void initState() {
    print('done');
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _widthController.forward();
            }
          });

    _widthController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    _widthAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _positionController.forward();
            }
          });

    _positionController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _positionAnimation =
        Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                hideIcon = true;
              });
              _scale2Controller.forward();
            }
          });

    _scale2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleController.forward();

    _scale2Animation =
        Tween<double>(begin: 1.0, end: 32.0).animate(_scale2Controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Home() ));
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            Container(
              child: FadeAnimation(
                  1,
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('image/giphy.gif'),
                            fit: BoxFit.fitWidth)),
                  )),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.80,
              left: MediaQuery.of(context).size.height * 0.20,
              right: MediaQuery.of(context).size.height * 0.05,
              child: Text(
                'Created By Juned Raza',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
      ),
    );
  }
}
