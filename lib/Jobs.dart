import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/B2badd.dart';
import 'package:tumbadi_app/B2bdetail.dart';
import 'package:tumbadi_app/Config.dart';
import 'package:tumbadi_app/Jobadd.dart';
import 'package:tumbadi_app/widget/FancyLoader.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  Future JobList() async {
    var res = await http.get(Uri.parse(Config.job_list));
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
      appBar: AppBar(title: Text("Jobs")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Jobadd()),
          );
        },
        child: Icon(FontAwesomeIcons.plus),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: JobList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: FancyLoader(
                  label: 'Loading jobs',
                  subtitle: 'Pulling the latest openings now.',
                  icon: Icons.work_outline_rounded,
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
                          return B2bDetail(b2bdata: mdata[index]);
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
                              mdata[index]['logo'] != null
                                  ? NetworkImage(mdata[index]['logo'])
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
                            Text(
                              "Company Name :" + mdata[index]['company_name'],
                            ),
                            Text("Designation :" + mdata[index]['designation']),
                            Text("No of Post :" + mdata[index]['openings']),
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
