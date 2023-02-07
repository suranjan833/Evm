import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/models.dart';
import 'car_details.dart';

class CarListWidget extends StatelessWidget {
  UsedCarModel item;
  CarListWidget({Key key, @required this.item}) : super(key: key);

  bool favProcess = false;
  String currentId = '';

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final favList = db.getFavList;
    return GestureDetector(
      onTap: () => pushTo(context, CarDetailsView(car: item)),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Container(
          color: kBlackColor.withOpacity(0.05),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 7,
                child: CachedNetworkImage(
                  imageUrl: item.thumbnail,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/no_image.png'),
                ),
              ),
              StatefulBuilder(
                  builder: (context, useState) => Positioned(
                      top: 10,
                      right: 10,
                      child: favProcess && currentId == item.id
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: Center(child: CircularProgressIndicator()))
                          : IconButton(
                              onPressed: () async {
                                useState(() {
                                  favProcess = true;
                                  currentId = item.id;
                                });
                                await db
                                    .addCarToFavorite(context, item.id)
                                    .whenComplete(() =>
                                        useState(() => favProcess = false));
                              },
                              icon: favList.any((element) =>
                                      element.toString() == item.id)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: kredColor,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline,
                                    ),
                            ))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        color: kWhiteColor,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        width: getScreenWidth(context),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                item.modelName,
                                style: textTheme(context).displaySmall,
                              ),
                              subtitle: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(item.name),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: 4,
                                    width: 4,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kGreenColor),
                                  ),
                                  Text("Top Speed: ${item.topSpeed}"),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: 4,
                                    width: 4,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kGreenColor),
                                  ),
                                  Text(item.modelYear),
                                ],
                              ),
                              trailing: Text(
                                "\$ ${item.price}",
                                style: textTheme(context)
                                    .displaySmall
                                    .copyWith(color: kDefaultColor),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
