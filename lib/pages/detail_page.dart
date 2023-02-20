import 'dart:convert';
import 'package:breakfast_recipes/ads/adstest.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:breakfast_recipes/Iap/home_screen.dart';
import 'package:breakfast_recipes/model/recipe.dart';
import 'package:breakfast_recipes/widgets/app_icon.dart';
import 'package:breakfast_recipes/widgets/app_large_text.dart';
import 'package:breakfast_recipes/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Client client = http.Client();
  List<RecipeModel> recipe = [];

  static final _kAdIndex = 4;
  late BannerAd _ad;
  bool _isAdLoaded = false;

  // TODO: Add _getDestinationItemIndex()
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  @override
  void initState() {
    super.initState();
    _retrieveRecipe(widget.id);

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

  _retrieveRecipe(id) async {
    recipe = [];

    var baseUrl = Uri.parse(
        "https://api.spoonacular.com/recipes/$id/information?apiKey=1bbf561e28c94ad3bba19d5d5cbbba94");
    var response = json.decode((await client.get(baseUrl)).body);
    recipe.add(RecipeModel.fromJson(response));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const double itemHeight = (180) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
        backgroundColor: Colors.white,
        body: recipe.isNotEmpty
            ? SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Stack(
                  children: [
                    // Image
                    Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.maxFinite,
                          height: 270,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(recipe[0].image),
                                fit: BoxFit.fill),
                          ),
                        )),
                    // clickable button
                    Positioned(
                        left: 20,
                        top: 40,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_outlined),
                              color: Colors.white,
                            ),
                          ],
                        )),
                    // body
                    Positioned(
                        top: 245,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 30),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 245,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification: (overscroll) {
                              overscroll.disallowGlow();
                              return true;
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // title
                                  AppLargeText(
                                    text: recipe[0].title,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                      height: 60,
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            AppIcon(
                                                color: Colors.redAccent,
                                                text: recipe[0]
                                                        .readyInMinutes
                                                        .toString() +
                                                    ' Mins',
                                                icon: Icons.timer),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            AppIcon(
                                                icon: Icons.dining,
                                                color: Colors.redAccent,
                                                text: recipe[0]
                                                        .servings
                                                        .toString() +
                                                    " Servings"),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            recipe[0].veryHealthy
                                                ? const AppIcon(
                                                    icon:
                                                        Icons.health_and_safety,
                                                    color: Colors.green,
                                                    text: 'Healthy')
                                                : const AppIcon(
                                                    icon:
                                                        Icons.health_and_safety,
                                                    color: Colors.red,
                                                    text: 'Not Healthy'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            recipe[0].vegetarian
                                                ? const AppIcon(
                                                    icon: Icons.fastfood,
                                                    color: Colors.green,
                                                    text: 'Vegetarian')
                                                : const AppIcon(
                                                    icon: Icons.fastfood,
                                                    color: Colors.red,
                                                    text: 'Not Vegetarian'),
                                            const SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child: AppLargeText(text: "Ingredients")),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                      height: 150,
                                      width: double.maxFinite,
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            (itemWidth / itemHeight),
                                        padding: EdgeInsets.zero,
                                        children: List.generate(
                                            recipe[0]
                                                .extendedIngredients
                                                .length, (index) {
                                          return SizedBox(
                                              width: 70,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            recipe[0].extendedIngredients.elementAt(
                                                                            index)[
                                                                        "image"] !=
                                                                    null
                                                                ? "https://spoonacular.com/cdn/ingredients_100x100/" +
                                                                    recipe[0]
                                                                        .extendedIngredients
                                                                        .elementAt(
                                                                            index)["image"]
                                                                : "12",
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: recipe[0]
                                                                    .extendedIngredients
                                                                    .elementAt(
                                                                        index)[
                                                                "original"] !=
                                                            null
                                                        ? AppText(
                                                            text: recipe[0]
                                                                    .extendedIngredients
                                                                    .elementAt(
                                                                        index)[
                                                                "original"],
                                                            color: Colors.black,
                                                            size: 13,
                                                          )
                                                        : Text(""),
                                                  )
                                                ],
                                              ));
                                        }),
                                      )),

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Center(
                                    child: AppLargeText(
                                      text: "Instructions",
                                      color: Colors.black.withOpacity(0.8),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // description text
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(bottom: 50),
                                    child: Html(
                                        data: recipe[0].instructions,
                                        style: {
                                          "body": Style(
                                              color: Colors.black54,
                                              fontSize: const FontSize(16.0))
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                    // subscribe btn
                    Positioned(
                      left: 20,
                      bottom: 10,
                      right: 20,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.black87, width: 1)),
                              child: Icon(Icons.payment_rounded,
                                  color: Colors.green[900], size: 20),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green[900]),
                              child: MaterialButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                ),
                                child: const Text(
                                  'Subscribe',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrangeAccent.withOpacity(0.6),
                ),
              ));
  }
}
