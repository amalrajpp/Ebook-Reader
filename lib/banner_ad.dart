import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  BannerAdWidgetState createState() => BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  // Declare a banner ad object
  late BannerAd _bannerAd;

  // Declare a boolean variable to check if the ad is loaded
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // Create a banner ad object with the given ad unit ID, size, and listener
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6592943300896029/1031127638', // Test ad unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );

    // Load the banner ad
    _bannerAd.load();
  }

  @override
  void dispose() {
    // Dispose the banner ad when the widget is disposed
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isAdLoaded ? AdWidget(ad: _bannerAd) : const Text('Loading ...'),
    );
  }
}
