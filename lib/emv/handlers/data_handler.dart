import 'dart:developer';
import 'dart:io';

import 'package:emv/emv/handlers/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../commons/helper_functions.dart';
import '../commons/stylesheet.dart';
import '../commons/toast.dart';
import '../screens/auth/login.dart';
import '../screens/dashboard.dart';
import 'api_handler.dart';
import 'filter_handler.dart';
import 'models.dart';

dynamic prefs;

class AppDataHandler with ChangeNotifier {
  // Msg Handler
  final List<String> _msgs = [];
  List<String> get getChatList => _msgs;

  // theme Color Handler
  Color _theme = kDefaultColor;
  Color get getColorTheme => _theme;
  setColorTheme(Color clr) {
    _theme = clr;
    notifyListeners();
  }

  List<String> _latestupdate = [];
  List<String> get getLatestUpdate => _latestupdate;
  setUpdates(List<String> updates) {
    _latestupdate = updates;
    notifyListeners();
  }

  // Connection Check Status
  bool _connection = false;
  bool get getConnection => _connection;
  updateConnection(bool status) {
    _connection = status;
    notifyListeners();
  }

  // loader State
  bool _loding = false;
  bool get getLoaderState => _loding;
  setLoader(bool status) {
    _loding = status;
    notifyListeners();
  }

  // User Profile Data
  dynamic _user;
  dynamic get getUserProfile => _user;

  String _ratingdata = "";
  setRatingData(String data) {
    _ratingdata = data;
    notifyListeners();
  }

  // Forum Data State Defined
  String _forumState = 'tesla';
  setForumState(String state) {
    _forumState = state;
    notifyListeners();
  }

  // Stocks Handler Data
  StocksModel _stocks = StocksModel("0.0%", "0.0", "0.0");
  StocksModel get getStocks => _stocks;

  // Multimedia News State Defined
  String newsType = "1";
  String type = "";
  String newsModel = "All";
  int newcount = -1;
  int subcount = 12;
  int subnewcount = 1;
  bool checkfilterCliked = false;
  bool get getCheckFilterClicked => checkfilterCliked;
  setCheckFilterClicked(bool status) {
    checkfilterCliked = status;
    notifyListeners();
  }

  String get getNewsType => newsType;
  // Get the forum host and route here
  String getForumRoute() {
    switch (newsType) {
      case "1":
        return teslaForumAPI;
      case "2":
        return spaceForumAPI;
      case "3":
        return elonMuskForumAPI;
      default:
        return '';
    }
  }

  setNewsModel(String model) {
    newsModel = model;
    newcount = -1;
    subnewcount = 1;
    notifyListeners();
  }

  setNewsType(String type) {
    newsType = type;
    newcount = -1;
    subnewcount = 1;
    notifyListeners();
  }

  String _newsContent = '';
  String get getNewsDetail => _newsContent;
  emptyContent() {
    _newsContent = '';
    //notifyListeners();
  }

  String _mediaState = '';
  setMediaState(String state) {
    _mediaState = state;
    //notifyListeners();
  }

  // Latest News Datastore
  List<NewsModel> _news = [];
  List<NewsModel> get getLatestNews => _news;

  // Used Cars List store
  List<UsedCarModel> _carsList = [];
  List<UsedCarModel> get getCarsList => _carsList;

  // Favorite Cars
  final List<String> _favCars = [];
  List<String> get getFavCarsList => _favCars;
  addtoFavs(String carId) {
    _favCars.add(carId);
    notifyListeners();
  }

  // Comments List
  List<CommentsModel> _comments = [];
  List<CommentsModel> get getComments => _comments;
  resetComments() {
    _comments = [];
    notifyListeners();
  }

  dynamic resdata = "";
  setResData(data) {
    resdata = data;
    notifyListeners();
  }

  // Get the Media Host and route here
  String getMediaRoute() {
    switch (newsType) {
      case "1":
        return teslaMultiMediaAPI;
      case "2":
        return spaceMultiMediaAPI;
      case "3":
        return alonMuskMultiMediaAPI;

      default:
        return '';
    }
  }

