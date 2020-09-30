import 'package:best_flutter_ui_templates/hotel_booking/hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'model/salon_service_list.dart';

class SalonServiceListView extends StatelessWidget {
  const SalonServiceListView(
      {Key key,
      this.hotelData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final SalonServiceListData hotelData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                },
                child: Container(
                  height: 110,
                  // margin:
                  //     const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.pink[50],
                      boxShadow: [
                        BoxShadow(
                            // color: Colors.black.withAlpha(100),
                            color: Colors.grey.withAlpha(100),
                            blurRadius: 10.0),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              hotelData.titleTxt,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              hotelData.subTxt,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            Text(
                              "\$ ${hotelData.perService}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "Book Now",
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.pink[200],
                              onPressed: () {
                                print('book now clicked');
                              },
                            ),
                            // FlatButton(
                            //   child: Text('FlatButton'),
                            //   color: Colors.white,
                            //   onPressed: () {
                            //     print("FlatButton tapped");
                            //   },
                            // ),

                            // MaterialButton(
                            //   padding: EdgeInsets.all(0),
                            //   minWidth: 0,
                            //   child: Text(
                            //     "Book Now",
                            //     style: const TextStyle(
                            //         fontSize: 8,
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // )
                            // SizedBox(
                            //   width: double.infinity,
                            //   height: 10,
                            //   child: RaisedButton(
                            //     onPressed: () {},
                            //     child: const Text('Book Now',
                            //         style: TextStyle(fontSize: 4)),
                            //   ),
                            // ),
                          ],
                        ),
                        Image.asset(
                          hotelData.imagePath,
                          height: double.infinity,
                          width: 140,
                        ),
                        // Image.asset(
                        //   "assets/images/${hotelData.dist.toStringAsFixed(1)}",
                        //   height: double.infinity,
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
