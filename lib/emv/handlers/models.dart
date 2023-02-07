class UserModel {
  String authToken,
      name,
      email,
      avatar,
      address,
      country,
      city,
      postalCode,
      phone;
  int userId;
  UserModel(this.authToken, this.name, this.email, this.avatar, this.address,
      this.country, this.city, this.postalCode, this.phone, this.userId);
  UserModel.fromUser(Map<String, dynamic> data, this.authToken)
      : name = data['name'].toString(),
        email = data['email'].toString(),
        avatar = data['avatar'].toString(),
        country = data['country'].toString(),
        address = data['address'].toString(),
        city = data['city'].toString(),
        postalCode = data['postal_code'].toString(),
        phone = data['phone'].toString(),
        userId = int.parse(data['id'].toString());
}

class StocksModel {
  String changePercent, regularchange, marketPrice;
  StocksModel(this.changePercent, this.regularchange, this.marketPrice);
  StocksModel.fromStocks(Map<String, dynamic> json)
      : changePercent = json['regularMarketChangePercent'].toString(),
        regularchange = json['regularMarketChange'].toString(),
        marketPrice = json['regularMarketPrice'].toString();
}

class ForumsModel {
  String id, userId, name, avatar, model, question, description, status;
  int views, flag_count, flags, likes, comments;
  double ratings;

  ForumsModel(
      this.id,
      this.userId,
      this.name,
      this.avatar,
      this.model,
      this.question,
      this.description,
      this.status,
      this.views,
      this.flag_count,
      this.flags,
      this.likes,
      this.comments,
      this.ratings);
  ForumsModel.fromForums(Map<String, dynamic> json)
      : id = json['id'].toString(),
        userId = json['user_id'].toString(),
        name = json['name'].toString(),
        avatar = json['avatar'].toString(),
        model = json['model'].toString(),
        question = json['question'].toString(),
        description = json['description'].toString(),
        status = json['status'].toString(),
        views = int.parse(json['view'].toString()),
        flag_count = int.parse(json['flag_count'].toString()),
        flags = int.parse(json['flag'].toString()),
        likes = int.parse(json['likes'].toString()),
        comments = int.parse(json['comments'].toString()),
        ratings = json['rating'] != null
            ? double.parse(json['rating'].toString())
            : 0.0;
}

class MultiMediaModel {
  String mediaId,
      userId,
      title,
      description,
      image,
      video,
      model,
      isType,
      username,
      name,
      avatar;
  int views, flag_count, type, comments, likes, flags;
  double ratings;
  MultiMediaModel(
      this.mediaId,
      this.userId,
      this.title,
      this.description,
      this.image,
      this.video,
      this.model,
      this.isType,
      this.username,
      this.name,
      this.avatar,
      this.views,
      this.flag_count,
      this.type,
      this.comments,
      this.likes,
      this.flags,
      this.ratings);
  MultiMediaModel.fromMedia(Map<String, dynamic> json)
      : mediaId = json['id'].toString(),
        userId = json['user_id'].toString(),
        title = json['title'].toString(),
        description = json['description'].toString(),
        image = json['image'].toString(),
        video = json['video'].toString(),
        model = json['model'].toString(),
        isType = json['is_type'].toString(),
        username = json['user_name'].toString(),
        name = json['name'].toString(),
        avatar = json['avatar'].toString(),
        views = int.parse(json['view'].toString()),
        flag_count = int.parse(json['flag_count'].toString()),
        type = int.parse(json['type'].toString()),
        comments = int.parse(json['comments'].toString()),
        likes = int.parse(json['likes'].toString()),
        flags = int.parse(json['flags'].toString()),
        ratings = json['rating'] != null
            ? double.parse(json['rating'].toString())
            : 0.0;
}

