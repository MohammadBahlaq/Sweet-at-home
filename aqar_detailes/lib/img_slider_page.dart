import 'package:aqar_detailes/data.dart';
import 'package:flutter/material.dart';

class ImgSlider extends StatefulWidget {
  const ImgSlider({Key? key}) : super(key: key);

  @override
  State<ImgSlider> createState() => _ImgSliderState();
}

class _ImgSliderState extends State<ImgSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: PageView.builder(
          itemCount: Data.Images.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Data.ImagesSlider[i],
            );
          },
        ),
      ),
    );
  }
}
