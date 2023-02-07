import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../base_widgets/custom_text_field.dart';
import '../commons/helper_functions.dart';
import 'data_handler.dart';
import 'models.dart';

class FilterHandler extends ChangeNotifier {
  List<String> filterButtonvalues = [
    "Seller Type",
    "Zip Search",
    "State",
    "Year",
    "Model",
    "Price",
    "Exterior Color",
    "Interior Color",
    "Condition",
    "Auto Pilot Software",
    "Battery",
    "Vehicle History",
    "Modification",
    "Additional Options",
  ];

  List<String> sortByvalues = [
    "Low to high",
    "High to low",
    "Newest first",
    "Total km run",
    "Manufacturing Year"
  ];

  final List<CheckBoxModel> _states = [
    CheckBoxModel("Alabama", false),
    CheckBoxModel("Alaska", false),
    CheckBoxModel("Arizona", false),
    CheckBoxModel("Arkansas", false),
    CheckBoxModel("California", false),
    CheckBoxModel("Colorado", false),
    CheckBoxModel("Connecticut", false),
    CheckBoxModel("Delaware", false),
    CheckBoxModel("Florida", false),
    CheckBoxModel("Georgia", false),
    CheckBoxModel("Hawaii", false),
    CheckBoxModel("Idaho", false),
    CheckBoxModel("Illinois", false),
    CheckBoxModel("Indiana", false),
    CheckBoxModel("Iowa", false),
    CheckBoxModel("Kansas", false),
    CheckBoxModel("Kentucky", false),
    CheckBoxModel("Louisiana", false),
    CheckBoxModel("Maine", false),
    CheckBoxModel("Maryland", false),
    CheckBoxModel("Massachusetts", false),
    CheckBoxModel("Michigan", false),
    CheckBoxModel("Minnesota", false),
    CheckBoxModel("Mississippi", false),
    CheckBoxModel("Missouri", false),
    CheckBoxModel("Montana", false),
    CheckBoxModel("Nebraska", false),
    CheckBoxModel("Nevada", false),
    CheckBoxModel("New Hampshire", false),
    CheckBoxModel("New Jersey", false),
    CheckBoxModel("New Mexico", false),
    CheckBoxModel("New York", false),
    CheckBoxModel("North Carolina", false),
    CheckBoxModel("North Dakota", false),
    CheckBoxModel("Ohio", false),
    CheckBoxModel("Oklahoma", false),
    CheckBoxModel("Oregon", false),
    CheckBoxModel("Pennsylvania", false),
    CheckBoxModel("Rhode Island", false),
    CheckBoxModel("South Carolina", false),
    CheckBoxModel("South Dakota", false),
    CheckBoxModel("Tennessee", false),
    CheckBoxModel("Texas", false),
    CheckBoxModel("Utah", false),
    CheckBoxModel("Vermout", false),
    CheckBoxModel("Virginia", false),
    CheckBoxModel("Washington", false),
    CheckBoxModel("West Verginia", false),
    CheckBoxModel("Wiscosin", false),
    CheckBoxModel("Wyoming", false)
  ];

  final List<CheckBoxModel> _carModelList = [
    CheckBoxModel("Model S", false),
    CheckBoxModel("Model E", false),
    CheckBoxModel("Model X", false),
    CheckBoxModel("Model Y", false),
    CheckBoxModel("Roadster", false),
  ];

  final List<CheckBoxModel> _extColorList = [
    CheckBoxModel("Custom", false),
    CheckBoxModel("Silver Metallic Paint", false),
    CheckBoxModel("Red Multi-Coat Paint", false),
    CheckBoxModel("Midnight Silver Metallic Paint", false),
    CheckBoxModel("Deep Blue Metallic Paint", false),
    CheckBoxModel("Solid Black Paint", false),
    CheckBoxModel("Pearl White Paint", false),
  ];
  final List<CheckBoxModel> _intColorList = [
    CheckBoxModel("Black", false),
    CheckBoxModel("Pearl White Paint", false),
  ];

