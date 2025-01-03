import 'package:aqar_detailes/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Detailes extends StatefulWidget {
  const Detailes({super.key});

  @override
  State<Detailes> createState() => _DetailesState();
}

class _DetailesState extends State<Detailes> {
  bool click = false;

  Container simpleCard(Icon icon, String title) {
    return Container(
      height: 110,
      width: 110,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.brown[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(backgroundColor: Colors.brown[200], child: icon),
          Text(
            title,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Future<void> addDeleteFavorite(String url) async {
    var response = await http.post(Uri.parse(url), body: {
      "uid": "${Data.userInfo[0]['UID']}",
      "rid": "${Data.DetailesRE[0]['RID']}",
    });
  }

  @override
  void initState() {
    Data.isDragable = false;
    if (Data.pageFrom == "f") {
      Data.getFavoriteImages(Data.DetailesRE[0]['RID']);
    } else if (Data.pageFrom == "r") {
      Data.getImages(Data.DetailesRE[0]['RID']);
    } else if (Data.pageFrom == "m") {
      Data.getImagesUserRealEstate(Data.DetailesRE[0]['RID']);
    } else if (Data.pageFrom == "o") {
      Data.getImagesOwnerRealEstate(Data.DetailesRE[0]['RID']);
    }

    click = Data.isFavorite(Data.DetailesRE[0]['RID']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          /*InkWell(
            child: CircleAvatar(
              radius: 20,
              backgroundImage: Data.userInfo.isNotEmpty
                  ? NetworkImage(
                      "${Data.imgPath}${Data.userInfo[0]['ImgProfileName']}")
                  : NetworkImage("${Data.imgPath}user.png"),
            ),
            onTap: () {
              if (Data.isLogin) {
                Navigator.of(context).pushNamed("setting");
              } else {
                Navigator.of(context).pushNamed("login");
              }
            },
          ),
          IconButton(
            icon: Data.loginOut,
            onPressed: () async {
              if (Data.isLogin) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: DialogType.scale,
                  btnOkColor: Colors.brown,
                  title: 'Are you sure ?',
                  desc: 'Are you sure you want to logout?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    setState(() {
                      Data.isLogin = false;
                      Data.checkprefs = false;
                      Data.loginOut = Icon(Icons.login);
                      Data.userInfo.clear();
                      Data.FinalFavorite.clear();
                      Data.FinalUserRealEstate.clear();
                    });
                  },
                )..show();
              } else {
                Navigator.of(context).pushNamed("login");
              }
            },
          ),*/
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).pushNamed("filtering");
            },
          ),
        ],
        //title: Text("Detailes Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 222,
                  child: InkWell(
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: Data.Images.length,
                      itemBuilder: (context, i) {
                        return Data.Images[i];
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed("slider");
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 150, right: 10),
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      iconSize: 25,
                      color: click ? Colors.brown : Colors.grey,
                      icon: const Icon(Icons.favorite),
                      onPressed: () async {
                        if (Data.isLogin) {
                          setState(() {
                            click = !click;
                            if (click) {
                              addDeleteFavorite("${Data.apiPath}insert_favorite.php");
                            } else {
                              addDeleteFavorite("${Data.apiPath}delete_favorite.php");
                            }
                          });
                        } else {
                          Navigator.of(context).pushNamed("login");
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 205),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    "${Data.DetailesRE[0]['RealEstateType']}",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                InkWell(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.place),
                                      Text("${Data.DetailesRE[0]['Governorate']}"),
                                    ],
                                  ),
                                  onTap: () async {
                                    Data.lat = Data.DetailesRE[0]['Lat'];
                                    Data.lng = Data.DetailesRE[0]['Lng'];
                                    Navigator.of(context).pushNamed("map");
                                  },
                                ),
                              ],
                            ),
                            Text(
                              "${Data.DetailesRE[0]['Price']}JD",
                              style: const TextStyle(fontSize: 20, color: Colors.brown, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            simpleCard(const Icon(Icons.bed), "${Data.DetailesRE[0]['NBedRooms']} BedRooms"), //3
                            simpleCard(const Icon(Icons.bathroom), "${Data.DetailesRE[0]['NBathRooms']} BathRooms"), //2
                            simpleCard(const Icon(Icons.kitchen), "${Data.DetailesRE[0]['NKitchens']} Kitchens"), //1
                            simpleCard(const Icon(Icons.living), "${Data.DetailesRE[0]['NLivingRooms']} Livingrooms"), //2
                            simpleCard(const Icon(Icons.space_bar), "${Data.DetailesRE[0]['Space']} sqm"), //160
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "${Data.DetailesRE[0]['Description']}",
                              style: const TextStyle(
                                fontSize: 17,
                                wordSpacing: 2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("${Data.imgPath}${Data.ownerInfo[0]['ImgProfileName']}"),
                                        radius: 30,
                                      ),
                                      title: Text("${Data.ownerInfo[0]['Name']}"),
                                      subtitle: const Text("property owner"),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushNamed("account");
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 10,
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Colors.brown[400],
                                            ),
                                            child: const Text("Send Massage"),
                                            onPressed: () {
                                              //Chat Code
                                              /*Navigator.of(context)
                                                  .pushNamed("chat");*/
                                              String number = Data.ownerInfo[0]['PhoneNumber'];
                                              print("Phone : $number");

                                              final Uri launchUri = Uri(
                                                scheme: 'sms',
                                                path: number,
                                              );
                                              launchUrl(launchUri);
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              backgroundColor: Colors.green[400],
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(Icons.call),
                                                Text("Call"),
                                              ],
                                            ),
                                            onPressed: () async {
                                              String number = Data.ownerInfo[0]['PhoneNumber'];
                                              print("Phone : $number");

                                              final Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path: number,
                                              );
                                              launchUrl(launchUri);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
