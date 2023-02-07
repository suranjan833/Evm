import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/empty_data.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/filter_handler.dart';
import '../filter_sheet/filter_used_car.dart';
import 'car_list_widget.dart';

class DummyviewScreen extends StatefulWidget {
  const DummyviewScreen({Key key}) : super(key: key);

  @override
  State<DummyviewScreen> createState() => _DummyviewScreenState();
}

class _DummyviewScreenState extends State<DummyviewScreen> {
  bool isFavourite = false;
  bool _loading = false;
  String _sortBy = '';
  bool favProcess = false;

  String currentId = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() => _loading = true);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db
        .fatchUsedCars(context: context)
        .then((value) => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final db = Provider.of<AppDataHandler>(context);
    return SizedBox(
      height: getScreenHeight(context),
      width: getScreenWidth(context),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : db.getCarsList.isEmpty
                      ? const EmptyDataView()
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: db.getCarsList.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            final item = db.getCarsList[i];
                            return CarListWidget(item: item);
                          }),
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
                  child: TextButton.icon(
                      // height: 50,
                      onPressed: () => showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => StatefulBuilder(
                              builder: (context, setState) =>
                                  Builder(builder: (context) {
                                    return Consumer<FilterHandler>(
                                        builder: (context, value, _) =>
                                            _sortBySheet(value, theme));
                                  }))),
                      icon: const Icon(Icons.sort_sharp),
                      label: Text(
                        "Sort by",
                        style: theme.displaySmall,
                      ))),
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
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        constraints: BoxConstraints(
                            maxHeight: getScreenHeight(context) * 0.85),
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Stack(
                              children: [
                                const UsedCarsFilterSheet(),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: IconButton(
                                      onPressed: () => getPop(context),
                                      icon: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kBlackColor),
                                        child: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: kWhiteColor,
                                        ),
                                      )),
                                )
                              ],
                            )),
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
    );
  }

  Padding _sortBySheet(FilterHandler value, TextTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: value.sortByvalues
                .map((e) => ListTile(
                      onTap: () => {
                        setState(() => _sortBy = e),
                        value.setSortIndex(value.sortByvalues.indexOf(e))
                      },
                      title: Text(
                        e,
                        style: theme.headlineMedium,
                      ),
                      trailing: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.check,
                            color: value.getSortIndex ==
                                    value.sortByvalues.indexOf(e)
                                ? kDefaultColor
                                : Colors.transparent,
                          )),
                    ))
                .toList(),
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
                    onPressed: () => {value.clearSortFilter(), getPop(context)},
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
                    onPressed: () => onSortSubmit(_sortBy),
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

  onSortSubmit(String sortBy) async {
    setState(() => _loading = true);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db.fatchUsedCars(sortBy: sortBy, context: context).then((value) {
      getPop(context);
      setState(() => _loading = false);
    });
  }
}
