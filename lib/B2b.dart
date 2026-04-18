import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/B2badd.dart';
import 'package:tumbadi_app/B2bdetail.dart';
import 'package:tumbadi_app/Config.dart';
import 'package:tumbadi_app/widget/FancyLoader.dart';

class B2b extends StatefulWidget {
  final String apiurl;
  const B2b({required this.apiurl, super.key});

  @override
  State<B2b> createState() => _B2bState();
}

class _B2bState extends State<B2b> {
  bool b2bSearch = false;

  Future b2bList() async {
    List b2bdata = [];
    if (b2bSearch == true) {
      b2bSearch = false;
    } else {
      var res = await http.get(Uri.parse(widget.apiurl));
      var data = json.decode(res.body);
      var result = data['topics'];
      b2bdata = result;
    }

    //print(reuslt);
    return b2bdata;
  }

  void advancSearch() {
    setState(() {
      b2bSearch = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("B2B"),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Search"),
                    scrollable: true,
                    content: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            label: Text("Contegory"),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            label: Text("Business Name"),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            label: Text("Location"),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        CupertinoButton(
                          color: Colors.blue,
                          child: Text("Search"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.search_sharp),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => B2badd()),
          );
        },
        child: Icon(FontAwesomeIcons.plus),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: b2bList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: FancyLoader(
                  label: 'Loading businesses',
                  subtitle: 'Finding nearby listings for you.',
                  icon: Icons.storefront_rounded,
                ),
              );
            }

            final List mdata = snapshot.data as List? ?? [];

            return GridView.builder(
              itemCount: mdata.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4, // Adjust as needed
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) {
                    //     return B2bDetail(b2bdata: mdata[index]);
                    //   },
                    // ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            mdata[index]['photo_file'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          mdata[index]['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
