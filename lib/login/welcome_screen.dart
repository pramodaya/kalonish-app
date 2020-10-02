import 'package:best_flutter_ui_templates/login/login_with_phone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../navigation_home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;
  bool showSpinner = false;

  @override
  void initState() {
    setState(() {
      showSpinner = true;
      print(showSpinner);
    });
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        final userProfile = await _firestore
            .collection('user_profile')
            .where("user_id", isEqualTo: loggedInUser.uid)
            .getDocuments();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        //save user data in to local storage
        var firstName = userProfile.documents[0].data['first_name'];
        var lastName = userProfile.documents[0].data['last_name'];
        prefs.setString('fistName', firstName);
        prefs.setString('lastName', lastName);

        if (userProfile.documents.length > 0) {
          print(userProfile.documents.length);
        } else {
          print('no user exist');
        }

        //get salon data
        // final salonList =
        //     await _firestore.collection('test_salon').limit(2).getDocuments();

        // var query =
        //     _firestore.collection('user_profile').where("capital", "==");
        // for (var userProfile in userProfile.documents) {
        //   print(userProfile.data);
        // }

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
            (Route<dynamic> route) => false);
        setState(() {
          showSpinner = false;
        });
        print(loggedInUser.phoneNumber);
      } else {
        setState(() {
          showSpinner = false;
          print(showSpinner);
        });

        print('no user babe');
      }
    } catch (e) {
      print(e);
    }
  }

  // void getUserProfile() async {
  //   final userProfile = await _firestore
  //       .collection('user_profile')
  //       .where('user_id' == 'S9myWXb1JHZw1mLqCIouyYMfTmG2')
  //       .getDocuments();

  //   for (var userProfile in userProfile.documents) {
  //     print(userProfile.data);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.black,
            gradient: new LinearGradient(
              colors: [
                AppTheme.gradientColor1,
                AppTheme.gradientColor2,
                AppTheme.gradientColor3,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset('assets/images/Kalonish002.png'),
                    height: 120.0,
                  ),
                  // ColorizeAnimatedTextKit(
                  //   text: ['KALONISH'],
                  //   colors: [
                  //     Colors.pink[400],
                  //     Colors.black,
                  //   ],
                  //   textStyle: TextStyle(
                  //     fontSize: 50.0,
                  //     fontFamily: "Horizon",
                  //     fontWeight: FontWeight.w900,
                  //   ),
                  //   textAlign: TextAlign.start,
                  //   alignment: AlignmentDirectional.topStart,
                  // ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 16.0),
              //   child: Material(
              //     elevation: 5.0,
              //     color: Colors.pink[300],
              //     borderRadius: BorderRadius.circular(30.0),
              //     child: MaterialButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, LoginScreen.id);
              //       },
              //       minWidth: double.infinity,
              //       height: 42.0,
              //       child: Text(
              //         'Log In',
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: AppTheme.btnColor,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, RegistrationScreen.id);
                      Navigator.pushNamed(context, LoginPhoneScreen.id);
                    },
                    minWidth: double.infinity,
                    height: 42.0,
                    child: Text(
                      'SignIn/SignUp',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
