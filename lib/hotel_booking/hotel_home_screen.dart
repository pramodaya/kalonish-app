import 'dart:typed_data';
import 'dart:ui';
import 'package:best_flutter_ui_templates/hotel_booking/calendar_popup_view.dart';
import 'package:best_flutter_ui_templates/hotel_booking/hotel_list_view.dart';
import 'package:best_flutter_ui_templates/hotel_booking/model/hotel_list_data.dart';
import 'package:best_flutter_ui_templates/hotel_booking/item_detail.dart';
import 'package:best_flutter_ui_templates/login/welcome_screen.dart';
import 'package:best_flutter_ui_templates/model/product.dart';
import 'package:best_flutter_ui_templates/model/salon.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../app_theme.dart';
import 'filters_screen.dart';
import 'hotel_app_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HotelHomeScreen extends StatefulWidget {
  static const String id = 'salon_home_screen_hotel';
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  //set image
  String imgUrl;
  final _firestorage = FirebaseStorage.instance;
  final FirebaseStorage storage = FirebaseStorage(
      app: Firestore.instance.app,
      storageBucket: 'gs://kalonish-21fb1.appspot.com');
  Uint8List imageBytes;
  String errorMsg;

  var _salonPariList = <Salon>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _itemFetcher = _ItemFetcher();
  var salonCount = 0;
  var _searchValue = "";

  bool _isLoading = true;
  bool _hasMore = true;

  AnimationController animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;
  final ScrollController _scrollController = ScrollController();
  bool isSearching = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _isLoading = true;
    _hasMore = true;
    _loadMore();

    super.initState();
  }

  void _loadMore() {
    _isLoading = true;
    _itemFetcher.fetch().then((List<Salon> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
          _salonPariList = fetchedList;
        });
      } else {
        setState(() {
          _isLoading = false;
          _salonPariList = fetchedList;
          salonCount = fetchedList.length;
        });
      }
    });
  }

  void _loadMoreBySearch() {
    _isLoading = true;
    _itemFetcher
        .fetch(searchValue: _searchValue)
        .then((List<Salon> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
          salonCount = fetchedList.length;
        });
      } else {
        setState(() {
          _isLoading = false;
          _salonPariList = fetchedList;
          salonCount = fetchedList.length;
        });
      }
    });
  }

  // void getImage() async {
  //   //calculate img url
  //   var x = await _firestorage
  //       .ref()
  //       .child('gs://kalonish-21fb1.appspot.com/lara_salon/images1.jpg');

  //   StorageReference ref =
  //       FirebaseStorage.instance.ref().child("lara_salon/images1.jpg");
  //   String url = (await ref.getDownloadURL()).toString();
  //   print(url);

  //   var returnData =
  //       storage.ref().child('lara_salon/images1.jpg').getData(10000);
  // }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
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
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    AppBar(
                      centerTitle: true,
                      title: !isSearching
                          ? Text(
                              'KALONISH',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          : Container(
                              alignment: Alignment(0.0, 0.0),
                              width: 100.0,
                              child: TextField(
                                autocorrect: true,
                                autofocus: true,
                                cursorColor: Colors.white,
                                onChanged: (value) {
                                  // _filterCountries(value);
                                  setState(() {
                                    _searchValue = value.toUpperCase().trim();
                                  });
                                  _loadMoreBySearch();
                                },
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "Search Here",
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),

                      automaticallyImplyLeading: false,
                      // leading: GestureDetector(
                      //   onTap: () {/* Write listener code here */},
                      //   child: Icon(
                      //     Icons.menu, // add custom icons also
                      //   ),
                      // ),
                      actions: <Widget>[
                        isSearching
                            ? IconButton(
                                icon: Icon(Icons.cancel),
                                color: Colors.black,
                                padding: const EdgeInsets.only(top: 10.0),
                                onPressed: () {
                                  setState(() {
                                    this.isSearching = false;
                                    // filteredCountries = countries;
                                    _loadMore();
                                  });
                                },
                                iconSize: 30,
                              )
                            : IconButton(
                                padding: const EdgeInsets.only(top: 10.0),
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  // setState(() {
                                  //   this.isSearching = true;
                                  // });
                                },
                                color: Colors.black,
                                iconSize: 30,
                              ),
                      ],
                    ),
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      height: 10.0,
                                      width: MediaQuery.of(context).size.width,
                                      color: AppTheme.gradientColor2,
                                    ),
                                    // getSearchBarUI(),

                                    // getTimeDateUI(),
                                    SizedBox(
                                        height: 130.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Carousel(
                                          images: [
                                            // NetworkImage(
                                            //     'https://i.pinimg.com/originals/2d/09/d7/2d09d7a9c7a952fde88f107cedf1204a.jpg'),
                                            ExactAssetImage(
                                                "assets/images/img1.jpg"),
                                            ExactAssetImage(
                                                "assets/images/img2.jpg"),
                                            ExactAssetImage(
                                                "assets/images/img3.jpg"),
                                            ExactAssetImage(
                                                "assets/images/img4.jpg"),
                                            ExactAssetImage(
                                                "assets/images/img5.png"),
                                            ExactAssetImage(
                                                "assets/images/img5.png")
                                          ],
                                          dotSize: 4.0,
                                          dotSpacing: 15.0,
                                          dotColor: Colors.white,
                                          indicatorBgPadding: 3.0,
                                          dotBgColor: AppTheme.gradientColor2,
                                          // Colors.pink.withOpacity(0.5),
                                          borderRadius: false,
                                          autoplay: true,
                                          defaultImage: ExactAssetImage(
                                              "assets/images/img1.jpg"),
                                        )),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(
                                getFilterBarUI(),
                              ),
                            ),
                          ];
                        },
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
                          // color:
                          //     HotelAppTheme.buildLightTheme().backgroundColor,
                          child: ListView.builder(
                            // Need to display a loading tile if more items are coming
                            itemCount: _hasMore
                                ? _salonPariList.length + 1
                                : _salonPariList.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Uncomment the following line to see in real time how ListView.builder works
                              // print('ListView.builder is building index $index');
                              if (index >= _salonPariList.length) {
                                if (!_isLoading) {
                                  _loadMore();
                                }
                                return Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(),
                                    height: 24,
                                    width: 24,
                                  ),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 8, bottom: 16),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    print('direct to item detail page');
                                    // Navigator.pushNamed(
                                    //     context, ItemDetailPage.id,
                                    //     arguments: {
                                    //       'sdfsdf',
                                    //     });
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ItemDetailPage("WonderWorld",
                                                    _salonPariList[index])));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          offset: const Offset(4, 4),
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0)),
                                      child: Stack(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              AspectRatio(
                                                aspectRatio: 3,
                                                child: Image.network(
                                                  _salonPariList[index]
                                                      .salonImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  color: HotelAppTheme
                                                          .buildLightTheme()
                                                      .backgroundColor,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16,
                                                                    top: 8,
                                                                    bottom: 8),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  _salonPariList[
                                                                          index]
                                                                      .salonName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        22,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      FontAwesomeIcons
                                                                          .mapMarkerAlt,
                                                                      size: 12,
                                                                      color: HotelAppTheme
                                                                              .buildLightTheme()
                                                                          .primaryColor,
                                                                    ),
                                                                    Text(
                                                                      _salonPariList[
                                                                              index]
                                                                          .streetAddress1,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.8)),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    // Icon(
                                                                    //   FontAwesomeIcons
                                                                    //       .mapMarkerAlt,
                                                                    //   size: 12,
                                                                    //   color: HotelAppTheme
                                                                    //           .buildLightTheme()
                                                                    //       .primaryColor,
                                                                    // ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        _salonPariList[index]
                                                                            .streetAddress2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.grey.withOpacity(0.8)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 4),
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      SmoothStarRating(
                                                                        allowHalfRating:
                                                                            true,
                                                                        starCount:
                                                                            5,
                                                                        rating:
                                                                            3,
                                                                        size:
                                                                            20,
                                                                        color: HotelAppTheme.buildLightTheme()
                                                                            .primaryColor,
                                                                        borderColor:
                                                                            HotelAppTheme.buildLightTheme().primaryColor,
                                                                      ),
                                                                      Text(
                                                                        '434 Reviews',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.grey.withOpacity(0.8)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 16,
                                                                top: 8),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            // Text(
                                                            //   '\$200',
                                                            //   textAlign:
                                                            //       TextAlign
                                                            //           .left,
                                                            //   style: TextStyle(
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w600,
                                                            //     fontSize: 22,
                                                            //   ),
                                                            // ),
                                                            Text(
                                                              'More >>',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(32.0),
                                                ),
                                                onTap: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.favorite_border,
                                                    color: HotelAppTheme
                                                            .buildLightTheme()
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // setState(() {
                      //   isDatePopupOpen = true;
                      // });
                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Choose date',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: AppTheme.gradientColor2,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$salonCount salons found',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      // FocusScope.of(context).requestFocus(FocusNode());
                      // Navigator.push<dynamic>(
                      //   context,
                      //   MaterialPageRoute<dynamic>(
                      //       builder: (BuildContext context) => FiltersScreen(),
                      //       fullscreenDialog: true),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort, color: Colors.grey),
                            // color: HotelAppTheme.buildLightTheme()
                            //     .primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}