class UsedCarModel {
  String id,
      name,
      address,
      addedBy,
      userId,
      modelYear,
      modelName,
      zipcode,
      state,
      vehicleHistory,
      topSpeed,
      speedRange,
      epa,
      autoPilot,
      autoHardware,
      isPerformance,
      isModification,
      additionalOpt,
      interiorColor,
      exteriorColor,
      thumbnail,
      video,
      description,
      battery,
      price,
      sellerType,
      slug;
  List<String> photos;
  dynamic owner;
  UsedCarModel(
      this.id,
      this.name,
      this.address,
      this.addedBy,
      this.userId,
      this.modelYear,
      this.modelName,
      this.zipcode,
      this.state,
      this.vehicleHistory,
      this.topSpeed,
      this.speedRange,
      this.epa,
      this.autoPilot,
      this.autoHardware,
      this.isPerformance,
      this.isModification,
      this.additionalOpt,
      this.interiorColor,
      this.exteriorColor,
      this.thumbnail,
      this.video,
      this.description,
      this.battery,
      this.sellerType,
      this.price,
      this.slug,
      this.owner,
      this.photos);
  UsedCarModel.fromCars(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'].toString(),
        address = json['address'].toString(),
        addedBy = json['added_by'].toString(),
        userId = json['user_id'].toString(),
        modelYear = json['model_year'].toString(),
        modelName = json['model_name'].toString(),
        zipcode = json['zip_code'].toString(),
        state = json['state_name'].toString(),
        vehicleHistory = json['vehicle_history'].toString(),
        topSpeed = json['top_speed'].toString(),
        speedRange = json['speed_range'].toString(),
        epa = json['epa'].toString(),
        autoPilot = json['auto_pilot_software'].toString(),
        autoHardware = json['auto_hardware'].toString(),
        isPerformance = json['is_perfomance'].toString(),
        isModification = json['is_modification'].toString(),
        additionalOpt = json['additional_option_id'].toString(),
        interiorColor = json['interior_color_id'].toString(),
        exteriorColor = json['exterior_color_id'].toString(),
        thumbnail = json['thumbnail_img'].toString(),
        video = json['video_link'].toString(),
        description = json['description'].toString(),
        battery = json['battery_id'].toString(),
        price = json['price'].toString(),
        slug = json['slug'].toString(),
        sellerType = json['seller_type_id'] != null
            ? json['seller_type_id'] == 1
                ? "Private"
                : json['seller_type_id'] == 2
                    ? 'Dealer'
                    : ''
            : '',
        owner = json['user'] == null
            ? null
            : CarOwnerModel.fromOwner(json['user'] as Map<String, dynamic>),
        photos = (json["photos"] as List).map((e) => e.toString()).toList();
}

class CarOwnerModel {
  String ownerId,
      firstName,
      lastName,
      email,
      avatar,
      address,
      country,
      city,
      postalCode,
      guid,
      phone;
  CarOwnerModel(
      this.ownerId,
      this.firstName,
      this.lastName,
      this.email,
      this.avatar,
      this.address,
      this.country,
      this.city,
      this.postalCode,
      this.guid,
      this.phone);
  CarOwnerModel.fromOwner(Map<String, dynamic> json)
      : ownerId = json['id'].toString(),
        firstName = json['first_name'].toString(),
        lastName = json['last_name'].toString(),
        email = json['email'].toString(),
        avatar = json['avatar'].toString(),
        address = json['address'].toString(),
        country = json['country'].toString(),
        guid = json['guid'].toString(),
        city = json['city'].toString(),
        postalCode = json['postal_code'].toString(),
        phone = json['phone'].toString();
}

class NewsModel {
  String newsId,
      newsType,
      title,
      newsLink,
      guid,
      pubDate,
      description,
      content,
      newsModel,
      imageUrl,
      source,
      thumbImage,
      fullImage,
      name;
  int views, flag, likes, comments;
  double rating, totalRating;
  NewsModel(
      this.newsId,
      this.newsType,
      this.title,
      this.newsLink,
      this.guid,
      this.pubDate,
      this.description,
      this.content,
      this.newsModel,
      this.imageUrl,
      this.source,
      this.thumbImage,
      this.fullImage,
      this.name,
      this.views,
      this.flag,
      this.likes,
      this.comments,
      this.rating,
      this.totalRating);
  NewsModel.fromNews(Map<String, dynamic> json)
      : newsId = json['id'].toString(),
        newsType = json['type'].toString(),
        title = json['title'].toString(),
        newsLink = json['link'].toString(),
        guid = json['guid'].toString(),
        pubDate = json['pubDate'].toString(),
        description = json['description'].toString(),
        content = json['content'].toString(),
        newsModel = json['model'].toString(),
        imageUrl = json['image_url'].toString(),
        source = json['source'].toString(),
        thumbImage = json['thumb_img'] == ""
            ? "https://elonmuskvision.com/uploads/161988549204.png"
            : json['thumb_img'].toString(),
        fullImage = json['full_img'].toString(),
        name = json['name'].toString(),
        views = int.parse(json['view'].toString()),
        flag = int.parse(json['flag'].toString()),
        likes = int.parse(json['likes'].toString()),
        comments = (json['comments'] as List).length,
        rating = double.parse(json['rating'].toString()),
        totalRating = double.parse(json['totalrating'].toString());
}

class ChatModel {
  String msgId, modelType, msg, senderName, senderImage, msgtime;
  int senderId;
  ChatModel(this.msgId, this.senderId, this.modelType, this.msg, this.msgtime,
      this.senderName, this.senderImage);
  ChatModel.fromMsg(Map<String, dynamic> json)
      : msgId = json['id'].toString(),
        modelType = json['typemodel'].toString(),
        msg = json['message'].toString(),
        senderName = json['name'].toString(),
        msgtime = json['created_at'].toString(),
        senderImage = json['avatar'].toString(),
        senderId = int.parse(json['sender_id'].toString());
}

class CommentsModel {
  int commentId, userId;
  String comment, dateTime;
  int commentBy;
  List<dynamic> reply;
  CommentsModel(this.commentId, this.userId, this.comment, this.dateTime,
      this.reply, this.commentBy);
  CommentsModel.fromComments(Map<String, dynamic> json)
      : commentId = int.parse(json['id'].toString()),
        userId = int.parse(json['commentBy'].toString()),
        comment = json['comments'].toString(),
        dateTime = json['created_at'].toString(),
        reply = json['reply'],
        commentBy = json['commentBy'];
}

class Reply {
  int id;
  int blogId;
  String comments;
  String createdAt;
  int type;
  int parentId;
  Reply(this.id, this.blogId, this.comments, this.createdAt, this.type,
      this.parentId);
  Reply.fromComments(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        blogId = int.parse(json['blog_id'].toString()),
        comments = json['comments'].toString(),
        createdAt = json['created_at'].toString(),
        parentId = int.parse(json['parent_id'].toString()),
        type = int.parse(json['type'].toString());
}
