import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Config.dart';

class MatriDetail extends StatefulWidget {
  final matrdetail;
  const MatriDetail({super.key, required this.matrdetail});

  @override
  State<MatriDetail> createState() => _MatriDetailState();
}

class _MatriDetailState extends State<MatriDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.matrdetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              child: Image(
                image: widget.matrdetail['img_type'] != null
                    ? NetworkImage("https://kutchvadala.org/uploads/users/" +
                        widget.matrdetail['user_id'] +
                        "." +
                        widget.matrdetail['img_type'])
                    : NetworkImage(
                        "https://kutchvadala.org/uploads/users/default.png"),
                height: 200,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.matrdetail['first_name'].toString() +
                  " " +
                  widget.matrdetail['middle_name'].toString() +
                  " " +
                  widget.matrdetail['sur_name'].toString(),
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Height: " +
                  widget.matrdetail['height'].toString() +
                  "     Weight: " +
                  widget.matrdetail['weight'].toString(),
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Birth Date",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.matrdetail['birth_date'].toString() +
                  " " +
                  widget.matrdetail['birth_time'].toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Mother Name",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.matrdetail['mother_name'].toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Birth Place",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.matrdetail['birth_place'].toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Education",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.matrdetail['education'].toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Occupation",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.matrdetail['occupation'].toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Nana Nini's Village",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.matrdetail['nani_village'].toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Contact No.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.matrdetail['contact_number'].toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
