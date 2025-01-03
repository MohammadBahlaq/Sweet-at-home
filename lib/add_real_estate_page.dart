import 'package:aqar_detailes/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:string_validator/string_validator.dart';

class AddProperty extends StatefulWidget {
  const AddProperty({super.key});

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  TextEditingController title = TextEditingController();
  TextEditingController Description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController price = TextEditingController();

  TextEditingController area = TextEditingController();
  double Nr = 1; //هنا تخزن قيمه الbedroom
  double NBr = 1; //هنا تخزت قيمه ال bathroom
  double Nk = 1; //هنا تخزت قيمه الkitchen
  double Ns = 1; //هنا تخزت قيمه ال Living room
  String Datselected = "Irbid";
  String ct = "For Sale";

  ///////////////////////////////////////////////////////////////////////////////
  //GlobalKey<ScaffoldState> snakBar = GlobalKey<ScaffoldState>();
  int rid = 0;
  int ridfk = 0;

  Future<void> AddRealEstate() async {
    String url = "${Data.apiPath}insert_realEstate.php";

    var response = await http.post(
      Uri.parse(url),
      body: {
        "title": title.text,
        "nbedrooms": "$Nr",
        "nbathrooms": "$NBr",
        "nkitchens": "$Nk",
        "nlivingrooms": "$Ns",
        "price": price.text,
        "space": area.text,
        "governorate": Datselected,
        "lat": "${Data.lat}",
        "lng": "${Data.lng}",
        "realestatetype": ct,
        "description": Description.text,
        "publisherid": "${Data.userInfo[0]['UID']}",
      },
    );
    var responsbody = response.body.toString();
    rid = int.parse(responsbody);

    print("responsbody: $responsbody");
    print("id: $rid");

    if (_files!.isNotEmpty) {
      for (int i = 0; i < _files!.length; i++) {
        await AddRealEstateImages(_files![i].name, rid);
      }
    } else {
      await AddRealEstateImages("logo.png", rid);
    }
  }

  Future<void> AddRealEstateImages(String imgName, int RID) async {
    String url = "${Data.apiPath}insert_realEstateImages.php";
    var response = await http.post(
      Uri.parse(url),
      body: {
        "rid_fk": "$RID",
        "imagename": imgName,
      },
    );
  }

  Future<void> EditRealEstate() async {
    String url = "${Data.apiPath}update_realEstate.php";
    //print("ct: $ct");
    var response = await http.post(
      Uri.parse(url),
      body: {
        "ridfk": "$ridfk",
        "title": title.text,
        "nbedrooms": "$Nr",
        "nbathrooms": "$NBr",
        "nkitchens": "$Nk",
        "nlivingrooms": "$Ns",
        "price": price.text,
        "space": area.text,
        "governorate": Datselected,
        "lat": "${Data.lat}",
        "lng": "${Data.lng}",
        "realEstatetype": ct,
        "description": Description.text,
        "rid": "${Data.DetailesRE[0]['RID']}",
      },
    );

    if (_files!.isNotEmpty) {
      url = "${Data.apiPath}delete_realEstateImages.php";
      response = await http.post(Uri.parse(url), body: {"ridfk": "${Data.DetailesRE[0]['RID']}"});

      for (int i = 0; i < _files!.length; i++) {
        await AddRealEstateImages(_files![i].name, Data.DetailesRE[0]['RID']);
      }
    }
  }

