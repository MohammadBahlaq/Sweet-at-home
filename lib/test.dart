import 'package:aqar_detailes/data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
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
    }
    setState(() {});

    print('Loaded file Name is : ${_files!.length}');
  }

  void TestList(List s) {
    print("List length : ${s.length}");
    print("List 1 : $s");
    for (int i = 0; i < s.length; i++) {
      s[i] = s[i] + 1;
    }
    print("List 2 : $s");
  }

  void TestVar(var i) {
    print("var 1 : $i");
    i += 2;
    print("var 2 : $i");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  //await _openFileExplorer();

                  List m = [1, 2, 3, 4];
                  TestList(m);
                  print("List 3m : $m");

                  List b = [1, 2, 3, 4, 5];
                  D.TestList(b);
                  print("List 3b : $b");

                  // var x = 5;
                  // TestVar(x);
                  // print("var 3 : $x");
                },
                child: const Text("Select Images"),
              ),
              SizedBox(
                height: 150,
                width: double.infinity,
                child: _files!.isEmpty
                    ? const Center(child: Text("No Images selected"))
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
              ),
              const TabBar(
                labelColor: Colors.yellow,
                indicatorColor: Colors.green,
                tabs: [
                  Tab(
                    child: Text("Tab1"),
                  ),
                  Tab(child: Text("Tab2")),
                  Tab(child: Text("Tab3")),
                ],
              ),
              SizedBox(
                height: 433.25,
                width: double.infinity,
                child: TabBarView(
                  children: [
                    Container(
                      color: Colors.red,
                      child: const Text("One"),
                    ),
                    Container(
                      color: Colors.green,
                      child: const Text("One"),
                    ),
                    Container(
                      color: Colors.blue,
                      child: const Text("One"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class D {
  static void TestList(List s) {
    print("List length : ${s.length}");
    print("List 1 : $s");
    for (int i = 0; i < s.length; i++) {
      s[i] = s[i] + 1;
    }
    print("List 2 : $s");
  }
}
