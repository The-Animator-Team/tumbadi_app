import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Config.dart';

class CreatePassword extends StatefulWidget {
  final String uer_id;
  final String mobile_no;

  const CreatePassword({
    super.key,
    required this.uer_id,
    required this.mobile_no,
  });

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  String user_id = "";
  TextEditingController _mobile_no = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _cpassword = TextEditingController();

  void updatePassword() async {
    String passw = _password.text.toString();
    String cpassw = _cpassword.text.toString();
    if (passw == cpassw) {
      var res = await http.post(
        Uri.parse(Config.update_password),
        body: {'user_id': user_id, 'passw': passw},
      );
      var data = json.decode(res.body);
      if (data['status'] == 'TRUE') {
        Fluttertoast.showToast(
          msg: "Password Updated!!!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      }
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: "Password is not match with confirm password!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _mobile_no.text = widget.mobile_no.toString();
    user_id = widget.uer_id.toString();
    print("this is " + user_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login User")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              child: Image(
                image: NetworkImage(Config.logo),
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Text(
                "First Time Login",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _mobile_no,
              decoration: InputDecoration(
                label: Text("Mobile Number"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _password,
              decoration: InputDecoration(
                label: Text("Password"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cpassword,
              decoration: InputDecoration(
                label: Text("Confirm Password"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            CupertinoButton(
              color: Colors.blueAccent,
              child: Text("Update Password"),
              onPressed: () {
                updatePassword();
              },
            ),
          ],
        ),
      ),
    );
  }
}
