import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tumbadi_app/Directory.dart';
import 'package:tumbadi_app/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Config.dart';

class ScrollingNotice extends StatefulWidget {
  const ScrollingNotice({super.key});

  @override
  State<ScrollingNotice> createState() => _ScrollingNoticeState();
}

class _ScrollingNoticeState extends State<ScrollingNotice> {
  //NoticeList ls = new NoticeList();

  List<Container> birthdaylist = [];
  List<Container> aniversarylist = [];
  List<Container> punytithi = [];

  void noticeData() async {
    //String url = Config.notice_list;
    String url = Config.noticetab;
    var res = await http.get(Uri.parse(url));
    var data = json.decode(res.body);
    List ls = data['data']['birthday'];
    List aniLs = data['data']['aniversary'];
    List punyLs = data['data']['punytithi'];
    setState(() {
      //print(widget.noticels);
      birthdaylist = [
        for (var item in ls)
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  minRadius: 30,
                  backgroundImage: NetworkImage(
                      "https://kutchvadala.org/uploads/users/default.png"),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item['title'].toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      item['type'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 173, 18, 7),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            height: 60,
            //width: MediaQuery.of().size.width,
            margin: EdgeInsets.only(bottom: 6, right: 8),
            decoration: BoxDecoration(
                //color: Color.fromARGB(255, 132, 236, 205),
                border: Border.all(
                    color: Color.fromARGB(255, 173, 18, 7),
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
      ];

      aniversarylist = [
        for (var item in aniLs)
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  minRadius: 30,
                  backgroundImage: NetworkImage(
                      "https://kutchvadala.org/uploads/users/default.png"),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      item['type'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 173, 18, 7),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            height: 60,
            //width: MediaQuery.of().size.width,
            margin: EdgeInsets.only(bottom: 3, right: 3),
            decoration: BoxDecoration(
                //color: Colors.grey[200],
                border: Border.all(
                    color: Color.fromARGB(255, 173, 18, 7),
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
      ];

      punytithi = [
        for (var item in punyLs)
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  minRadius: 30,
                  backgroundImage: NetworkImage(
                      "https://kutchvadala.org/uploads/users/default.png"),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      item['type'],
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 7, 120, 212),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                )
              ],
            ),
            height: 60,
            margin: EdgeInsets.only(bottom: 3, right: 3),
            //width: MediaQuery.of().size.width,
            decoration: BoxDecoration(
                //color: Colors.grey[200],
                border: Border.all(
                    color: Colors.brown, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
      ];
    });
  }

  @override
  void initState() {
    //print(widget.noticels);
    noticeData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 40;
    double cwidth = width / 3;

    return Column(
      children: [
        birthdaylist.length > 0
            ? Container(
                height: 100,
                padding: EdgeInsets.all(6),
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                    ),
                    items: birthdaylist),
              )
            : SizedBox(
                height: 1,
              ),
        aniversarylist.length > 0
            ? Container(
                height: 100,
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                    ),
                    items: aniversarylist),
              )
            : SizedBox(
                height: 1,
              ),
        punytithi.length > 0
            ? Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                    ),
                    items: punytithi),
              )
            : SizedBox(
                height: 10,
              ),
      ],
    );
  }
}
