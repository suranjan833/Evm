import '../app_config.dart';

const String getUrl = "$baseUrl/api/v1/";

// Auth API Paths
const String SIGNUP_API = "${getUrl}auth/signup";
const String LOGIN_API = "${getUrl}auth/login";
const String getProfileAPI = "${getUrl}auth/user";

// Forums API Paths
String teslaForumAPI = "${getUrl}teslaforum?model=";
String elonMuskForumAPI = "${getUrl}elonmuskforum?model=";
String spaceForumAPI = "${getUrl}spacexforum?model=";

// Multimedia API Paths
String teslaMultiMediaAPI = "${getUrl}teslamultimedia?model=";
String spaceMultiMediaAPI = "${getUrl}spacexmultimedia?model=";
String alonMuskMultiMediaAPI = "${getUrl}elonmuskmultimedia?model=";

// Stocks api Path
const String stocksAPI = "${getUrl}teslastock";

// Used Cars Api Paths
const String usedCarAPI = "${getUrl}cars";
const String enquiryAPI = "${getUrl}submit-car-enquiry";
const String favoriteAPI = "${getUrl}auth/add-to-favourite-car";
const String getFavCarAPI = "${getUrl}auth/favourite-car";

// Latest News Path
// String getNewAPI(String page, String type) =>
//     "${getUrl}latestnews?pageno=$page&type=$type";
//String getNewAPI(String page, String type, String model) =>"${getUrl}laodmore?newstype=$type&pageno=$page";
String getNewAPI(String page, String type, String model) =>
    "${getUrl}allinfo?type=$type&model=$model&pageno=12";
//String getNewAPILoadMore(String page, String type) =>"${getUrl}load-more-type?newstype=$type&page=$page";
String getNewAPILoadMore(String page, String count, String model) =>
    "${getUrl}tesla-news/loadmore?last_id=$count&model=$model&page=$count";
String getNewAPILoadSpaceXMore(String page, String count, String model) =>
    "${getUrl}spacex-news/loadmore?last_id=$count&model=$model&page=$count";
String getNewAPILoadElonMuskMore(String page, String count, String model) =>
    "${getUrl}elonmusk-news/loadmore?last_id=$count&model=$model&page=$count";
String getNewAPIWithModel(String page, String type, String model) =>
    "${getUrl}loaddmodel?newstype=$type&model=$model&pageno=$page";
//"${getUrl}allinfo?model=$model&type=$type&pageno=$page";
//"${getUrl}allinfo?model=$model&type=$type&pageno=$page";
String newsDetailsAPI = "${getUrl}news-details/";
String allNewsAPI = '${getUrl}alllatestnews?pageno=';
String mixNewsAPI(String model, String limit) =>
    getUrl + "optional?model=$model&limit=$limit";

// Action API Paths
const String submitFlagAPI = "${getUrl}auth/submitflag";
const String likePostAPI = "${getUrl}auth/addlike";
const String likeforumAPI = "${getUrl}auth/addlikeform";
const String likeMediaAPI = "${getUrl}auth/addlikemultimedia";
// const String getCommentAPI = "${getUrl}commentlist?id=";
const String submitCarEnquirAPI = "${getUrl}submit-car-enquiry";
const String createForumAPI = "${getUrl}auth/createforumtopic";
const String createMediaAPI = "${getUrl}auth/createmedia";
const String submitRatingAPI = "${getUrl}auth/submitrating";
const String submitRatingMultimediaAPI = "${getUrl}auth/multiratings";
//https://elonmuskvision.com/api/v1/auth/multiratings?multimedia_id=47&rating=3
// POst Comments API Paths

String forumCommentsAPI(String blogId, String comment) =>
    "${getUrl}auth/forumCommentssubmit?forum_id=$blogId&comments=$comment";
String multiMediaCommentAPI(String blogId, String comment) =>
    "${getUrl}auth/multimediaCommentssubmit?rCommentBlogid=$blogId&rCommentComments=$comment";
String newsCommentAPI(String blogId, String comment) =>
    "${getUrl}auth/newsssubmit?rCommentBlogid=$blogId&rCommentComments=$comment";
String newsSubCommentAPI(String blogId, String comment) =>
    "${getUrl}comment_reply?rCommentComments=$comment";
// Get Comments API paths
String getForumCommentsAPI(String forumId) =>
    "${getUrl}forumCommentslist?forum_id=$forumId";
String getNewsCommentsAPI(String newId) => "${getUrl}commentlist?id=$newId";
String getMediaCommentsAPI(String mediaID) =>
    '${getUrl}multimediaCommentlist?multimedia_id=$mediaID';

/// Chat Api
String getMsgAPI(String model) => "${getUrl}auth/getchat?model=$model";
const String sendMsgAPI = "${getUrl}auth/sendmsg";

// Advertisement API
String advertAPI = "${getUrl}advertisementshow";

const String getFlagsAPI = "${getUrl}auth/getsubmitflag?table=";
const String latestUpdateAPI = "${getUrl}latestupdatenews";

// News Filter Api
String newFilterAPI(
        String keyword, String type, String orderBy, String startOn) =>
    //"${getUrl}durations?type=$type&start_on=-$startOn";
    "${getUrl}keywordsdetails?searchKeywords=$keyword&type=$type&orderby=$orderBy&start_on=$startOn";
String getNewsById(String newsId) => "${getUrl}news-details/$newsId";

// View Count handler api

String forumViewCounterAPI = "$getUrl" + "forum_save_view_count";
String mediaViewCounterAPI = "$getUrl" + "multimedia_save_view_count";