class _ItemFetcher {
  final _itemsPerPage = 1;
  int _currentPage = 1;
  final _firestore = Firestore.instance;
  // This async function simulates fetching results from Internet, etc.
  Future<List<Salon>> fetch({String searchValue = ""}) async {
    final salonList = <Salon>[];

    int n = _currentPage * _itemsPerPage;
    var salonListResponse;

    if (searchValue == "") {
      salonListResponse =
          await _firestore.collection('salon_app_only').limit(n).getDocuments();
      print('search value no--------');
    } else {
      salonListResponse = await _firestore
          .collection('salon_app_only')
          .where('cityUpper', isEqualTo: searchValue)
          .limit(n)
          .getDocuments();
      print('search value have------');
    }

    if (salonListResponse.documents.length > 0) {
      for (var i = 0; i < n; i++) {
        Salon salon = Salon();
        var docId = salonListResponse.documents[i].documentID;
        salon.salonDocId = docId;
        salon.description = salonListResponse.documents[i].data['description'];
        salon.hotline = salonListResponse.documents[i].data['hotline'];
        salon.salonName = salonListResponse.documents[i].data['salonName'];
        salon.streetAddress1 =
            salonListResponse.documents[i].data['streetAddress1'];
        salon.streetAddress2 =
            salonListResponse.documents[i].data['streetAddress2'];

        //salon images
        final salonImages = await _firestore
            .collection('salon_app_only')
            .document(docId)
            .collection('salonImages')
            .getDocuments();

        List<String> salonImagesList = List<String>();
        var salonImagesLength = salonImages.documents.length;
        for (var j = 0; j < salonImagesLength; j++) {
          salonImagesList.add(salonImages.documents[j].data['filePath']);
        }

        salon.salonImagesList = salonImagesList;
        //get salon's first image url

        StorageReference ref =
            FirebaseStorage.instance.ref().child(salonImagesList[0]);
        String url = (await ref.getDownloadURL()).toString();
        salon.salonImage = url;

        StorageReference ref1 =
            FirebaseStorage.instance.ref().child(salonImagesList[1]);
        String url1 = (await ref1.getDownloadURL()).toString();
        salon.salonImg1 = url1;

        StorageReference ref2 =
            FirebaseStorage.instance.ref().child(salonImagesList[2]);
        String url2 = (await ref2.getDownloadURL()).toString();
        salon.salonImg2 = url2;

        StorageReference ref3 =
            FirebaseStorage.instance.ref().child(salonImagesList[3]);
        String url3 = (await ref3.getDownloadURL()).toString();
        salon.salonImg3 = url3;

        StorageReference ref4 =
            FirebaseStorage.instance.ref().child(salonImagesList[4]);
        String url4 = (await ref4.getDownloadURL()).toString();
        salon.salonImg4 = url4;

        //product list
        final productImages = await _firestore
            .collection('salon_app_only')
            .document(docId)
            .collection('productImages ')
            .getDocuments();

        var productList = List<Product>();
        var productListLength = productImages.documents.length;

        for (var k = 0; k < productListLength; k++) {
          var product = Product(
            category: productImages.documents[k].data['category'],
            name: productImages.documents[k].data['name'],
            img: productImages.documents[k].data['img'],
            price: productImages.documents[k].data['price'],
          );

          productList.add(product);
          print(product);
        }
        salon.productList = productList;
        print('No search value');
        salonList.add(salon);
        print(productList.length);
      }

      _currentPage++;
    }
    var k = salonList;
    print(salonList.length);
    return salonList;
  }
}
