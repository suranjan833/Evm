import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_config.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../filter_sheet/filter_used_car.dart';

class UsedCarsScreen extends StatefulWidget {
  const UsedCarsScreen({Key key}) : super(key: key);

  @override
  State<UsedCarsScreen> createState() => _UsedCarsScreenState();
}

class _UsedCarsScreenState extends State<UsedCarsScreen> {
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db.fatchUsedCars(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kBlackColor,
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: Image.asset(
          appLogo,
          height: getAppbarHeight(context) - 10,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundImage: AssetImage(imagePlaceHolder),
              )),
        ],
      ),
      body: SizedBox(
        height: getScreenHeight(context),
        width: getScreenWidth(context),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: 7,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) => GestureDetector(
                          onTap: () {},
                          child: AspectRatio(
                            aspectRatio: 16 / 10,
                            child: Container(
                              color: kBlackColor.withOpacity(0.05),
                              child: Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 7,
                                    child: Image.asset(
                                      dummyCar,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                      top: 10,
                                      right: 10,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isFavourite = !isFavourite;
                                          });
                                          print(isFavourite);
                                        },
                                        icon: isFavourite
                                            ? const Icon(
                                                Icons.favorite,
                                                color: kredColor,
                                              )
                                            : const Icon(
                                                Icons.favorite_outline,
                                              ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_rounded,
                                              color: kWhiteColor,
                                              size: 20,
                                            ),
                                            Text(
                                              "City Point, New York USA",
                                              style: theme.bodyMedium.copyWith(
                                                  color: kWhiteColor,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Container(
                                            color: kWhiteColor,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 10),
                                            width: getScreenWidth(context),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    "Liwa Wisara | VXI",
                                                    style: theme.displaySmall,
                                                  ),
                                                  subtitle: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text("75,000 kms"),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 5),
                                                        height: 4,
                                                        width: 4,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    kGreenColor),
                                                      ),
                                                      const Text("Diesel"),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 5),
                                                        height: 4,
                                                        width: 4,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    kGreenColor),
                                                      ),
                                                      const Text("2015"),
                                                    ],
                                                  ),
                                                  trailing: Text(
                                                    "\$ 2800",
                                                    style: theme.displaySmall
                                                        .copyWith(
                                                            color: kGreenColor),
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
                        )),
              ),
            ),
            Container(
              width: getScreenWidth(context),
              height: 5,
              color: kBlackColor.withOpacity(0.3),
            ),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                      // height: 50,
                      onPressed: () {},
                      icon: const Icon(Icons.sort_sharp),
                      label: Text(
                        "Sort by",
                        style: theme.displaySmall,
                      )),
                )),
                Container(
                  height: 50,
                  width: 1.2,
                  color: kBlackColor.withOpacity(0.3),
                ),
                Expanded(
                    child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                      // height: 50,
                      onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => StatefulBuilder(
                              builder: (context, setState) =>
                                  Builder(builder: (context) {
                                    return const UsedCarsFilterSheet();
                                  }))),
                      icon: const Icon(Icons.manage_search_rounded),
                      label: Text(
                        "Filters",
                        style: theme.displaySmall,
                      )),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
