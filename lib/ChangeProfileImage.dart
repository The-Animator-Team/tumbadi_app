import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'Config.dart';

class ChangeProfileImage extends StatefulWidget {
  final String user_id;
  final String imagePath;

  const ChangeProfileImage({
    required this.user_id,
    required this.imagePath,
    super.key,
  });

  @override
  State<ChangeProfileImage> createState() => _ChangeProfileImageState();
}

class _ChangeProfileImageState extends State<ChangeProfileImage> {
  File? _image;

  Future<File> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    setState(() {
      _image = file;
    });

    return file;
  }

  uploadImgae() async {
    if (_image == null) {
      Fluttertoast.showToast(
        msg: "Please select the image",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } else {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Config.update_profile_pic),
      );
      request.files.add(
        http.MultipartFile(
          'image',
          _image!.readAsBytes().asStream(),
          _image!.lengthSync(),
          filename: _image!.path.split('/').last,
        ),
      );
      request.fields['user_id'] = widget.user_id.toString();
      var res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      var resJson = json.decode(response.body);
      if (resJson['status'] == 'TRUE') {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: resJson['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: resJson['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Image")),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).width - 10,
            child:
                _image == null
                    ? Image(image: NetworkImage(widget.imagePath.toString()))
                    : Image.file(_image!),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              "Update Profile Pic",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                color: Colors.blue,
                child: Text("Gallery"),
                onPressed: () {
                  getImage();
                },
              ),
            ],
          ),
          CupertinoButton(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10),
              width: 200,
              color: Colors.brown,
              child: Text('Update Pic', style: TextStyle(color: Colors.white)),
            ),
            onPressed: () {
              uploadImgae();
            },
          ),
        ],
      ),
    );
  }
}