  // ChatRoom Models
  final List<String> _teslaChatRoom = [
    "Model S (0)",
    "Model 3 (0)",
    "Model X (0)",
    "Model Y (0)",
    "Roadster (0)",
    "Semi (0)",
    "Cybertruck (0)",
    "TESLA (0)"
  ];
  final List<String> _spaceXChatRoom = [
    "FALCON 9 (0)",
    "FALCON HEAVY (0)",
    "DRAGON (0)",
    "STARSHIP (0)",
    "STARLINK (0)",
    "SpaceX (0)"
  ];

  final List<String> _teslaEnergyChatRoom = [
    "Gigafactory",
    "Solar Panels/Roof",
    "Powerwall"
  ];

  final List<String> _teslaOptimus = [];

  final List<String> _elonMuskChatRoom = [
    "Elon Musk (0)",
    "Artificial Intelligence (0)",
    "The Boring Company (0)",
    "Hyperloop (0)"
  ];

  List<String> get getChatroomList {
    if (newsType == "1" && newsModel == "") {
      return _teslaChatRoom;
    } else if (newsType == "2") {
      return _spaceXChatRoom;
    } else if (newsType == "3") {
      return _elonMuskChatRoom;
    }
    if (newsModel == "ENERGY" ||
        newsModel == "ENERGY-GIGAFACTORY" ||
        newsModel == "ENERGY-SOLARPANELSROOF" ||
        newsModel == "ENERGY-POWERWALL") {
      return _teslaEnergyChatRoom;
    } else if (newsModel == "OPTIMUS") {
      return _teslaOptimus;
    } else if (newsType == "1" && newsModel == "ENERGY") {
      return _teslaEnergyChatRoom;
    } else if (newsType == "1" && newsModel == "OPTIMUS") {
      return _teslaOptimus;
    } else {
      return _teslaChatRoom;
    }
  }

  // forums List
  List<ForumsModel> _forums = [];
  List<ForumsModel> get getFormList => _forums;
  dynamic _newsModelByID;
  dynamic get newsModelDetailByid => _newsModelByID;
  // Multimedia News List
  List<MultiMediaModel> _media = [];
  List<MultiMediaModel> get getMultiMediaNews => _media;

  // Chat List
  List<ChatModel> _chats = [];
  List<ChatModel> get getChatingList => _chats;

  // Ads
  List<String> _adds = [];
  List<String> get getAdvertisements => _adds;

  // Flags List
  List<int> _flags = [];
  List<int> get getFlagsList => _flags;

  // Fav Cars
  List<int> _favsCar = [];
  List<int> get getFavList => _favsCar;

