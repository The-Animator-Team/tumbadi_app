import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tumbadi_app/CreatePassword.dart';
import 'package:tumbadi_app/InvalidUser.dart';
import 'Config.dart';
import 'package:http/http.dart' as http;
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'package:intl/intl.dart';

class FirstTimeLogin extends StatefulWidget {
  const FirstTimeLogin({super.key});

  @override
  State<FirstTimeLogin> createState() => _FirstTimeLoginState();
}

class _FirstTimeLoginState extends State<FirstTimeLogin> {
  TextEditingController _firstname = TextEditingController();
  TextEditingController _middlename = TextEditingController();
  TextEditingController _sirname = TextEditingController();
  TextEditingController _mobileno = TextEditingController();
  TextEditingController _dateofbirth = TextEditingController();

  void gerRegisterUser() async {
    var res = await http.post(
      Uri.parse(Config.firs_time_login),
      body: {
        'firstname': _firstname.text,
        'middlename': _middlename.text,
        'sirname': _sirname.text,
        'mobileno': _mobileno.text,
        'dateofbirth': _dateofbirth.text.toString(),
      },
    );
    var data = json.decode(res.body);
    //print("dddd " + _dateofbirth.text.toString());
    if (data['status'] == 'TRUE') {
      print(data['data']);
      var info = data['data'];
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CreatePassword(
              uer_id: info['user_id'].toString(),
              mobile_no: info['contact_no_1'].toString(),
            );
          },
        ),
      );
      Fluttertoast.showToast(
        msg: "Your Are Registered User",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return InvalidUser(
              firstName: _firstname.text.toString(),
              middleName: _middlename.text.toString(),
              sirName: _sirname.text.toString(),
              mobileNo: _mobileno.text.toString(),
              birthDate: _dateofbirth.text.toString(),
            );
          },
        ),
      );
      Fluttertoast.showToast(
        msg: "Invalid User data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
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
      appBar: AppBar(title: Text("Login User")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 10),
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
              controller: _firstname,
              decoration: InputDecoration(
                label: Text("First Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _middlename,
              decoration: InputDecoration(
                label: Text("Middle Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _sirname,
              decoration: InputDecoration(
                label: Text("Sur Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _mobileno,
              decoration: InputDecoration(
                label: Text("Mobile No"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextfieldDatePicker(
              decoration: InputDecoration(
                label: Text("Date Of Birth"),
                border: OutlineInputBorder(),
              ),
              cupertinoDatePickerBackgroundColor: Colors.white,
              cupertinoDatePickerMaximumDate: DateTime(2099),
              cupertinoDatePickerMaximumYear: 2099,
              cupertinoDatePickerMinimumYear: 1930,
              cupertinoDatePickerMinimumDate: DateTime(1930),
              cupertinoDateInitialDateTime: DateTime.now(),
              materialDatePickerFirstDate: DateTime(1930),
              materialDatePickerInitialDate: DateTime.now(),
              materialDatePickerLastDate: DateTime(2099),
              //preferredDateFormat: DateFormat('yyyy-M-dd'),
              preferredDateFormat: DateFormat('yyyy-MM-dd'),
              textfieldDatePickerController: _dateofbirth,
            ),
            SizedBox(height: 10),
            CupertinoButton(
              color: Colors.blueAccent,
              child: Text("Password Request"),
              onPressed: () {
                gerRegisterUser();
              },
            ),
          ],
        ),
      ),
    );
  }
}
