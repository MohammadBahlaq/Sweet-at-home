// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, avoid_single_cascade_in_expression_statements

import 'package:aqar_detailes/add_real_estate_page.dart';
import 'package:aqar_detailes/favorite_page.dart';
import 'package:aqar_detailes/my_real_estate_page.dart';
import 'package:aqar_detailes/result_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data {
  //Paths //192.168.218.118
  static String imgPath = "http://10.0.2.2/Images_Real_Estate/";
  static String apiPath = "http://10.0.2.2/APl_Real_State/";
  //Results
  static List Results = [];
  static List FinalResults = [];
  //Filtering
  static List<int> nBedRooms = [1, 2, 3, 4];
  static List<int> nBathRooms = [1, 2, 3];
  static List<int> nKitchens = [1, 2, 3];
  static List<int> nLivingRooms = [1, 2, 3, 4];
  static int minPrice = 0;
  static int maxPrice = 999999999999999999;
  static int minSpace = 0;
  static int maxSpace = 999999999999999999;
  static String selected = "Amman";
  static String realEstateType = "For Sale";
  //Detailes
  static List DetailesRE = [];
  static List<Widget> Images = [];
  static List<Widget> ImagesSlider = [];
  static String pageFrom = "r";
  static String addEdit = "add";

  //BottomNavigationBar
  static int currentIndex = 0;
  static List<Widget> pages = [
    Result(),
    Favorite(),
    MyRealEstate(),
    AddProperty(),
  ];
  //User
  static List userInfo = [];
  static List favorite = [];
  static List FinalFavorite = [];
  static List UserRealEstate = [];
  static List FinalUserRealEstate = [];
  static Icon loginOut = Icon(Icons.login);
  static bool isLogin = false;
  //static String? emailText = "";
  //static String? passwordText = "";
  static bool checkprefs = true;
  //Owner
  static List ownerInfo = [];
  static List ownerRealEstate = [];
  static List FinalOwnerRealEstate = [];
  static List Review = [];

  static void getFinalResults() {
    FinalResults.clear();

    FinalResults.add(Results[0]);

    for (int i = 1; i < Results.length; i++) {
      if (Results[i]['RID'] != Results[i - 1]['RID']) {
        FinalResults.add(Results[i]);
      }
    }
  }

  static void getImages(int RID) {
    Images.clear();
    ImagesSlider.clear();
    //print("Results Length: ${Results.length} And RID: $RID");

    for (int i = 0; i < Results.length; i++) {
      if (Results[i]['RID'] == RID) {
        Images.add(Image.network("${Data.imgPath}${Results[i]['ImageName']}",
            fit: BoxFit.fill));
        ImagesSlider.add(
            Image.network("${Data.imgPath}${Results[i]['ImageName']}"));
      } else if (Results[i]['RID'] > RID) {
        return;
      }
    }
    //print("Images Lingth: ${Images.length}");
  }

  static void getFinalFavorite() {
    FinalFavorite.clear();

    FinalFavorite.add(favorite[0]);

    for (int i = 1; i < favorite.length; i++) {
      if (favorite[i]['RID'] != favorite[i - 1]['RID']) {
        FinalFavorite.add(favorite[i]);
      }
    }
  }

  static void getFavoriteImages(int RID) {
    Images.clear();
    ImagesSlider.clear();
    //print("favorite Length: ${favorite.length} And RID: $RID");

    for (int i = 0; i < favorite.length; i++) {
      if (favorite[i]['RID'] == RID) {
        Images.add(Image.network("${Data.imgPath}${favorite[i]['ImageName']}",
            fit: BoxFit.fill));
        ImagesSlider.add(
            Image.network("${Data.imgPath}${favorite[i]['ImageName']}"));
      } else if (favorite[i]['RID'] > RID) {
        return;
      }
    }
    //print("Images Lingth: ${Images.length}");
  }

  static bool isFavorite(int RID) {
    for (int i = 0; i < FinalFavorite.length; i++) {
      if (FinalFavorite[i]['RID'] == RID) {
        return true;
      }
    }
    return false;
  }

  static void getFinalUserRealEstate() {
    FinalUserRealEstate.clear();

    FinalUserRealEstate.add(UserRealEstate[0]);

    for (int i = 1; i < UserRealEstate.length; i++) {
      if (UserRealEstate[i]['RID'] != UserRealEstate[i - 1]['RID']) {
        FinalUserRealEstate.add(UserRealEstate[i]);
      }
    }
  }

  static getImagesUserRealEstate(int RID) {
    Images.clear();
    ImagesSlider.clear();
    //print("UserRealEstate Length: ${UserRealEstate.length} And RID: $RID");

    for (int i = 0; i < UserRealEstate.length; i++) {
      if (UserRealEstate[i]['RID'] == RID) {
        if (UserRealEstate[i]['ImageName'] == "logo.png") {
          return;
        }
        Images.add(Image.network(
            "${Data.imgPath}${UserRealEstate[i]['ImageName']}",
            fit: BoxFit.fill));
        ImagesSlider.add(
            Image.network("${Data.imgPath}${UserRealEstate[i]['ImageName']}"));
      } else if (UserRealEstate[i]['RID'] > RID) {
        return;
      }
    }
    //print("Images Lingth: ${Images.length}");
  }

  static void getFinalOwnerRealEstate() {
    FinalOwnerRealEstate.clear();

    FinalOwnerRealEstate.add(ownerRealEstate[0]);

    for (int i = 1; i < ownerRealEstate.length; i++) {
      if (ownerRealEstate[i]['RID'] != ownerRealEstate[i - 1]['RID']) {
        FinalOwnerRealEstate.add(ownerRealEstate[i]);
      }
    }
  }

  static getImagesOwnerRealEstate(int RID) {
    Images.clear();
    ImagesSlider.clear();
    //print("ownerRealEstate Length: ${ownerRealEstate.length} And RID: $RID");

    for (int i = 0; i < ownerRealEstate.length; i++) {
      if (ownerRealEstate[i]['RID'] == RID) {
        Images.add(Image.network(
            "${Data.imgPath}${ownerRealEstate[i]['ImageName']}",
            fit: BoxFit.fill));
        ImagesSlider.add(
            Image.network("${Data.imgPath}${ownerRealEstate[i]['ImageName']}"));
      } else if (ownerRealEstate[i]['RID'] > RID) {
        return;
      }
    }
    //print("Images Lingth: ${Images.length}");
  }

  static Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", "${Data.userInfo[0]['Email']}");
    print("prefs Email: ${prefs.getString("email")}");
    await prefs.setString("password", "${Data.userInfo[0]['Password']}");
    print("prefs Password: ${prefs.getString("password")}");
  }
}