  final List<CheckBoxModel> _conditionList = [
    CheckBoxModel("Excellent", false),
    CheckBoxModel("Very Good", false),
    CheckBoxModel("Good", false),
    CheckBoxModel("Fair", false)
  ];
  final List<CheckBoxModel> _autoPilotList = [
    CheckBoxModel("Base Autopilot (AP)", false),
    CheckBoxModel("Enhanced Autopilot (EAP)", false),
    CheckBoxModel("Full Self Driving (FSD)", false),
    CheckBoxModel("No Autopilot (Not Capable)", false),
  ];
  final List<CheckBoxModel> _batteryList = [
    CheckBoxModel("100 kWh", false),
    CheckBoxModel("53 kWh", false),
    CheckBoxModel("70 kWh", false),
  ];
  final List<CheckBoxModel> _historyList = [
    CheckBoxModel("Clean History", false),
    CheckBoxModel("Previously Repaired", false),
  ];
  final List<CheckBoxModel> _modifyList = [
    CheckBoxModel("Yes", false),
    CheckBoxModel("No", false)
  ];
  final List<CheckBoxModel> _additionList = [
    CheckBoxModel("Premium Sound System", false),
    CheckBoxModel("Air Suspension", false),
    CheckBoxModel("Subzero Weather Package", false),
    CheckBoxModel("HEPA Air Filtration System", false),
    CheckBoxModel("Infotainment Upgrade", false),
  ];

  int _index = 7;
  int get getSortIndex => _index;
  setSortIndex(int i) {
    _index = i;
    notifyListeners();
  }

  clearSortFilter() {
    _index = sortByvalues.length + 1;
    notifyListeners();
  }

  bool isSortSelected(int i) => i == _index;

  // Seller Type
  String _sellerType = '';
  String get getSellertype => _sellerType;
  setSellerType(String type) {
    _sellerType = type;
    notifyListeners();
  }

  // Zip Search
  String _zipCode = '';
  String get getZip => _zipCode;
  setZipCode(String zip) {
    _zipCode = zip;
    notifyListeners();
  }

  // State Filter
  String _state = '';
  String get getStateFilter => _state;

  // model year Range
  SfRangeValues _modelYearValue = SfRangeValues(2008, DateTime.now().year);

  // Car Model Filter
  String _carModel = '';

  // Car Price Filter Value
  SfRangeValues _priceRange = const SfRangeValues(91, 500000);

  // Exterior Color Filter
  String _extColor = '';

  // Interior Color Filter
  String _intColor = '';

  // Car Condition Filter
  String _condition = '';

  // Auto Pilot Filter
  String _autoPilot = '';

  //Battery power Filter
  String _battery = '';

  // History Filter
  String _history = '';

  //Modificatio History Filter
  String _modify = '';

  // Addtional Filter
  String _aditionals = '';

  /// Seller filter Widget Fucntion
  Widget sellerFilter(BuildContext context) {
    return Column(
      children: _sellers
          .map((e) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _sellerType = e.title,
                          for (var stype in _sellers) {stype.isActive = false},
                          _sellers[_sellers.indexOf(e)].isActive = v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  // Zip Search filter Widget Function
  Widget zipFilter() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: CustomTextField(
          onValueChange: (v) => {_zipCode = v, notifyListeners()},
          shrink: true,
          showBorder: true,
          hint: "Search..",
        ));
  }

  // States Filter Widget Function
  Widget stateFilter(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    final carsList = db.getCarsList;
    return Column(
      children: _states
          .map(
            (e) => ListTile(
              leading: Checkbox(
                  value: e.isActive,
                  onChanged: (v) => {
                        _state = e.title,
                        for (var stype in _states) {stype.isActive = false},
                        _states[_states.indexOf(e)].isActive = v,
                        notifyListeners()
                      }),
              title: Text(e.title, style: textTheme(context).headlineMedium),
              trailing: Text(
                  "(${carsList.where((element) => element.state == e.title).toList().length.toString()})"),
            ),
          )
          .toList(),
    );
  }

  /// Model Year Filter Widget Function
  Widget modelYearFilter(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(10),
      child: SfRangeSlider(
        min: 2008,
        max: DateTime.now().year,
        values: _modelYearValue,
        interval: 1,
        stepSize: 1,
        showTicks: true,
        // showLabels: true,
        enableTooltip: true,
        // minorTicksPerInterval: 1,
        onChanged: (SfRangeValues values) {
          _modelYearValue = values;
          notifyListeners();
        },
      ),
    );
  }

