import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/custom_flat_button.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/models.dart';
import 'enquir_form.dart';

class CarDetailsView extends StatefulWidget {
  UsedCarModel car;
  CarDetailsView({Key key, @required this.car}) : super(key: key);

  @override
  State<CarDetailsView> createState() => _CarDetailsViewState();
}

class _CarDetailsViewState extends State<CarDetailsView> {
  int imageIndex = 0;
  bool favProcess = false;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final favList = db.getFavList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        foregroundColor: kWhiteColor,
        title: Text("${widget.car.modelYear} ${widget.car.modelName}"),
        actions: [
          favProcess
              ? const Center(
                  child: CircularProgressIndicator(color: kWhiteColor))
              : IconButton(
                  onPressed: () async {
                    setState(() {
                      favProcess = true;
                    });
                    await db.addCarToFavorite(context, widget.car.id).then(
                        (value) => {
                              value ? db.addtoFavs(widget.car.id) : null,
                              setState(() => favProcess = false)
                            });
                  },
                  icon: favList
                          .any((element) => element.toString() == widget.car.id)
                      ? const Icon(
                          Icons.favorite,
                          color: kredColor,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: kWhiteColor,
                        ))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                widget.car.photos.isEmpty
                    ? AspectRatio(
                        aspectRatio: 16 / 7,
                        child: SizedBox(
                          child: Image.network(widget.car.thumbnail,
                              fit: BoxFit.cover),
                        ),
                      )
                    : CarouselSlider(
                        items: widget.car.photos
                            .map((e) => AspectRatio(
                                  aspectRatio: 16 / 7,
                                  child: SizedBox(
                                    child: Image.network(e, fit: BoxFit.cover),
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            aspectRatio: 2.0,
                            initialPage: 0,
                            onPageChanged: (v, r) =>
                                setState(() => imageIndex = v)),
                      ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        widget.car.photos.length,
                        (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 8,
                              width: i == imageIndex ? 15 : 8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: i == imageIndex
                                      ? kWhiteColor
                                      : kWhiteColor.withOpacity(0.5)),
                            )),
                  ),
                )
              ],
            ),
            putHeight(10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: kWhiteColor),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    child: Text(widget.car.modelName,
                        style: textTheme(context).displaySmall),
                  )),
                  Text("\$${widget.car.price}",
                      style: textTheme(context).displaySmall)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: kWhiteColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///** Car Pickup for 0-60 mph in a time */
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(TextSpan(
                          text: "140",
                          style: textTheme(context)
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: "s",
                                style: textTheme(context)
                                    .headlineMedium
                                    ?.copyWith(
                                        color: kBlackColor.withOpacity(0.3)))
                          ])),
                      Text("0-60 mph",
                          style: textTheme(context)
                              .headlineSmall
                              ?.copyWith(color: kBlackColor.withOpacity(0.3)))
                    ],
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: const VerticalDivider(thickness: 1.5),
                  ),

                  ///** Car top Speed */
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(TextSpan(
                          text: widget.car.topSpeed,
                          style: textTheme(context)
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: " mph",
                                style: textTheme(context)
                                    .headlineMedium
                                    ?.copyWith(
                                        color: kBlackColor.withOpacity(0.3)))
                          ])),
                      Text("Top Speed",
                          style: textTheme(context)
                              .headlineSmall
                              ?.copyWith(color: kBlackColor.withOpacity(0.3)))
                    ],
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: const VerticalDivider(thickness: 1.5),
                  ),

                  ///** Car Speed Range Tag here */
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(TextSpan(
                          text: widget.car.speedRange,
                          style: textTheme(context)
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: " mi",
                                style: textTheme(context)
                                    .headlineMedium
                                    ?.copyWith(
                                        color: kBlackColor.withOpacity(0.3)))
                          ])),
                      Text("Range (EPA)",
                          style: textTheme(context)
                              .headlineSmall
                              ?.copyWith(color: kBlackColor.withOpacity(0.3)))
                    ],
                  ),
                ],
              ),
            ),

            ///** Key Features Card for Car */
            Container(
              width: getScreenWidth(context),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: kWhiteColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Key Features", style: textTheme(context).displaySmall),
                  getFeatureText("* Name - ${widget.car.name}"),
                  getFeatureText(
                      "* Vehicle History - ${widget.car.vehicleHistory}"),
                  getFeatureText(
                      "* Auto Pilot Software - ${widget.car.autoPilot}"),
                  getFeatureText(
                      "* Auto Hardware - ${widget.car.autoHardware}"),
                  getFeatureText(
                      "* Is Performance - ${widget.car.isPerformance}"),
                ],
              ),
            ),

            ///** Additions Information Card for Car */
            Container(
              width: getScreenWidth(context),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: kWhiteColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Additional Information",
                      style: textTheme(context).displaySmall),
                  getFeatureText("* ${widget.car.additionalOpt}"),
                ],
              ),
            )
          ],
        ),
      )),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: CustomExpandedButton(
            label: "Enquire Now",
            ontap: () => showDialog(
                context: context,
                builder: (context) => EnquirFormView(carId: widget.car.id)),
          )),
    );
  }

  Widget getFeatureText(String text) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(text,
            style: textTheme(context)
                .headlineMedium
                ?.copyWith(color: kBlackColor.withOpacity(0.4))),
      );
}
