// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// //import 'package:google_mobile_ads/google_mobile_ads.dart';

// class ResultPage extends StatefulWidget {
//   const ResultPage({Key key}) : super(key: key);

//   @override
//   State<ResultPage> createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   BannerAd bannerAd;
//   bool isloaded = false;

//   @override
//   void initState() {
//     super.initState();
//     initBannerAd();
//   }

//   initBannerAd() {
//     bannerAd = BannerAd(
//         size: AdSize.banner,
//         adUnitId: "ca-app-pub-9445696330223449/9232935416",
//         listener: BannerAdListener(
//             onAdLoaded: (v) {
//               setState(() {
//                 isloaded = true;
//               });
//             },
//             onAdFailedToLoad: (ad, error) {}),
//         request: AdRequest());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.red,
//           centerTitle: true,
//           title: Text(
//             "Result",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//           )),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             "Result show after watching Adds",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//           ),
//           Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: isloaded
//                   ? Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.red),
//                       height: bannerAd.size.height.toDouble(),
//                       width: bannerAd.size.width.toDouble(),
//                       child: AdWidget(ad: bannerAd),
//                     )
//                   : SizedBox())
//         ],
//       ),
//     );
//   }
// }
