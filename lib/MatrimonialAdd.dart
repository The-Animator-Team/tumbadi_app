import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Config.dart';

class MatrimonialAdd extends StatefulWidget {
  const MatrimonialAdd({super.key});

  @override
  State<MatrimonialAdd> createState() => _MatrimonialAddState();
}

class _MatrimonialAddState extends State<MatrimonialAdd> {
  File? _logo;
  List list = [];
  //TextEditingController _member = TextEditingController();
  SingleValueDropDownController _member = SingleValueDropDownController();
  TextEditingController _education = TextEditingController();
  TextEditingController _occupation = TextEditingController();
  TextEditingController _mothername = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController _birthtime = TextEditingController();
  TextEditingController _birthplace = TextEditingController();
  TextEditingController _contactnumber = TextEditingController();
  TextEditingController _nanivillage = TextEditingController();

  void saveData() async {
    var loginuser = GetStorage().read("user_data");
    String user_id = loginuser['user_id'].toString();

    var req = await http.post(Uri.parse(Config.matri_add), body: {
      "member_id": _member.dropDownValue!.value.toString(),
      "education": _education.text.toString(),
      "occupation": _occupation.text.toString(),
      "mother_name": _mothername.text.toString(),
      "age": _age.text.toString(),
      "height": _height.text.toString(),
      "weight": _weight.text.toString(),
      "birth_time": _birthtime.text.toString(),
      "birth_place": _birthplace.text.toString(),
      "contact_number": _contactnumber.text.toString(),
      "nani_village": _nanivillage.text.toString(),
      "create_by": user_id.toString()
    });

    var rsdata = json.decode(req.body);
    if (rsdata['status'] == 'TRUE') {
      Fluttertoast.showToast(
          msg: "Data Save Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
    Navigator.pop(context);
  }

  Future getMembers() async {
    var loginuser = GetStorage().read("user_data");
    print(loginuser);
    String member_id = loginuser['id'].toString();
    var res = await http.get(Uri.parse(Config.myrelation + "/" + member_id));
    var rsdata = json.decode(res.body);
    setState(() {
      if (rsdata['status'] == 'TRUE') {
        list = rsdata['data'];
      }
    });
  }
  // Future getCategoey() async {
  //   var res = await http.get(Uri.parse(Config.categry));
  //   var resdata = json.decode(res.body);
  //   setState(() {
  //     if (resdata['status'] == 'TRUE') {
  //       list = resdata['data'];
  //     }
  //   });
  // }

  Future<File> getFile(String type) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    setState(() {
      if (type == "logo") {
        _logo = file;
      }
    });

    return file;
  }

  @override
  void initState() {
    //getCategoey();

    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Matrimonial"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            DropDownTextField(
                controller: _member,
                textFieldDecoration: InputDecoration(
                    label: Text("Member"), border: OutlineInputBorder()),
                dropDownList: [
                  for (int i = 0; i <= list.length - 1; i++)
                    DropDownValueModel(
                        name: list[i]['first_name'], value: list[i]['mid'])
                ]),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _education,
              decoration: InputDecoration(
                  label: Text("Education"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _occupation,
              decoration: InputDecoration(
                  label: Text("Occupation"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _mothername,
              decoration: InputDecoration(
                  label: Text("Mother Name"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _age,
              decoration: InputDecoration(
                  label: Text("Age"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _height,
              decoration: InputDecoration(
                  label: Text("Height"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _weight,
              decoration: InputDecoration(
                  label: Text("Weight"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _birthtime,
              decoration: InputDecoration(
                  label: Text("Birth Time"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _birthplace,
              decoration: InputDecoration(
                  label: Text("Place of Birth"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _contactnumber,
              decoration: InputDecoration(
                  label: Text("Contact Number"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _nanivillage,
              decoration: InputDecoration(
                  label: Text("Nana Nani's Village"),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            CupertinoButton(
              onPressed: () {
                saveData();
              },
              color: const Color.fromARGB(255, 196, 41, 30),
              child: Text("SAVE"),
            ),
          ],
        ),
      ),
    );
  }
}