  // Car Model filters Widget

  Widget carModelView(BuildContext context) {
    return Column(
      children: _carModelList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _carModel = e.title,
                          for (var model in _carModelList)
                            {model.isActive = false},
                          _carModelList[_carModelList.indexOf(e)].isActive = v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  // Car Price Widget Function
  Widget carPricefilter(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 130,
          padding: const EdgeInsets.all(10),
          child: SfRangeSlider(
            min: 91,
            max: 500000,
            values: _priceRange,
            interval: 50000,
            showTicks: true,
            enableTooltip: true,
            tooltipTextFormatterCallback: (actualValue, formattedText) =>
                "\$ ${double.parse(actualValue.toString()).toStringAsFixed(2)}",
            onChanged: (SfRangeValues values) {
              _priceRange = values;
              notifyListeners();
            },
          ),
        ));
  }

  //Exterior Color Widget Function
  Widget exteriorColorFilter(BuildContext context) {
    return Column(
      children: _extColorList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _extColor = e.title,
                          for (var model in _extColorList)
                            {model.isActive = false},
                          _extColorList[_extColorList.indexOf(e)].isActive = v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  //Interior Color Widget Function
  Widget interiorColorFilter(BuildContext context) {
    return Column(
      children: _intColorList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _intColor = e.title,
                          for (var model in _intColorList)
                            {model.isActive = false},
                          _intColorList[_intColorList.indexOf(e)].isActive = v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  // car condition Widget Function
  Widget carCondtionFilter(BuildContext context) {
    return Column(
      children: _conditionList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _condition = e.title,
                          for (var model in _conditionList)
                            {model.isActive = false},
                          _conditionList[_conditionList.indexOf(e)].isActive =
                              v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  // Auto Pilot Widget Function
  Widget autoPilotFilter(BuildContext context) {
    return Column(
      children: _autoPilotList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _autoPilot = e.title,
                          for (var model in _autoPilotList)
                            {model.isActive = false},
                          _autoPilotList[_autoPilotList.indexOf(e)].isActive =
                              v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  //Battery Widget Function
  Widget batteryFilter(BuildContext context) {
    return Column(
      children: _batteryList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _battery = e.title,
                          for (var model in _batteryList)
                            {model.isActive = false},
                          _batteryList[_batteryList.indexOf(e)].isActive = v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  // Vehicle hISTORy Widget Function
  Widget vehicleHistoryFilter(BuildContext context) {
    return Column(
      children: _historyList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _history = e.title,
                          for (var model in _historyList)
                            {model.isActive = false},
                          _historyList[_historyList.indexOf(e)].isActive = v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  // Car Modification Widget Function
  Widget modificationFilter(BuildContext context) {
    return Column(
      children: _modifyList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _modify = e.title,
                          for (var model in _modifyList)
                            {model.isActive = false},
                          _modifyList[_modifyList.indexOf(e)].isActive = v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  // Additional Features Widget Function
  Widget additionalFilter(BuildContext context) {
    return Column(
      children: _additionList
          .map((e) => ListTile(
                leading: Checkbox(
                    value: e.isActive,
                    onChanged: (v) => {
                          _aditionals = e.title,
                          for (var model in _additionList)
                            {model.isActive = false},
                          _additionList[_additionList.indexOf(e)].isActive = v,
                          notifyListeners()
                        }),
                title: Text(e.title, style: textTheme(context).headlineMedium),
              ))
          .toList(),
    );
  }

  Widget getFilters(BuildContext context, String itemType) {
    switch (itemType) {
      case "Seller Type":
        return sellerFilter(context);
      case "Zip Search":
        return zipFilter();
      case "State":
        return stateFilter(context);
      case "Year":
        return modelYearFilter(context);
      case "Model":
        return carModelView(context);
      case "Price":
        return carPricefilter(context);
      case "Exterior Color":
        return exteriorColorFilter(context);
      case "Interior Color":
        return interiorColorFilter(context);
      case "Condition":
        return carCondtionFilter(context);
      case "Auto Pilot Software":
        return autoPilotFilter(context);
      case "Battery":
        return batteryFilter(context);
      case "Vehicle History":
        return vehicleHistoryFilter(context);
      case "Modification":
        return modificationFilter(context);
      case "Additional Options":
        return additionalFilter(context);

      default:
        return const SizedBox();
    }
  }

  final List<CheckBoxModel> _sellers = [
    CheckBoxModel("All", false),
    CheckBoxModel("All Private Seller", false),
    CheckBoxModel("Dealer", false)
  ];

  List<UsedCarModel> filterData(List<UsedCarModel> carsList) {
    debugPrint(carsList.map((e) => e.state).toList().toString());
    var list1 = _sellerType == ''
        ? carsList
        : carsList
            .where((element) => _sellerType.contains(element.sellerType))
            .toList();
    var list2 = _zipCode == ''
        ? list1
        : list1.where((element) => element.zipcode == _zipCode).toList();
    var list3 = _state == ''
        ? list2
        : list2.where((element) => element.state == _state).toList();
    var list4 = list3
        .where((element) => element.modelYear != '' || element.modelYear != null
            ? int.parse(element.modelYear) >=
                    int.parse(
                        _modelYearValue.start.toString().substring(0, 4)) &&
                int.parse(element.modelYear) <=
                    int.parse(_modelYearValue.end.toString().substring(0, 4))
            : false)
        .toList();
    var list5 = _carModel == ""
        ? list4
        : list4
            .where((element) =>
                element.modelName.toLowerCase() == _carModel.toLowerCase())
            .toList();
    var list6 = list5
        .where((element) => element.price != '' || element.price != null
            ? double.parse(element.price) >=
                    double.parse(_priceRange.start.toString()) &&
                double.parse(element.price) <=
                    double.parse(_priceRange.end.toString())
            : false)
        .toList();
    var list7 = _extColor == ''
        ? list6
        : list6
            .where((element) =>
                element.exteriorColor.toLowerCase() == _extColor.toLowerCase())
            .toList();
    var list8 = _intColor == ""
        ? list7
        : list7
            .where((element) =>
                element.interiorColor.toLowerCase() == _intColor.toLowerCase())
            .toList();
    var list9 = list8;
    var list10 = _autoPilot == ''
        ? list9
        : list9
            .where((element) =>
                element.autoPilot.toLowerCase() == _autoPilot.toLowerCase())
            .toList();
    var list11 = _battery == ''
        ? list10
        : list10.where((element) => element.battery == _battery).toList();
    var list12 = _history == ''
        ? list11
        : list11
            .where((element) =>
                element.vehicleHistory.toLowerCase() == _history.toLowerCase())
            .toList();
    var list13 = _modify == ''
        ? list12
        : list12.where((element) => element.isModification == _modify).toList();
    var list14 = _aditionals == ''
        ? list13
        : list13
            .where((element) =>
                element.additionalOpt.toLowerCase() ==
                _aditionals.toLowerCase())
            .toList();
    return list14;
  }

  void resetFilter() {
    _sellerType = '';
    _zipCode = '';
    _state = '';
    _modelYearValue = SfRangeValues(2008, DateTime.now().year);
    _carModel = '';
    _priceRange = const SfRangeValues(91, 500000);
    _extColor = '';
    _intColor = '';
    _condition = '';
    _autoPilot = '';
    _battery = '';
    _history = '';
    _modify = '';
    _aditionals = '';
    notifyListeners();
  }
}

class CheckBoxModel {
  String title;
  bool isActive;
  CheckBoxModel(this.title, this.isActive);
}
