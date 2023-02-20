import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    Future<InitializationStatus> _initGoogleMobileAds() {
      // TODO: Initialize Google Mobile Ads SDK
      return MobileAds.instance.initialize();
    }

    return Container();
  }
}
