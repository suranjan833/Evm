import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../commons/toast.dart';
import 'data_handler.dart';

class RequestHandler {
  // HTTP Post Request Handler

  static Future<dynamic> postServerRequest(
      String url, Map<String, String> bodyData, bool headers) async {
    try {
      var snapshot = http.MultipartRequest("POST", Uri.parse(url));
      snapshot.fields.addAll(bodyData);
      headers
          ? snapshot.headers.addAll({
              "Authorization": "Bearer ${prefs.getString("authToken")}",
              "Accept": "application/json"
            })
          : snapshot.headers.addAll({"Accept": "application/json"});
      var response = await snapshot.send();
      final data = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final a = json.decode(data);
        return a;
      } else {
        debugPrint(data);
        return null;
      }
    } on HttpException catch (e) {
      debugPrint(e.message);
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<dynamic> postSubServerRequest(
      String url, Map<String, String> bodyData, bool headers) async {
    try {
      var snapshot = http.MultipartRequest("POST", Uri.parse(url));
      snapshot.fields.addAll(bodyData);
      headers
          ? snapshot.headers.addAll({
              "Authorization": "Bearer ${prefs.getString("authToken")}",
              "Accept": "application/json"
            })
          : snapshot.headers.addAll({"Accept": "application/json"});
      var response = await snapshot.send();
      final data = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final a = json.decode(data);
        return a;
      } else {
        debugPrint(data);
        return null;
      }
    } on HttpException catch (e) {
      debugPrint(e.message);
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<dynamic> sendMultiPart(
      {@required String url,
      @required Map<String, String> bodyData,
      bool headers = true,
      String filePath = '',
      String fileName = ''}) async {
    try {
      var snapshot = http.MultipartRequest("POST", Uri.parse(url));
      snapshot.fields.addAll(bodyData);
      snapshot.headers
          .addAll({"Authorization": "Bearer ${prefs.getString("authToken")}"});
      if (filePath.isNotEmpty || filePath != '') {
        snapshot.files
            .add(await http.MultipartFile.fromPath(fileName, filePath));
      }
      var response = await snapshot.send();
      final data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final a = json.decode(data);
        return a;
      } else {
        return null;
      }
    } on HttpException catch (e) {
      toast(e.message);
      return null;
    } catch (e) {
      toast(e.toString());
      return null;
    }
  }

  static Future<dynamic> getServerRequest(
      {@required String url, bool sendHeader = true}) async {
    try {
      // final snapshots = http
      var snapshot = http.Request("GET", Uri.parse(url));
      sendHeader
          ? snapshot.headers.addAll(
              {"Authorization": "Bearer ${prefs.getString("authToken")}"})
          : null;
      http.StreamedResponse response = await snapshot.send();
      final data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final decoded = json.decode(data);
        return decoded;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