  // get Forum List
  Future<bool> fetchForums() async {
    debugPrint("Forum Fatching");
    try {
      debugPrint(getForumRoute() + newsModel);
      var response = await RequestHandler.getServerRequest(
          url: getForumRoute() + newsModel);
      print(response);
      if (response != null) {
        fetchFlagsList();
        final data = response['data'] as List;
        _forums = data.map((e) => ForumsModel.fromForums(e)).toList();
        notifyListeners();

        return true;
      } else {
        _forums = [];
        notifyListeners();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getLatestUpdates() async {
    var response = await RequestHandler.getServerRequest(url: latestUpdateAPI);
    if (response != null) {
      final newsData = response['data'] as List;
      _latestupdate =
          newsData.map((e) => e['title'].toString() + "  ||  ").toList();
      notifyListeners();
      return true;
    } else {
      _latestupdate = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> newsFilterSearch(
      String keyword, String orderBy, String startOn) async {
    subnewcount = 1;
    checkfilterCliked = true;
    notifyListeners();
    var response = await RequestHandler.getServerRequest(
        url: newFilterAPI(keyword, newsType, orderBy, startOn));
    print(newFilterAPI(keyword, newsType, orderBy, startOn));
    if (response != null) {
      type = 'Filter';
      _news = [];
      notifyListeners();
      _news = (response as List).map((e) => NewsModel.fromNews(e)).toList();
      print(_news);
      print(response.toString());
      notifyListeners();
      return true;
    } else {
      _news = [];
      notifyListeners();
      return false;
    }
  }

  // Tesla Motors, Energy, Optimus Mix News Functions\
  Future<bool> fetchMixNewsEvents() async {
    newcount += 1;
    notifyListeners();
    var response = await RequestHandler.getServerRequest(
        url: mixNewsAPI(newsModel, newcount.toString()));
    debugPrint("News API :: " + mixNewsAPI(newsModel, newcount.toString()));
    if (response != null) {
      await fetchFlagsList();
      final list = response['data'] as List;
      //_news.add(value)
      //_news=list.map((e) => _news.add(NewsModel.fromNews(e))).toList();
      _news = list.map((e) => NewsModel.fromNews(e)).toList();
      notifyListeners();
      return true;
    } else {
      _news = [];
      notifyListeners();
      return false;
    }
  }

  // get Multimedia News List
  Future<bool> fetchMultimedia() async {
    try {
      var response = await RequestHandler.getServerRequest(
          url: getMediaRoute() + newsModel);
      debugPrint("Url :: ${getMediaRoute()}$newsModel");
      if (response != null) {
        fetchFlagsList();
        final data = response["data"] as List;
        debugPrint(data.toString());
        _media = data.map((e) => MultiMediaModel.fromMedia(e)).toList();
        notifyListeners();
        return true;
      } else {
        _media = [];
        notifyListeners();
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  String getfilterType() {
    switch (newsModel) {
      case "ENERGY-GIGAFACTORY":
        return "4";
      case "ENERGY-SOLARPANELSROOF":
        return "4";
      case "ENERGY-POWERWALL":
        return "4";
      case "ENERGY":
        return "4";

      default:
        return newsType;
    }
  }

  Future<bool> forumFilterSearch(
      String keyword, String orderBy, String startOn) async {
    try {
      print("Check news type");
      print(newsType);
      var data = {
        "searchKeywords": keyword,
        "orderby": orderBy,
        "start_on": startOn,
        "type": getfilterType(),
        "model": newsModel.toUpperCase()
      };
      print("Data");
      print(data);
      var response = await RequestHandler.postServerRequest(
          "https://elonmuskvision.com/api/v1/forumdiadata", data, false);
      print(response);
      print("Media of Data");
      print(response["code"]);
      if (response["code"] == 200) {
        //  fetchFlagsList();
        _forums = [];
        final data = response["data"] as List;
        _forums = data.map((e) => ForumsModel.fromForums(e)).toList();
        notifyListeners();
        return true;
      } else {
        _forums = [];
        notifyListeners();
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> multimediaFilterSearch(
      String keyword, String orderBy, String startOn) async {
    try {
      var data = {
        "searchKeywords": keyword,
        "orderby": orderBy,
        "start_on": startOn,
        "type": newsType,
        "model": newsModel
      };
      print("Data");
      print(data);
      var response = await RequestHandler.postServerRequest(
          "https://www.elonmuskvision.com/api/v1/multimediadata", data, false);
      print(response);
      print("Media of Data");
      print(response["code"]);
      if (response["code"] == 200) {
        //  fetchFlagsList();
        _media = [];
        final data = response["data"] as List;
        _media = data.map((e) => MultiMediaModel.fromMedia(e)).toList();
        print("Multi News");
        print(getMultiMediaNews);
        notifyListeners();
        return true;
      } else {
        _media = [];
        notifyListeners();
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> fatchUsedCars(
      {String sortBy = '', @required BuildContext context}) async {
    final filterDb = Provider.of<FilterHandler>(context, listen: false);
    var response = await RequestHandler.getServerRequest(
        url: usedCarAPI, sendHeader: false);
    if (response != null) {
      getFavCarsCount();
      final list = response['data'] as List;
      final carsList = list.map((e) => UsedCarModel.fromCars(e)).toList();
      sortBy == ''
          ? null
          : sortBy == "Low to high"
              ? carsList.sort((a, b) =>
                  double.parse(a.price).compareTo(double.parse(b.price)))
              : sortBy == "High to low"
                  ? carsList.sort((a, b) =>
                      double.parse(b.price).compareTo(double.parse(a.price)))
                  : sortBy == "Manufacturing Year"
                      ? carsList.sort((a, b) => double.parse(a.modelYear)
                          .compareTo(double.parse(b.modelYear)))
                      : null;
      debugPrint(carsList.length.toString());
      final filterList = filterDb.filterData(carsList);
      debugPrint(filterList.length.toString());
      _carsList = filterList;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> fatchStocks() async {
    var response = await RequestHandler.getServerRequest(url: stocksAPI);
    log(stocksAPI);
    if (response != null) {
      _stocks = StocksModel.fromStocks(response);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // Registration Function Handler
  Future<bool> registerUser(
      BuildContext context, Map<String, String> bodyData) async {
    try {
      var response =
          await RequestHandler.postServerRequest(SIGNUP_API, bodyData, false);
      debugPrint(SIGNUP_API);
      if (response != null) {
        toast("Registration successful. Please login to your account");
        pushAndReplace(context, LoginScreen());
        return true;
      } else {
        toast("Server connection errorr! plase try again later");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // User Login Function Handler
  Future<bool> loginUser(
      BuildContext context, Map<String, String> creds, int pageIndex) async {
    try {
      var response =
          await RequestHandler.postServerRequest(LOGIN_API, creds, false);
      if (response != null) {
        print("Profile");
        print(response['user']);
        _user = UserModel.fromUser(response['user'], response['access_token']);
        prefs.setString("authToken", response['access_token']);
        prefs.setString("userid", response['user']['id'].toString());
        prefs.setString("username", response['user']['user_name'].toString());
        prefs.setString("phone", response['user']['phone'].toString());
        prefs.setString("email", response['user']['email'].toString());
        prefs.setString("password", response['user']['password'].toString());
        prefs.setString("name", response['user']['name'].toString());
        prefs.setString("profile_image", response['user']['avatar'].toString());
        print(response['user']);
        toast("Welcome Back ${response['user']['name']}");
        pushAndRemove(context, DashboardScreen(viewIndex: pageIndex));
        return true;
      } else {
        toast("Please check your credentials");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchUserProfile() async {
    var response = await RequestHandler.getServerRequest(
        url: getProfileAPI, sendHeader: true);
    if (response != null) {
      _user = UserModel.fromUser(response, prefs.getString("authToken"));
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendCarEnquiry(Map<String, String> json) async {
    var response =
        await RequestHandler.postServerRequest(submitCarEnquirAPI, json, false);
    if (response != null) {
      debugPrint('Car Enquiry Response  :: $response');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> fatchLatestNews({bool changeRoute = false}) async {
    // _news=[];
    // notifyListeners();
    subcount += 12;
    var adv = await RequestHandler.getServerRequest(url: advertAPI);
    final List<String> advList = adv == null
        ? []
        : (adv as List).map((e) => e['image'].toString()).toList();
    _adds = advList;
    notifyListeners();
    var response = await RequestHandler.getServerRequest(
        url: (newsModel == "MOTOR" ||
                newsModel == "ENERGY" ||
                newsModel == "OPTIMUS")
            ? mixNewsAPI(newsModel, subcount.toString())
            : getNewAPI(newcount.toString(), newsType, newsModel),
        sendHeader: false);
    print(getNewAPI(newcount.toString(), newsType, newsModel));
    print(response);
    if (response != null) {
      await fetchFlagsList();
      final list = response as List;
      _news = list.map((e) => NewsModel.fromNews(e)).toList();
      notifyListeners();
      return true;
    } else {
      _news = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> fatchLatestNewsLoadMore({bool changeRoute = false}) async {
    print(newsType);
    subnewcount += 1;
    var adv = await RequestHandler.getServerRequest(url: advertAPI);
    final List<String> advList = adv == null
        ? []
        : (adv as List).map((e) => e['image'].toString()).toList();
    _adds = advList;
    notifyListeners();
    var response = await RequestHandler.getServerRequest(
        url: (newsModel == "MOTOR" ||
                newsModel == "ENERGY" ||
                newsModel == "OPTIMUS")
            ? mixNewsAPI(newsModel, subnewcount.toString())
            : getNewAPILoadMore(
                newsType.toString(), subnewcount.toString(), newsModel),
        sendHeader: false);
    print(getNewAPILoadMore(
        newsType.toString(), subnewcount.toString(), newsModel));
    if (response != null) {
      await fetchFlagsList();
      final list = response as List;
      _news = _news + list.map((e) => NewsModel.fromNews(e)).toList();
      notifyListeners();
      return true;
    } else {
      _news = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> fatchLatestNewsSpaceXLoadMore({bool changeRoute = false}) async {
    print(newsType);
    subnewcount += 1;
    var adv = await RequestHandler.getServerRequest(url: advertAPI);
    final List<String> advList = adv == null
        ? []
        : (adv as List).map((e) => e['image'].toString()).toList();
    _adds = advList;
    notifyListeners();
    var response = await RequestHandler.getServerRequest(
        url: (newsModel == "FALCON 9" ||
                newsModel == "FALCON HEAVY" ||
                newsModel == "DRAGON" ||
                newsModel == "STARSHIP" ||
                newsModel == "STARLINK")
            ? mixNewsAPI(newsModel, subnewcount.toString())
            : getNewAPILoadSpaceXMore(
                subnewcount.toString(), subnewcount.toString(), newsModel),
        sendHeader: false);
    if (response != null) {
      await fetchFlagsList();
      final list = response as List;
      _news = _news + list.map((e) => NewsModel.fromNews(e)).toList();
      notifyListeners();
      return true;
    } else {
      _news = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> fatchLatestNewsElonMuskLoadMore(
      {bool changeRoute = false}) async {
    print(newsType);
    subnewcount += 1;
    // print("new count "+newcount.toString() + "page "+);
    var adv = await RequestHandler.getServerRequest(url: advertAPI);
    final List<String> advList = adv == null
        ? []
        : (adv as List).map((e) => e['image'].toString()).toList();
    _adds = advList;
    notifyListeners();
    var response = await RequestHandler.getServerRequest(
        url: (newsModel == "Artificial Intelligence" ||
                newsModel == "Hyperloop" ||
                newsModel == "Boring Company")
            ? mixNewsAPI(newsModel, subnewcount.toString())
            : getNewAPILoadElonMuskMore(
                subnewcount.toString(), subnewcount.toString(), newsModel),
        sendHeader: false);
    if (response != null) {
      await fetchFlagsList();
      final list = response as List;
      _news = _news + list.map((e) => NewsModel.fromNews(e)).toList();
      notifyListeners();
      return true;
    } else {
      _news = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> fatchLatestNewsWithModel({bool changeRoute = false}) async {
    newcount += 1;
    var adv = await RequestHandler.getServerRequest(url: advertAPI);
    final List<String> advList = adv == null
        ? []
        : (adv as List).map((e) => e['image'].toString()).toList();
    _adds = advList;
    notifyListeners();
    var response = await RequestHandler.getServerRequest(
        url: (newsModel == "MOTOR" ||
                newsModel == "ENERGY" ||
                newsModel == "OPTIMUS")
            ? mixNewsAPI(newsModel, newcount.toString())
            : getNewAPIWithModel(newcount.toString(), newsType, newsModel),
        sendHeader: false);
    if (response != null) {
      await fetchFlagsList();
      final list = response as List;
      _news = list.map((e) => NewsModel.fromNews(e)).toList();
      notifyListeners();
      return true;
    } else {
      _news = [];
      notifyListeners();
      return false;
    }
  }

  /// News Related Actions Functions

  Future<bool> submitNewsFlag(Map<String, String> json, int type) async {
    var response =
        await RequestHandler.postServerRequest(submitFlagAPI, json, true);
    if (response != null) {
      debugPrint("Flag Response :: $response");
      if (type == 1) {
        fatchLatestNews();
      } else if (type == 2) {
        fetchForums();
      } else {
        fetchMultimedia();
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> submitNewsLike(String newsId, int type) async {
    var apiUrl = type == 1
        ? likePostAPI
        : type == 2
            ? likeforumAPI
            : likeMediaAPI;
    var formValue = type == 1
        ? "blogId"
        : type == 2
            ? "forum_id"
            : "multimedia_id";
    debugPrint(apiUrl);
    var response = await RequestHandler.postServerRequest(
        apiUrl, {formValue: newsId}, true);
    if (response != null) {
      /* if (type == 1) {
        await fatchLatestNews();
      } else if (type == 2) {
        debugPrint("Success Forum");
        await fetchForums();
      } else {
        await fetchMultimedia();
      }*/
      return true;
    } else {
      return false;
    }
  }

  Future<bool> submitRating(
      String blogId, String rating, String mediatype) async {
    String url = "";
    if (mediatype == "news" || mediatype == "forum") {
      url = submitRatingAPI;
    } else {
      url = submitRatingMultimediaAPI;
    }

    //toast(url+" "+blogId+" "+mediatype);
    var response = await RequestHandler.postServerRequest(
        url, {"rCommentBlogid": blogId, "rating": rating}, true);
    // print(response);
    // print("ratings "+blogId+" "+rating);
    if (response != null) {
      //setResData(response);
      //notifyListeners();
      if (mediatype == "news") {
        await fatchLatestNews();
      } else if (mediatype == "forum") {
        await fetchForums();
      } else {
        await fetchMultimedia();
      }
      return true;
    } else {
      return false;
    }
  }

  //* Forums Related Action Functions

  Future<bool> fatchComments(String id, int type) async {
    _comments = [];
    //notifyListeners();
    final url = type == 1
        ? getNewsCommentsAPI(id)
        : type == 2
            ? getForumCommentsAPI(id)
            : getMediaCommentsAPI(id);
    print(url);
    var response = await RequestHandler.getServerRequest(url: url);
    print("Id : - " + id);
    if (response != null) {
      print(response['comment']);
      final cList = response['comment'] as List;
      debugPrint("CommentsList :: $cList");
      _comments = cList.map((e) => CommentsModel.fromComments(e)).toList();
      notifyListeners();
      return true;
    } else {
      _comments = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> postForum(Map<String, String> json) async {
    var response =
        await RequestHandler.postServerRequest(createForumAPI, json, true);
    if (response != null) {
      await fetchForums();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postMedia(
      Map<String, String> json, String name, String path) async {
    print(path);
    print(name);
    print(json.toString());
    var response = await RequestHandler.sendMultiPart(
        url: createMediaAPI, bodyData: json, fileName: name, filePath: path);

    print(response);
    print("media data");
    if (response != null) {
      await fetchMultimedia();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postMedia1(String title, String description, String type,
      String model, String image, bool isImage) async {
    print(image);
    print(title);
    // var response = await RequestHandler.sendMultiPart(
    //     url: createMediaAPI, bodyData: json, fileName: name, filePath: path);
    var request = http.MultipartRequest('POST', Uri.parse(createMediaAPI));
    request.fields['id'] = prefs.getString('userid');
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['type'] = type;
    request.fields['model'] = model;
    request.headers
        .addAll({"Authorization": "Bearer ${prefs.getString("authToken")}"});
    if (isImage) {
      request.files.add(http.MultipartFile('image',
          File(image).readAsBytes().asStream(), File(image).lengthSync(),
          filename: image.split("/").last));
    } else {
      request.files.add(http.MultipartFile('video',
          File(image).readAsBytes().asStream(), File(image).lengthSync(),
          filename: image.split("/").last));
    }
    var res = await request.send();
    final respStr = await res.stream.bytesToString();

    print(respStr);
    print("media data");
    if (respStr != null) {
      await fetchMultimedia();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> fetchNewsDetails(String blogId) async {
    var response =
        await RequestHandler.getServerRequest(url: newsDetailsAPI + blogId);
    if (response != null) {
      _newsContent = (response['blogsData'] as List).first['content'];
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postNewsComments(String blogId, String comment, int type) async {
    var response = await RequestHandler.postServerRequest(
        newsCommentAPI(blogId, comment), {}, true);
    if (response != null) {
      await fatchLatestNews();
      await fatchComments(blogId, type);
      notifyListeners();
      return true;
    } else {
      debugPrint("not posted");
      return false;
    }
  }

  Future<bool> postSubNewsComments(String newId, String blogId,
      String commentby, String comment, int type) async {
    var data = {
      "rCommentComments": comment,
      "commentBy": commentby,
      "rCommentreplyparent_id": blogId,
    };
    var response = await RequestHandler.postSubServerRequest(
        newsSubCommentAPI(blogId, comment), data, true);
    if (response != null) {
      await fatchLatestNews();
      await fatchComments(newId, type);
      notifyListeners();
      return true;
    } else {
      debugPrint("not posted");
      return false;
    }
  }

  Future<bool> postForumComments(
      String blogId, String comment, int type) async {
    var response = await RequestHandler.postServerRequest(
        forumCommentsAPI(blogId, comment), {}, true);
    if (response != null) {
      await fetchForums();
      await fatchComments(blogId, type);
      notifyListeners();
      return true;
    } else {
      debugPrint("not posted");
      return false;
    }
  }

  String getFlagModels() {
    switch (newsType) {
      case "1":
        return "blogflag";
      case "2":
        return "forumflag";
      case "3":
        return "multimediaflag";
      default:
        return '';
    }
  }

  Future<bool> fetchFlagsList() async {
    var response = await RequestHandler.getServerRequest(
        url: getFlagsAPI + getFlagModels(), sendHeader: true);
    if (response != null) {
      debugPrint(response.toString());
      final data = response as List;
      final List<int> removeFlags =
          data.map((v) => int.parse(v['blog_id'].toString())).toList();
      _flags = removeFlags;
      notifyListeners();
      return true;
    } else {
      _flags = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> postMediaComments(String blogId, String comment) async {
    var response = await RequestHandler.postServerRequest(
        multiMediaCommentAPI(blogId, comment), {}, true);
    if (response != null) {
      await fetchMultimedia();
      fatchComments(blogId, 3);
      notifyListeners();
      return true;
    } else {
      debugPrint("not posted");
      return false;
    }
  }

  String oldModelValue = "";
  Future<bool> sendMsg(String msg, String path, String name) async {
    //toast(getChatModel(newsType, newsModel));
    if (oldModelValue != "" && oldModelValue != newsModel) {
      _chats = [];
      notifyListeners();
    }
    Map<String, String> json = {
      "message": msg,
      "typemodel": getChatModel(newsType, newsModel),
      "type": newTypeValue()
    };

    debugPrint(json.toString());
    var response = await RequestHandler.sendMultiPart(
        url: sendMsgAPI, bodyData: json, filePath: path, fileName: name);
    if (response != null) {
      _msgs.add(msg);
      debugPrint("Msg Response :: $response");
      notifyListeners();
      return true;
    } else {
      toast("could not sent");
      return false;
    }
  }

  Future<bool> getMsg() async {
    //toast(newsModel.toString());
    var response = await RequestHandler.getServerRequest(
        url: getMsgAPI(getChatModel(newsType, newsModel)), sendHeader: true);
    print(getMsgAPI(getChatModel(newsType, newsModel)));
    print(response.toString());
    print(getMsgAPI(getChatModel(newsType, newsModel)));
    if (response != null) {
      print(response.toString());
      final msgList = response['chat']['messages'] as List;
      // if (_chats.length == msgList.length &&
      //     newsModel == msgList.first['typemodel'].toString()) {
      //   null;
      // } else {

      _chats = msgList.map((e) => ChatModel.fromMsg(e)).toList();
      //}
      return true;
    } else {
      return false;
    }
  }

  String newTypeValue() {
    switch (newsType) {
      case "1":
        return "Tesla";
      case "2":
        return "SpaceX";
      case "3":
        return "AlonMusk";
      default:
        return '';
    }
  }

  Future<bool> addCarToFavorite(BuildContext context, String carId) async {
    var response = await RequestHandler.postServerRequest(
        favoriteAPI, {"car_id": carId}, true);
    if (response != null) {
      await fatchUsedCars(context: context);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getFavCarsCount() async {
    var response = await RequestHandler.getServerRequest(url: getFavCarAPI);
    if (response != null) {
      final data = response['Car List'] as List;
      final List<int> favs =
          data.map((e) => int.parse(e['car_id'].toString())).toList();
      _favsCar = favs;
      notifyListeners();

      return true;
    } else {
      _favsCar = [];
      notifyListeners();
      return false;
    }
  }

  Future<dynamic> getNewsDetailsById(String newsId) async {
    var response =
        await RequestHandler.getServerRequest(url: getNewsById(newsId));
    if (response != null) {
      _newsModelByID = response['blogsData'][0];
      return true;
    } else {
      return false;
    }
  }

  getCounterAPI(type) {
    switch (type) {
      case "forum":
        return forumViewCounterAPI;
      default:
        return mediaViewCounterAPI;
    }
  }

  Future<bool> viewCounterFunction(
      String type, Map<String, String> data) async {
    await RequestHandler.postServerRequest(getCounterAPI(type), data, false);
    return true;
  }
}
