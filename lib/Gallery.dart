import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Config.dart';
import 'GalleryWidget.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  var transformedImages = [];

  Future getImages() async {
    String url = Config.gallery;
    var res = await http.get(Uri.parse(url));
    var data = json.decode(res.body);
    setState(() {
      transformedImages = data['data'];
      print(transformedImages);
    });
  }

  @override
  void initState() {
    getImages();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Gallery"),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(color: Colors.white),
            child: GridView.builder(
                itemCount: transformedImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return RawMaterialButton(
                    child: InkWell(
                      child: Ink.image(
                        image: NetworkImage(
                            "http://kutchvadala.org/uploads/cms/" +
                                transformedImages[index]['image_1']),
                        fit: BoxFit.fill,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GalleryWidget(
                                    urlImages: transformedImages,
                                    index: index,
                                  )));
                    },
                  );
                }),
          ))
        ],
      )),
    );
  }
}
