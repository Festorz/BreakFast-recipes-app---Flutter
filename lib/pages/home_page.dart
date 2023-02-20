// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:breakfast_recipes/misc/colors.dart' as color;
import 'package:breakfast_recipes/model/meals.dart';
import 'package:breakfast_recipes/pages/detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

import 'package:breakfast_recipes/ads/adstest.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Client client = http.Client();
  List<MealsModel> recipes = [];

  static final _kAdIndex = 4;
  late BannerAd _ad;
  bool _isAdLoaded = false;

  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  @override
  void initState() {
    _getBreakfast();
    super.initState();

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // TODO: Load an ad
    _ad.load();
  }

  _getBreakfast() async {
    recipes = [];

    var baseUrl = Uri.parse(
        "https://api.spoonacular.com/recipes/search?query=breakfast&number=20&instructionsRequired=true&apiKey=1bbf561e28c94ad3bba19d5d5cbbba94");
    List response = json.decode((await client.get(baseUrl)).body)['results'];
    response.forEach((element) {
      recipes.add(MealsModel.fromJson(element));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String shareMessage =
        "Let me recommend you this application\n\nhttps://play.google.com/store/apps/details?id=com.coolrecipes.breakfast.recipes\n";

    double w = MediaQuery.of(context).size.width;
    double w1 = (w - 60) / 2;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Breakfast Recipes',
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepOrangeAccent,
                fontWeight: FontWeight.bold,
              )),
          elevation: 0,
          backgroundColor: Colors.grey[200],
          actions: [
            IconButton(
                onPressed: () {
                  Share.share(shareMessage);
                },
                icon: Icon(
                  Icons.share,
                  color: Colors.deepOrangeAccent,
                ))
          ],
        ),
        backgroundColor: color.AppColors.homePageBackground,
        body: Container(
          padding: const EdgeInsets.only(top: 5, right: 20, left: 20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.grey, Colors.grey.withOpacity(0.2)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.centerRight),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(80)),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(10, 10),
                          blurRadius: 10,
                          color: Colors.brown.withOpacity(0.2))
                    ]),
                child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "10 Best Home Made",
                          style: TextStyle(
                              fontSize: 16,
                              color: color.AppColors.homePageTextSmall),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Breakfast Meals",
                          style: TextStyle(
                              fontSize: 25,
                              color: color.AppColors.homePageTextSmall),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "with Recipes",
                          style: TextStyle(
                              fontSize: 25,
                              color: color.AppColors.homePageTextSmall),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 20,
                                  color: color.AppColors.homePageTextSmall,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '60 min',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: color.AppColors.homePageTextSmall),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10,
                                        offset: const Offset(4, 8)),
                                  ]),
                              child: const Icon(
                                Icons.free_breakfast_sharp,
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: OverflowBox(
                  maxWidth: MediaQuery.of(context).size.width,
                  child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: recipes.isNotEmpty
                          ? NotificationListener<
                              OverscrollIndicatorNotification>(
                              child: ListView.builder(
                                  itemCount: ((recipes.length.toDouble() ~/ 2) +
                                          (_isAdLoaded ? 1 : 0))
                                      .toInt(),
                                  itemBuilder: (_, index) {
                                    int a = 2 * index;
                                    int b = 2 * index + 1;
                                    if (_isAdLoaded && index == _kAdIndex) {
                                      return Container(
                                        child: AdWidget(ad: _ad),
                                        width: _ad.size.width.toDouble(),
                                        height: 72.0,
                                        alignment: Alignment.center,
                                      );
                                    } else {
                                      final item = recipes[
                                          _getDestinationItemIndex(index)];

                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(
                                                    id: recipes[a]
                                                        .id
                                                        .toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20,
                                                      top: 5,
                                                      bottom: 15),
                                                  height: 170,
                                                  width: (w - 60) / 2,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          // offset: Offset(4, 4),
                                                          color: Colors.black26)
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 20,
                                                  child: Container(
                                                    height: 110,
                                                    width: w1,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "https://spoonacular.com/recipeImages/" +
                                                                  recipes[a]
                                                                      .image),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 80,
                                                    left: 23,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 45,
                                                        ),
                                                        SizedBox(
                                                          width: w1,
                                                          child: Text(
                                                            recipes[a].title,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                          width: w1,
                                                          child: Center(
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.timer,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                                const SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  recipes[a]
                                                                          .readyInMinutes
                                                                          .toString() +
                                                                      ' Min',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black38),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                const Icon(
                                                                  Icons
                                                                      .breakfast_dining_sharp,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                                const SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  recipes[a]
                                                                          .servings
                                                                          .toString() +
                                                                      ' Servings',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black38),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailPage(
                                                            id: recipes[b]
                                                                .id
                                                                .toString())),
                                              );
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 20,
                                                    top: 5,
                                                    bottom: 15,
                                                  ),
                                                  height: 170,
                                                  width: (w - 60) / 2,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          // offset: Offset(4, 4),
                                                          color: Colors.black26)
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 20,
                                                  child: Container(
                                                    height: 110,
                                                    width: w1,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "https://spoonacular.com/recipeImages/" +
                                                                  recipes[b]
                                                                      .image),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 80,
                                                    left: 23,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 45,
                                                        ),
                                                        SizedBox(
                                                          width: w1,
                                                          child: Text(
                                                            recipes[b].title,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                          width: w1,
                                                          child: Center(
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.timer,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                                const SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  recipes[b]
                                                                          .readyInMinutes
                                                                          .toString() +
                                                                      ' Min',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black38),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                const Icon(
                                                                  Icons
                                                                      .breakfast_dining_sharp,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                                const SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  recipes[b]
                                                                          .servings
                                                                          .toString() +
                                                                      ' Servings',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black38),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }),
                              onNotification: (overscroll) {
                                overscroll.disallowGlow();
                                return true;
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              color: Colors.deepOrangeAccent.withOpacity(0.5),
                            ))),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _ad.dispose();

    super.dispose();
  }
}
