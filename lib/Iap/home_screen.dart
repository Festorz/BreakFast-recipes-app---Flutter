// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import 'iap_provider_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  @override
  void InitState() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.verifyPurchase();
    // _makepurchase();
    super.initState();
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _makepurchase() {
    var provider = Provider.of<ProviderModel>(context);

    for (var prod in provider.products) _buyProduct(prod);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subscribe',
          style: TextStyle(
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[200],
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Center(
              //   child: Text(
              //     provider.isPurchased
              //         ? "Premium Plan 💎"
              //         : "Get Premium Plan Subscription",
              //     style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.cyan[700]),
              //   ),
              // ),
              const SizedBox(
                height: 40,
              ),
              for (var prod in provider.products)
                provider.isPurchased
                    ? const Center(
                        child: FittedBox(
                          child: Text(
                            "You have an active subscription ,Thank you 💕",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text(
                              "Unlock All Features Subscription: ${prod.price} per month.",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70)),
                            child: MaterialButton(
                              onPressed: () => _buyProduct(prod),
                              child: const Text(
                                'Subscribe',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              color: Colors.green,
                            ),
                          )
                        ],
                      )
            ],
          ),
        ),
      ),
    );
  }
}