  List<PlatformFile>? _files = [];
  Future<void> uploadFile(int index) async {
    var uri = Uri.parse('${Data.apiPath}upload_file.php');

    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', _files![index].path.toString()));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Uploaded ...');
    } else {
      print('Something went wrong!');
    }
  }

  Future<void> _openFileExplorer() async {
    _files = (await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true, allowedExtensions: null))!.files;
    for (int i = 0; i < _files!.length; i++) {
      await uploadFile(i);

      print("ImageName: ${_files![i].name}");

      if (Data.currentIndex == 2) {
        if (i == 0) {
          Data.Images.clear();
          ridfk = Data.DetailesRE[0]['RID'];
        }
        Data.Images.add(Image.network("${Data.imgPath}${_files![i].name}"));
      }
    }
    setState(() {});

    print('Loaded file Name is : ${_files!.length}');
  }

  Future<void> getLocation() async {
    bool services = await Geolocator.isLocationServiceEnabled();

    if (services == false) {
      AwesomeDialog(
        context: context,
        btnOkOnPress: () {},
        desc: "Turn on Location Please",
        dialogType: DialogType.warning,
      ).show();
    }

    LocationPermission permision = await Geolocator.checkPermission();

    if (permision == LocationPermission.denied) {
      permision = await Geolocator.requestPermission();

      if (permision != LocationPermission.denied) {
        Position currentLocation = await Geolocator.getCurrentPosition().then((value) => value);
        Data.lat = currentLocation.latitude;
        Data.lng = currentLocation.longitude;
        print("=========================================");
        print("Lat: ${Data.lat}");
        print("Lng: ${Data.lng}");
        print("=========================================");
      }
    } else {
      Position currentLocation = await Geolocator.getCurrentPosition().then((value) => value);
      Data.lat = currentLocation.latitude;
      Data.lng = currentLocation.longitude;
      print("=========================================");
      print("Lat: ${Data.lat}");
      print("Lng: ${Data.lng}");
      print("=========================================");
    }
  }

  @override
  void initState() {
    if (Data.currentIndex == 2) {
      title.text = "${Data.DetailesRE[0]['Title']}";

      Nr = (Data.DetailesRE[0]['NBedRooms']).toDouble();
      NBr = (Data.DetailesRE[0]['NBathRooms']).toDouble();
      Nk = (Data.DetailesRE[0]['NKitchens']).toDouble();
      Ns = (Data.DetailesRE[0]['NLivingRooms']).toDouble();

      price.text = "${Data.DetailesRE[0]['Price']}";
      area.text = "${Data.DetailesRE[0]['Space']}";

      Datselected = "${Data.DetailesRE[0]['Governorate']}";
      Data.lat = Data.DetailesRE[0]['Lat'];
      Data.lng = Data.DetailesRE[0]['Lng'];

      ct = "${Data.DetailesRE[0]['RealEstateType']}";
      Description.text = "${Data.DetailesRE[0]['Description']}";
    }
    if (Data.currentIndex == 3) {
      Data.isDragable = true;
      getLocation();
    }

    super.initState();
  }
///////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: snakBar,
      appBar: AppBar(
        leading: Data.currentIndex == 3 ? const Icon(Icons.add) : const BackButton(),
        title: Text(Data.currentIndex == 3 ? 'Add Property' : 'Edit Property'),
        actions: [
          InkWell(
            child: CircleAvatar(
              radius: 20,
              backgroundImage: Data.userInfo.isNotEmpty ? NetworkImage("${Data.imgPath}${Data.userInfo[0]['ImgProfileName']}") : NetworkImage("${Data.imgPath}user.png"),
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
                  animType: AnimType.scale,
                  btnOkColor: Colors.brown,
                  title: 'Are you sure ?',
                  desc: 'Are you sure you want to logout?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    setState(() {
                      Data.isLogin = false;
                      Data.checkprefs = false;
                      Data.loginOut = const Icon(Icons.login);
                      Data.userInfo.clear();
                      Data.FinalFavorite.clear();
                      Data.FinalUserRealEstate.clear();
                    });
                  },
                ).show();
              } else {
                Navigator.of(context).pushNamed("login");
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).pushNamed("filtering");
            },
          ),
        ],
      ),
      body: !Data.isLogin
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("You have to \n", style: TextStyle(fontSize: 20)),
                  InkWell(
                    child: const Text("Login", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).pushNamed("login");
                    },
                  ),
                  const Text("\n to add you'r real estate", style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          : Column(
              children: [
                Form(
                    key: _formKey,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 30),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(Data.currentIndex == 3 ? "Add New Property" : "Edit New Property", style: const TextStyle(fontFamily: 'Crete Round', color: Colors.brown, fontSize: 40))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child:
                                  Align(alignment: Alignment.topLeft, child: Text(Data.currentIndex == 3 ? "ADD DETAILS" : "EDIT DETAILS", style: const TextStyle(color: Colors.grey, fontSize: 18))),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Align(alignment: Alignment.topLeft, child: Text("Title:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the Tilte';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Title',
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                        width: 2,
                                      ),
                                    )),
                                controller: title,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 16.0,
                                bottom: 12,
                                top: 8,
                              ),
                              child: Align(alignment: Alignment.topLeft, child: Text("Number of Bedrooms:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: SpinBox(
                                  decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                          width: 2,
                                        ),
                                      )),
                                  min: 1,
                                  value: double.parse(Nr.toString()),
                                  onChanged: (value) {
                                    setState(() {
                                      Nr = value;
                                    });
                                  }),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 16.0,
                                bottom: 12,
                                top: 12,
                              ),
                              child: Align(alignment: Alignment.topLeft, child: Text("Number of Bathrooms:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: SpinBox(
                                  decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                          width: 2,
                                        ),
                                      )),
                                  min: 1,
                                  value: NBr,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        NBr = value;
                                      },
                                    );
                                  }),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 16.0,
                                bottom: 12,
                                top: 12,
                              ),
                              child: Align(alignment: Alignment.topLeft, child: Text("Number of Kitchens:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: SpinBox(
                                  decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                          width: 2,
                                        ),
                                      )),
                                  min: 1,
                                  value: Nk,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        Nk = value;
                                      },
                                    );
                                  }),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 16.0,
                                bottom: 12,
                                top: 12,
                              ),
                              child: Align(alignment: Alignment.topLeft, child: Text("Number of Living rooms:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: SpinBox(
                                  decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                          width: 2,
                                        ),
                                      )),
                                  min: 1,
                                  value: Ns,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        Ns = value;
                                      },
                                    );
                                  }),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 16),
                              child: Align(alignment: Alignment.topLeft, child: Text("Price:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the propety price  ';
                                  } else if (isAlpha(value)) {
                                    return 'Only Numbers Please';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Price',
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                        width: 2,
                                      ),
                                    )),
                                controller: price,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 8),
                              child: Align(alignment: Alignment.topLeft, child: Text("Area:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the propety area  ';
                                  } else if (isAlpha(value)) {
                                    return 'Only Numbers Please';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Area',
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.brown,
                                        width: 2,
                                      ),
                                    )),
                                controller: area,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 8),
                              child: Align(alignment: Alignment.topLeft, child: Text("City:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.brown,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                isExpanded: true,
                                value: Datselected,
                                items: [
                                  "Irbid",
                                  "Ajloun",
                                  "Jerash",
                                  "Mafraq",
                                  "Balqa",
                                  "Amman",
                                  "Zarqa",
                                  "Madaba",
                                  "Karak",
                                  "Tafilah",
                                  "Ma'an",
                                  "Aqaba",
                                ]
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    Datselected = val.toString();
                                  });
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 8),
                              child: Align(alignment: Alignment.topLeft, child: Text("Property type:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.brown,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                isExpanded: true,
                                value: ct,
                                items: [
                                  "For Sale",
                                  "For Rent",
                                ]
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    ct = val.toString();
                                    print("ct: $ct");
                                  });
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 8),
                              child: Align(alignment: Alignment.topLeft, child: Text("Description:", style: TextStyle(fontSize: 22))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the property description';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Description',
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.brown,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.brown,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                controller: Description,
                                maxLines: 4,
                              ),
                            ),
