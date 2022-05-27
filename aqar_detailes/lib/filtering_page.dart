// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_new, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:aqar_detailes/data.dart';

class Filtering extends StatefulWidget {
  const Filtering({Key? key}) : super(key: key);

  @override
  State<Filtering> createState() => _FilteringState();
}

class _FilteringState extends State<Filtering> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  GlobalKey<FormState> formstate2 = new GlobalKey<FormState>();

  //Sale Rent colors
  List<Color> colorSaleRent = [Colors.brown, Colors.grey];
  //Bedrooms colors
  List<Color> colorBedRooms = [
    Colors.brown,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];

  //Bathrooms colors
  List<Color> colorBathRooms = [
    Colors.brown,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];

  //Kitchen colors
  List<Color> colorKitchens = [
    Colors.brown,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];

  //LivingRoom colors
  List<Color> colorLivingRooms = [
    Colors.brown,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];

  @override
  void initState() {
    //Sale,Rent Switch
    switch (Data.realEstateType) {
      case "For Sale":
        colorSaleRent[0] = Colors.brown;
        colorSaleRent[1] = Colors.grey;
        break;
      case "For Rent":
        colorSaleRent[1] = Colors.brown;
        colorSaleRent[0] = Colors.grey;
        break;
    }
    initValue("BedRooms");
    initValue("BathRooms");
    initValue("Kitchens");
    initValue("LivingRooms");
    super.initState();
  }

  void initValue(String btnName) {
    switch (btnName) {
      case "BedRooms":
        if (Data.nBedRooms[0] == 1 &&
            Data.nBedRooms[1] == 2 &&
            Data.nBedRooms[2] == 3 &&
            Data.nBedRooms[3] == 4) {
          changeAllColorGrey("BedRooms");
        } else {
          colorBedRooms[0] = Colors.grey;
          if (Data.nBedRooms[0] == 1) {
            colorBedRooms[1] = Colors.brown;
          }
          if (Data.nBedRooms[1] == 2) {
            colorBedRooms[2] = Colors.brown;
          }
          if (Data.nBedRooms[2] == 3) {
            colorBedRooms[3] = Colors.brown;
          }
          if (Data.nBedRooms[3] == 4) {
            colorBedRooms[4] = Colors.brown;
          }
        }
        break;
      case "BathRooms":
        if (Data.nBathRooms[0] == 1 &&
            Data.nBathRooms[1] == 2 &&
            Data.nBathRooms[2] == 3) {
          changeAllColorGrey("BathRooms");
        } else {
          colorBathRooms[0] = Colors.grey;
          if (Data.nBathRooms[0] == 1) {
            colorBathRooms[1] = Colors.brown;
          }
          if (Data.nBathRooms[1] == 2) {
            colorBathRooms[2] = Colors.brown;
          }
          if (Data.nBathRooms[2] == 3) {
            colorBathRooms[3] = Colors.brown;
          }
        }
        break;
      case "Kitchens":
        if (Data.nKitchens[0] == 1 &&
            Data.nKitchens[1] == 2 &&
            Data.nKitchens[2] == 3) {
          changeAllColorGrey("Kitchens");
        } else {
          colorKitchens[0] = Colors.grey;
          if (Data.nKitchens[0] == 1) {
            colorKitchens[1] = Colors.brown;
          }
          if (Data.nKitchens[1] == 2) {
            colorKitchens[2] = Colors.brown;
          }
          if (Data.nKitchens[2] == 3) {
            colorKitchens[3] = Colors.brown;
          }
        }
        break;
      case "LivingRooms":
        if (Data.nLivingRooms[0] == 1 &&
            Data.nLivingRooms[1] == 2 &&
            Data.nLivingRooms[2] == 3 &&
            Data.nLivingRooms[3] == 4) {
          changeAllColorGrey("LivingRooms");
        } else {
          colorLivingRooms[0] = Colors.grey;
          if (Data.nLivingRooms[0] == 1) {
            colorLivingRooms[1] = Colors.brown;
          }
          if (Data.nLivingRooms[1] == 2) {
            colorLivingRooms[2] = Colors.brown;
          }
          if (Data.nLivingRooms[2] == 3) {
            colorLivingRooms[3] = Colors.brown;
          }
          if (Data.nLivingRooms[3] == 4) {
            colorLivingRooms[4] = Colors.brown;
          }
        }
        break;
    }
  }

  bool isNumber(String num) {
    for (int i = 0; i < num.length; i++) {
      if (num[i] == "-" || num[i] == " " || num[i] == "," || num[i] == ".") {
        return false;
      }
    }
    return true;
  }

  void notClickAll(String btnName) {
    switch (btnName) {
      case "BedRooms":
        for (int i = 0; i < Data.nBedRooms.length; i++) {
          i != 3 ? Data.nBedRooms[i] = 0 : Data.nBedRooms[i] = 9999;
          print("BedRooms: ${Data.nBedRooms}");
        }
        break;
      case "BathRooms":
        for (int i = 0; i < Data.nBathRooms.length; i++) {
          i != 2 ? Data.nBathRooms[i] = 0 : Data.nBathRooms[i] = 9999;
          print("BathRooms: ${Data.nBathRooms}");
        }
        break;
      case "Kitchens":
        for (int i = 0; i < Data.nKitchens.length; i++) {
          i != 2 ? Data.nKitchens[i] = 0 : Data.nKitchens[i] = 9999;
          print("Kitchens: ${Data.nKitchens}");
        }
        break;
      case "LivingRooms":
        for (int i = 0; i < Data.nLivingRooms.length; i++) {
          i != 3 ? Data.nLivingRooms[i] = 0 : Data.nLivingRooms[i] = 9999;
          print("LivingRooms: ${Data.nLivingRooms}");
        }
        break;
    }
  }

  void clickAll(String btnName) {
    switch (btnName) {
      case "BedRooms":
        for (int i = 0; i < Data.nBedRooms.length; i++) {
          Data.nBedRooms[i] = i + 1;
          print("BedRooms: ${Data.nBedRooms}");
        }
        break;
      case "BathRooms":
        for (int i = 0; i < Data.nBathRooms.length; i++) {
          Data.nBathRooms[i] = i + 1;
          print("BathRooms: ${Data.nBathRooms}");
        }
        break;
      case "Kitchens":
        for (int i = 0; i < Data.nKitchens.length; i++) {
          Data.nKitchens[i] = i + 1;
          print("Kitchens: ${Data.nKitchens}");
        }
        break;
      case "LivingRooms":
        for (int i = 0; i < Data.nLivingRooms.length; i++) {
          Data.nLivingRooms[i] = i + 1;
          print("LivingRooms: ${Data.nLivingRooms}");
        }
        break;
    }
  }

  void changeAllColorGrey(String btnName) {
    switch (btnName) {
      case "BedRooms":
        for (int i = 1; i < colorBedRooms.length; i++) {
          colorBedRooms[i] = Colors.grey;
        }
        break;
      case "BathRooms":
        for (int i = 1; i < colorBathRooms.length; i++) {
          colorBathRooms[i] = Colors.grey;
        }
        break;
      case "Kitchens":
        for (int i = 1; i < colorKitchens.length; i++) {
          colorKitchens[i] = Colors.grey;
        }
        break;
      case "LivingRooms":
        for (int i = 1; i < colorLivingRooms.length; i++) {
          colorLivingRooms[i] = Colors.grey;
        }
        break;
    }
  }

  void anyBtnExceptAll(String btnName) {
    switch (btnName) {
      case "BedRooms":
        if (colorBedRooms[0] == Colors.brown) {
          colorBedRooms[0] = Colors.grey;
          notClickAll(btnName);
        }
        break;
      case "BathRooms":
        if (colorBathRooms[0] == Colors.brown) {
          colorBathRooms[0] = Colors.grey;
          notClickAll(btnName);
        }
        break;
      case "Kitchens":
        if (colorKitchens[0] == Colors.brown) {
          colorKitchens[0] = Colors.grey;
          notClickAll(btnName);
        }
        break;
      case "LivingRooms":
        if (colorLivingRooms[0] == Colors.brown) {
          colorLivingRooms[0] = Colors.grey;
          notClickAll(btnName);
        }
        break;
    }
  }

  void colorButton(String btnName, int index) {
    switch (btnName) {
      case "BedRooms":
        if (colorBedRooms[index] == Colors.grey) {
          index != 0 ? anyBtnExceptAll(btnName) : changeAllColorGrey(btnName);

          index != 0 ? Data.nBedRooms[index - 1] = index : clickAll(btnName);
          colorBedRooms[index] = Colors.brown;

          print(Data.nBedRooms);
        } else {
          index != 0 ? Data.nBedRooms[index - 1] = 0 : notClickAll(btnName);
          if (index == 4) {
            Data.nBedRooms[index - 1] = 9999;
          }

          colorBedRooms[index] = Colors.grey;

          print(Data.nBedRooms);
        }
        break;
      case "BathRooms":
        if (colorBathRooms[index] == Colors.grey) {
          index != 0 ? anyBtnExceptAll(btnName) : changeAllColorGrey(btnName);

          index != 0 ? Data.nBathRooms[index - 1] = index : clickAll(btnName);
          colorBathRooms[index] = Colors.brown;

          print(Data.nBathRooms);
        } else {
          index != 0 ? Data.nBathRooms[index - 1] = 0 : notClickAll(btnName);
          if (index == 3) {
            Data.nBathRooms[index - 1] = 9999;
          }

          colorBathRooms[index] = Colors.grey;

          print(Data.nBathRooms);
        }
        break;
      case "Kitchens":
        if (colorKitchens[index] == Colors.grey) {
          index != 0 ? anyBtnExceptAll(btnName) : changeAllColorGrey(btnName);

          index != 0 ? Data.nKitchens[index - 1] = index : clickAll(btnName);

          colorKitchens[index] = Colors.brown;

          print(Data.nKitchens);
        } else {
          index != 0 ? Data.nKitchens[index - 1] = 0 : notClickAll(btnName);
          if (index == 3) {
            Data.nKitchens[index - 1] = 9999;
          }

          colorKitchens[index] = Colors.grey;

          print(Data.nKitchens);
        }
        break;
      case "LivingRooms":
        if (colorLivingRooms[index] == Colors.grey) {
          index != 0 ? anyBtnExceptAll(btnName) : changeAllColorGrey(btnName);

          index != 0 ? Data.nLivingRooms[index - 1] = index : clickAll(btnName);
          colorLivingRooms[index] = Colors.brown;

          print(Data.nLivingRooms);
        } else {
          index != 0 ? Data.nLivingRooms[index - 1] = 0 : notClickAll(btnName);
          if (index == 4) {
            Data.nLivingRooms[index - 1] = 9999;
          }

          colorLivingRooms[index] = Colors.grey;

          print(Data.nLivingRooms);
        }
        break;
    }
  }

  ElevatedButton ElevatedButtonCreat(String name, int index, String type) {
    switch (type) {
      case "BedRooms":
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorBedRooms[index], //index
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(name), //name
          onPressed: () {
            setState(() {
              colorButton(type, index); //type,index
            });
          },
        );
      case "BathRooms":
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorBathRooms[index], //index
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(name), //name
          onPressed: () {
            setState(() {
              colorButton(type, index); //type,index
            });
          },
        );
      case "Kitchens":
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorKitchens[index], //index
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(name), //name
          onPressed: () {
            setState(() {
              colorButton(type, index); //type,index
            });
          },
        );
      case "LivingRooms":
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorLivingRooms[index], //index
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(name), //name
          onPressed: () {
            setState(() {
              colorButton(type, index); //type,index
            });
          },
        );
      default:
        return ElevatedButton(onPressed: () {}, child: Text(""));
    }
  }

  ElevatedButton btnSaleRentCreate(int index1, index2, String type1, type2) {
    //
    return ElevatedButton(
      child: Text(type1),
      style: ElevatedButton.styleFrom(
        primary: colorSaleRent[index1],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {
        setState(() {
          if (colorSaleRent[index1] == Colors.grey) {
            colorSaleRent[index1] = Colors.brown;
            colorSaleRent[index2] = Colors.grey;
            Data.realEstateType = type1;
            print(Data.realEstateType);
          } else {
            colorSaleRent[index1] = Colors.grey;
            colorSaleRent[index2] = Colors.brown;
            Data.realEstateType = type2;
            print(Data.realEstateType);
          }
        });
      },
    );
  }

  Expanded TextFiledCreate(String fromTo, priceSpace) {
    return Expanded(
      child: TextFormField(
        maxLength: 18,
        decoration: InputDecoration(
          labelText: fromTo,
          filled: true,
          fillColor: Colors.grey[300],
        ),
        keyboardType: TextInputType.number,
        validator: (text) {
          if (isNumber(text!)) {
            return null;
          }
          return "Pleas Enter just numbers";
        },
        onSaved: (text) {
          switch (fromTo + " " + priceSpace) {
            case "From Price":
              if (text!.isNotEmpty) {
                Data.minPrice = int.parse(text);
                print("Min price = ${Data.minPrice}");
              } else {
                Data.minPrice = 0;
                print("Min price = ${Data.minPrice}");
              }
              break;
            case "To Price":
              if (text!.isNotEmpty) {
                Data.maxPrice = int.parse(text);
                print("Max price = ${Data.maxPrice}");
              } else {
                Data.maxPrice = 999999999999999999;
                print("Max price = ${Data.maxPrice}");
              }
              break;
            case "From Space":
              if (text!.isNotEmpty) {
                Data.minSpace = int.parse(text);
                print("Min space: ${Data.minSpace}");
              } else {
                Data.minSpace = 0;
                print("Min space: ${Data.minSpace}");
              }
              break;
            case "To Space":
              if (text!.isNotEmpty) {
                Data.maxSpace = int.parse(text);
                print("Max Space = ${Data.maxSpace}");
              } else {
                Data.maxSpace = 999999999999999999;
                print("Max Space = ${Data.maxSpace}");
              }
              break;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Filtering"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text("Select Governorate",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          DropdownButton(
            isExpanded: true,
            value: Data.selected,
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
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                Data.selected = val.toString();
              });
              print(Data.selected);
            },
          ),
          Divider(height: 25),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Realestate type",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Wrap(
            children: [
              btnSaleRentCreate(0, 1, "For Sale", "For Rent"),
              SizedBox(width: 5),
              btnSaleRentCreate(1, 0, "For Rent", "For Sale"),
            ],
          ),
          Divider(height: 25),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Number of Bedrooms",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Wrap(
            children: [
              ElevatedButtonCreat("All", 0, "BedRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("One Bedroom", 1, "BedRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("2 Bedrooms", 2, "BedRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("3 Bedrooms", 3, "BedRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("+4 Bedrooms", 4, "BedRooms"),
            ],
          ),
          Divider(height: 25),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Number of Bathrooms",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Wrap(
            children: [
              ElevatedButtonCreat("All", 0, "BathRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("One Bathroom", 1, "BathRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("2 Bathrooms", 2, "BathRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("+3 Bathrooms", 3, "BathRooms"),
            ],
          ),
          Divider(height: 25),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Number of Kitchens",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Wrap(
            children: [
              ElevatedButtonCreat("All", 0, "Kitchens"),
              SizedBox(width: 5),
              ElevatedButtonCreat("One Kitchen", 1, "Kitchens"),
              SizedBox(width: 5),
              ElevatedButtonCreat("2 Kitchens", 2, "Kitchens"),
              SizedBox(width: 5),
              ElevatedButtonCreat("+3 Kitchens", 3, "Kitchens"),
            ],
          ),
          Divider(height: 25),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Number of Livingrooms",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Wrap(
            children: [
              ElevatedButtonCreat("All", 0, "LivingRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("One Livingrooms", 1, "LivingRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("2 Livingrooms", 2, "LivingRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("3 Livingrooms", 3, "LivingRooms"),
              SizedBox(width: 5),
              ElevatedButtonCreat("+4 Livingrooms", 4, "LivingRooms"),
            ],
          ),
          Divider(height: 25),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Price",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Form(
            key: formstate,
            autovalidateMode: AutovalidateMode.always,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFiledCreate("From", "Price"),
                Text(
                  " - ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                TextFiledCreate("To", "Price"),
              ],
            ),
          ),
          Divider(height: 25),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Space",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Form(
            key: formstate2,
            autovalidateMode: AutovalidateMode.always,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFiledCreate("From", "Space"),
                Text(
                  " - ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                TextFiledCreate("To", "Space"),
              ],
            ),
          ),
          Divider(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10),
              textStyle: TextStyle(
                fontSize: 25,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text("Search"),
            onPressed: () {
              setState(() {
                if (formstate2.currentState!.validate() &&
                    formstate.currentState!.validate()) {
                  formstate2.currentState!.save();
                  formstate.currentState!.save();
                  Data.currentIndex = 0;
                  Navigator.of(context).pushReplacementNamed("bottomBar");
                } else {
                  print("There is error");
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
