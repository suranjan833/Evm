import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/filter_handler.dart';

class UsedCarsFilterSheet extends StatefulWidget {
  const UsedCarsFilterSheet({Key key}) : super(key: key);

  @override
  State<UsedCarsFilterSheet> createState() => _UsedCarsFilterSheetState();
}

class _UsedCarsFilterSheetState extends State<UsedCarsFilterSheet> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final filter = Provider.of<FilterHandler>(context);
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kBlackColor.withOpacity(0.2)),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: TextButton(
                      onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Filters",
                            style: theme.displaySmall,
                          ),
                          const Icon(
                            Icons.filter_alt,
                            color: kBlackColor,
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(),
          ),
          Expanded(
            child: SizedBox(
              child: SingleChildScrollView(
                child: Consumer<FilterHandler>(
                    builder: (context, value, child) => Column(
                          children: value.filterButtonvalues
                              .map((e) => ExpansionTile(
                                    title: Text(
                                      e,
                                      style: theme.headlineMedium,
                                    ),
                                    trailing: IconButton(
                                        onPressed: null,
                                        icon: Icon(Icons.arrow_forward_ios,
                                            color:
                                                kBlackColor.withOpacity(0.4))),
                                    children: [value.getFilters(context, e)],
                                  ))
                              .toList(),
                        )),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: SizedBox(
                child: MaterialButton(
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: kBlackColor.withOpacity(0.15),
                    onPressed: () => {
                          filter.resetFilter(),
                          db
                              .fatchUsedCars(context: context)
                              .then((value) => getPop(context))
                        },
                    child: Text(
                      "Reset",
                      style: theme.displaySmall.copyWith(color: kDefaultColor),
                    )),
              )),
              putWidth(20),
              Expanded(
                  child: SizedBox(
                child: MaterialButton(
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: kDefaultColor,
                    onPressed: () => db
                        .fatchUsedCars(context: context)
                        .then((value) => getPop(context)),
                    child: Text(
                      "Done",
                      style: theme.displaySmall.copyWith(color: kWhiteColor),
                    )),
              )),
            ],
          )
        ],
      ),
    );
  }
}
