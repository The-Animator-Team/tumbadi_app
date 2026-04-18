import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/B2badd.dart';
import 'package:tumbadi_app/B2bdetail.dart';
import 'package:tumbadi_app/Config.dart';
import 'package:tumbadi_app/Jobadd.dart';
import 'package:tumbadi_app/MatriDetail.dart';
import 'package:tumbadi_app/MatrimonialAdd.dart';
import 'package:tumbadi_app/widget/FancyLoader.dart';

class Matrimonial extends StatefulWidget {
  const Matrimonial({super.key});

  @override
  State<Matrimonial> createState() => _MatrimonialState();
}

class _MatrimonialState extends State<Matrimonial> {
  Future MatriList() async {
    var res = await http.get(Uri.parse(Config.matri_list));
    var data = json.decode(res.body);
    var reuslt = data['data'];
    //print(reuslt);
    return reuslt;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Matrimonial")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MatrimonialAdd()),
          );
        },
        child: Icon(FontAwesomeIcons.plus),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: MatriList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: FancyLoader(
                  label: 'Loading matches',
                  subtitle: 'Collecting the latest matrimonial profiles.',
                  icon: Icons.favorite_rounded,
                ),
              );
            }

            final List mdata = snapshot.data as List? ?? [];

            return ListView.builder(
              itemCount: mdata.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MatriDetail(matrdetail: mdata[index]);
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 90,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 173, 18, 7),
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Image(
                          image:
                              mdata[index]['img_type'] != null
                                  ? NetworkImage(
                                    "https://kutchvadala.org/uploads/users/" +
                                        mdata[index]['user_id'] +
                                        "." +
                                        mdata[index]['img_type'],
                                  )
                                  : NetworkImage(
                                    "https://kutchvadala.org/uploads/users/default.png",
                                  ),
                          width: 100,
                        ),
                        SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Name :" + mdata[index]['first_name']),
                            Text("Aeg :" + mdata[index]['age']),
                            Text("Education :" + mdata[index]['education']),
                          ],
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