//////////////////////////////////////////////////////////////////////////////////////////////START
                            InkWell(
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image),
                                  Text(
                                    "Select Images",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                await _openFileExplorer();
                              },
                            ),
                            sizeBox(),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.place_outlined),
                              label: const Text("Select Location"),
                              onPressed: () async {
                                Navigator.of(context).pushNamed("map");
                              },
                            ),
//////////////////////////////////////////////////////////////////////////////////////////////////END
                            Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 30),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      width: 350,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all<Color>(Colors.brown),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
//////////////////////////////////////////////////////////////////////////////////////////////////START

                                            print('Add complete');
                                            print("Title: ${title.text}");
                                            print("nbedrooms: $Nr");
                                            print("nbathrooms: $NBr");
                                            print("nkitchens: $Nk");
                                            print("nlivingrooms: $Ns");
                                            print("price: ${price.text}");
                                            print("space: ${area.text}");
                                            print("governorate: $Datselected");
                                            print("realestatetype: $ct");
                                            print("description: ${Description.text}");
                                            print("publisherid: ${Data.userInfo[0]['UID']}");
                                            print("ct: $ct");
                                            print("Lat: ${Data.lat}");
                                            print("Lng: ${Data.lng}");
                                            if (Data.currentIndex == 3) {
                                              await AddRealEstate();
                                            } else {
                                              await EditRealEstate();
                                            }
                                            var Bar = SnackBar(
                                              content: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  const Icon(Icons.done),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      Data.currentIndex == 3 ? "The Real estate added" : "The Real estate edited",
                                                      style: const TextStyle(fontSize: 15, color: Colors.brown),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: Colors.white,
                                              duration: const Duration(seconds: 3),
                                            );
                                            //snakBar.currentState!.showSnackBar((Bar));
                                            ScaffoldMessenger.of(context).showSnackBar(Bar);

//////////////////////////////////////////////////////////////////////////////////////////////////END
                                          }
                                        },
                                        child: Text(
                                          Data.currentIndex == 3 ? 'Add' : 'Edit',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    )))
                          ],
                        ),
                      ),
                    ))
              ],
            ),
    );
  }

  Widget sizeBox() {
    if (Data.currentIndex == 3) {
      return SizedBox(
        height: 150,
        width: double.infinity,
        child: _files!.isEmpty
            ? const Center(
                child: Text(
                  "No Images selected",
                  style: TextStyle(fontSize: 15),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _files!.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.network("${Data.imgPath}${_files![i].name}"),
                  );
                },
              ),
      );
    } else {
      return SizedBox(
        height: 150,
        width: double.infinity,
        child: Data.Images.isEmpty
            ? const Center(child: Text("No Images selected"))
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Data.Images.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Data.Images[i],
                  );
                },
              ),
      );
    }
  }
}
