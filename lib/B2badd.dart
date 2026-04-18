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

class B2badd extends StatefulWidget {
  const B2badd({super.key});

  @override
  State<B2badd> createState() => _B2baddState();
}

class _B2baddState extends State<B2badd> {
  File? _logo, _visiting, _bimage_1, _bimage_2, _bimage_3, _bimage_4;
  List list = [];
  TextEditingController _shop_name = TextEditingController();
  SingleValueDropDownController _category = SingleValueDropDownController();
  TextEditingController _website = TextEditingController();
  TextEditingController _facebook = TextEditingController();
  TextEditingController _instagram = TextEditingController();
  TextEditingController _twitter = TextEditingController();
  TextEditingController _whatsapp = TextEditingController();
  TextEditingController _contactperson = TextEditingController();
  TextEditingController _contactno = TextEditingController();
  TextEditingController _emailid = TextEditingController();
  TextEditingController _address = TextEditingController();

  void saveB2b() async {
    var loginuser = GetStorage().read("user_data");
    String user_id = loginuser['user_id'].toString();

    var req = http.MultipartRequest('POST', Uri.parse(Config.add_b2b));

    if (_logo != null) {
      req.files.add(
        http.MultipartFile(
          'logo',
          _logo!.readAsBytes().asStream(),
          _logo!.lengthSync(),
          filename: _logo!.path.split('/').last,
        ),
      );
    }

    if (_visiting != null) {
      req.files.add(
        http.MultipartFile(
          'visiting',
          _visiting!.readAsBytes().asStream(),
          _visiting!.lengthSync(),
          filename: _visiting!.path.split('/').last,
        ),
      );
    }

    if (_bimage_1 != null) {
      req.files.add(
        http.MultipartFile(
          'bimage_1',
          _bimage_1!.readAsBytes().asStream(),
          _bimage_1!.lengthSync(),
          filename: _bimage_1!.path.split('/').last,
        ),
      );
    }

    if (_bimage_2 != null) {
      req.files.add(
        http.MultipartFile(
          'bimage_2',
          _bimage_2!.readAsBytes().asStream(),
          _bimage_2!.lengthSync(),
          filename: _bimage_2!.path.split('/').last,
        ),
      );
    }
    if (_bimage_3 != null) {
      req.files.add(
        http.MultipartFile(
          'bimage_3',
          _bimage_3!.readAsBytes().asStream(),
          _bimage_3!.lengthSync(),
          filename: _bimage_3!.path.split('/').last,
        ),
      );
    }
    if (_bimage_4 != null) {
      req.files.add(
        http.MultipartFile(
          'bimage_4',
          _bimage_4!.readAsBytes().asStream(),
          _bimage_4!.lengthSync(),
          filename: _bimage_4!.path.split('/').last,
        ),
      );
    }

    req.fields['shop_name'] = _shop_name.text.toString();
    req.fields['category'] = _category.dropDownValue!.value.toString();
    req.fields['website'] = _website.text.toString();
    req.fields['facebook'] = _facebook.text.toString();
    req.fields['instagram'] = _instagram.text.toString();
    req.fields['twitter'] = _twitter.text.toString();
    req.fields['whatsapp'] = _whatsapp.text.toString();
    req.fields['contact_person'] = _contactperson.text.toString();
    req.fields['contact_no'] = _contactno.text.toString();
    req.fields['email_id'] = _emailid.text.toString();
    req.fields['address'] = _address.text.toString();
    req.fields['user_id'] = user_id.toString();
    var res = await req.send();
    http.Response response = await http.Response.fromStream(res);
    print(response.body);
    var rsdata = json.decode(response.body);

    if (rsdata['status'] == 'TRUE') {
      Fluttertoast.showToast(
        msg: "Data Save Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
    Navigator.pop(context);
  }

  Future getCategoey() async {
    var res = await http.get(Uri.parse(Config.categry));
    var resdata = json.decode(res.body);
    setState(() {
      if (resdata['status'] == 'TRUE') {
        list = resdata['data'];
      }
    });
  }

  Future<File> getFile(String type) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    setState(() {
      if (type == "logo") {
        _logo = file;
      }
      if (type == "visiting") {
        _visiting = file;
      }
      if (type == "bimage_1") {
        _bimage_1 = file;
      }
      if (type == "bimage_2") {
        _bimage_2 = file;
      }
      if (type == "bimage_3") {
        _bimage_3 = file;
      }
      if (type == "bimage_4") {
        _bimage_4 = file;
      }
    });

    return file;
  }

  @override
  void initState() {
    getCategoey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Business")),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            TextField(
              controller: _shop_name,
              decoration: InputDecoration(
                label: Text("Company / Shop Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            DropDownTextField(
              controller: _category,
              textFieldDecoration: InputDecoration(
                label: Text("Category"),
                border: OutlineInputBorder(),
              ),
              dropDownList: [
                for (int i = 0; i <= list.length - 1; i++)
                  DropDownValueModel(
                    name: list[i]['category'],
                    value: list[i]['id'],
                  ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  child:
                      _logo == null ? Text("Select Logo") : Image.file(_logo!),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    getFile("logo");
                  },
                  icon: Icon(Icons.image),
                  iconSize: 50,
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  child:
                      _visiting == null
                          ? Text("Select Visiting Card")
                          : Image.file(_visiting!),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    getFile("visiting");
                  },
                  icon: Icon(Icons.image),
                  iconSize: 50,
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  child:
                      _bimage_1 == null
                          ? Text("Business Image 1")
                          : Image.file(_bimage_1!),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    getFile("bimage_1");
                  },
                  icon: Icon(Icons.image),
                  iconSize: 50,
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  child:
                      _bimage_2 == null
                          ? Text("Business Image 2")
                          : Image.file(_bimage_2!),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    getFile("bimage_2");
                  },
                  icon: Icon(Icons.image),
                  iconSize: 50,
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  child:
                      _bimage_3 == null
                          ? Text("Business Image 3")
                          : Image.file(_bimage_3!),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    getFile("bimage_3");
                  },
                  icon: Icon(Icons.image),
                  iconSize: 50,
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 300,
                  height: 60,
                  alignment: Alignment.center,
                  child:
                      _bimage_4 == null
                          ? Text("Business Image 4")
                          : Image.file(_bimage_4!),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    getFile("bimage_4");
                  },
                  icon: Icon(Icons.image),
                  iconSize: 50,
                ),
              ],
            ),
            SizedBox(height: 5),
            TextField(
              controller: _website,
              decoration: InputDecoration(
                label: Text("Website"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _facebook,
              decoration: InputDecoration(
                label: Text("Facebook Link"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _instagram,
              decoration: InputDecoration(
                label: Text("Instagram Link"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _twitter,
              decoration: InputDecoration(
                label: Text("Twitter Link"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _whatsapp,
              decoration: InputDecoration(
                label: Text("Whatsapp No"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _contactperson,
              decoration: InputDecoration(
                label: Text("Contact Person"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _contactno,
              decoration: InputDecoration(
                label: Text("Contact Number"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _emailid,
              decoration: InputDecoration(
                label: Text("Email ID"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _address,
              decoration: InputDecoration(
                label: Text("Address"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            CupertinoButton(
              onPressed: () {
                //CircularProgressIndicator();
                saveB2b();
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
