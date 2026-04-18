import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tumbadi_app/Config.dart';
import 'package:tumbadi_app/FamilyAdd.dart';
import 'package:tumbadi_app/Profile.dart';
import 'package:tumbadi_app/StyleData.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/widget/FancyLoader.dart';

class Family extends StatefulWidget {
  final String user_id;
  final String familiy_id;

  const Family({Key? key, required this.user_id, required this.familiy_id})
    : super(key: key);

  @override
  State<Family> createState() => _FamilyState();
}

class _FamilyState extends State<Family> {
  Future<List> myFamily() async {
    String url = Config.familylist + "/" + widget.familiy_id;
    var res = await http.get(Uri.parse(url));
    var data = json.decode(res.body);
    List familyData = [];
    familyData = data['data'];
    return familyData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Family")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FamilyAdd();
              },
            ),
          ).then((value) {
            setState(() {});
          });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: myFamily(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: FancyLoader(
                  label: 'Loading family',
                  subtitle: 'Gathering linked members for this profile.',
                  icon: Icons.family_restroom_rounded,
                ),
              );
            }
            final List data = snapshot.data as List? ?? [];
            return ListView.builder(
              itemCount: data == null ? 0 : data.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.amber[200],
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 6.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Profile(user_id: data[index]['user_id']);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(Config.noimage),
                            radius: 25,
                          ),
                          SizedBox(width: 10),
                          Container(
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['name'].toString(),
                                  style: StyleData.textstyle,
                                ),
                                Text(data[index]['relation'].toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
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
