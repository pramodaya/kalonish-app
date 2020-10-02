import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:best_flutter_ui_templates/hotel_booking/hotel_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

import '../app_theme.dart';
import '../navigation_home_screen.dart';

class PersonRegistration extends StatefulWidget {
  static const String id = 'person_registration';
  @override
  _PersonRegistrationState createState() => _PersonRegistrationState();
}

class _PersonRegistrationState extends State<PersonRegistration> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String firstName;
  String lastName;
  String email;
  String address;
  String nic;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
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
      appBar: AppBar(
        title: Text('Set Up Profile'),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.white,
      body: Container(
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(''),
              SizedBox(
                height: 120.0,
              ),
              Container(
                child: Image.asset('assets/images/Kalonish002.png'),
                height: 80.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.btnColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.btnColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                // obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  firstName = value;
                },
                decoration: InputDecoration(
                  hintText: 'First Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.btnColor, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.btnColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  lastName = value;
                },
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.btnColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.btnColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  nic = value;
                },
                decoration: InputDecoration(
                  hintText: 'NIC',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.btnColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.btnColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: AppTheme.btnColor,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        var x = loggedInUser;
                        var success =
                            await _firestore.collection('user_profile').add({
                          'first_name': firstName,
                          'last_name': lastName,
                          'email': email,
                          'nic': nic,
                          'phone': loggedInUser.phoneNumber,
                          'user_id': loggedInUser.uid,
                          'userType': 'customer',
                          'isVerified': true,
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => NavigationHomeScreen()),
                            (Route<dynamic> route) => false);
                      } catch (e) {
                        print('saving error');
                      }
                    },
                    minWidth: double.infinity,
                    height: 42.0,
                    child: Text(
                      'Next',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 300.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
