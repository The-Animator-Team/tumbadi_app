import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/Config.dart';

class Addmembers extends StatefulWidget {
  const Addmembers({super.key});

  @override
  State<Addmembers> createState() => _AddmembersState();
}

class _AddmembersState extends State<Addmembers> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _middleName = TextEditingController();
  TextEditingController _grandFatherName = TextEditingController();
  TextEditingController _surName = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _village = TextEditingController();
  TextEditingController _emailid = TextEditingController();
  TextEditingController _mobileno = TextEditingController();
  TextEditingController _officeMobieno = TextEditingController();
  SingleValueDropDownController _gender = SingleValueDropDownController();
  SingleValueDropDownController _bloodGrup = SingleValueDropDownController();
  TextEditingController _birthDate = TextEditingController();
  SingleValueDropDownController _maritalStatus =
      SingleValueDropDownController();
  TextEditingController _marrigeDate = TextEditingController();
  TextEditingController _education = TextEditingController();
  TextEditingController _occupation = TextEditingController();
  TextEditingController _lifeInsu = TextEditingController();
  TextEditingController _sports = TextEditingController();

  void addmember() async {
    var loginuser = GetStorage().read("user_data");
    String user_id = loginuser['user_id'].toString();

    var res = await http.post(
      Uri.parse(Config.add_member),
      body: {
        'first_name': _firstName.text.toString(),
        'middle_name': _middleName.text.toString(),
        'grand_father_name': _grandFatherName.text.toString(),
        'last_name': _surName.text.toString(),
        'address': _address.text.toString(),
        'location': _location.text.toString(),
        'pincode': _pincode.text.toString(),
        'city': _city.text.toString(),
        'state': _state.text.toString(),
        'village': _village.text.toString(),
        'email_id': _emailid.text.toString(),
        'contact_no_1': _mobileno.text.toString(),
        'contact_no_2': _officeMobieno.text.toString(),
        'gender':
            _gender.dropDownValue?.value.toString() == null
                ? ""
                : _gender.dropDownValue?.value.toString(),
        'blood_group':
            _bloodGrup.dropDownValue?.value.toString() == null
                ? ""
                : _bloodGrup.dropDownValue?.value.toString(),
        'birth_date': _birthDate.text.toString(),
        'marital_status':
            _maritalStatus.dropDownValue?.value.toString() == null
                ? ""
                : _maritalStatus.dropDownValue?.value.toString(),
        'marriage_date': _marrigeDate.text.toString(),
        'education': _education.text.toString(),
        'occupation': _occupation.text.toString(),
        'life_insure': _lifeInsu.text.toString(),
        'sports': _sports.text.toString(),
        'user_id': user_id.toString(),
      },
    );
    var resdata = json.decode(res.body);
    if (resdata['status'] == 'TRUE') {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: resdata['msg'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong!!!",
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
      appBar: AppBar(title: Text("Add member")),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            TextField(
              controller: _firstName,
              decoration: InputDecoration(
                label: Text("First Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _middleName,
              decoration: InputDecoration(
                label: Text("Middle Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _grandFatherName,
              decoration: InputDecoration(
                label: Text("Grand Father Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _surName,
              decoration: InputDecoration(
                label: Text("Sur Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _address,
              decoration: InputDecoration(
                label: Text("Address"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _location,
              decoration: InputDecoration(
                label: Text("Location"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _pincode,
              decoration: InputDecoration(
                label: Text("Pincode"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _city,
              decoration: InputDecoration(
                label: Text("City"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _state,
              decoration: InputDecoration(
                label: Text("State"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _village,
              decoration: InputDecoration(
                label: Text("Village"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailid,
              decoration: InputDecoration(
                label: Text("Email ID"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _mobileno,
              decoration: InputDecoration(
                label: Text("Contact"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _officeMobieno,
              decoration: InputDecoration(
                label: Text("Office Contact"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropDownTextField(
              controller: _gender,
              textFieldDecoration: InputDecoration(
                label: Text("Gender"),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {},
              dropDownList: [
                DropDownValueModel(name: 'Male', value: 'Male'),
                DropDownValueModel(name: 'Female', value: 'Female'),
              ],
            ),
            SizedBox(height: 10),
            DropDownTextField(
              controller: _bloodGrup,
              textFieldDecoration: InputDecoration(
                label: Text("Blood Group"),
                border: OutlineInputBorder(),
              ),
              dropDownList: [
                DropDownValueModel(name: "A+", value: "A+"),
                DropDownValueModel(name: "A-", value: "A-"),
                DropDownValueModel(name: "B+", value: "B+"),
                DropDownValueModel(name: "B-", value: "B-"),
                DropDownValueModel(name: "O+", value: "O+"),
                DropDownValueModel(name: "O-", value: "O-"),
                DropDownValueModel(name: "AB+", value: "AB+"),
                DropDownValueModel(name: "AB-", value: "AB-"),
              ],
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
              preferredDateFormat: DateFormat('yyyy-M-dd'),
              textfieldDatePickerController: _birthDate,
            ),
            SizedBox(height: 10),
            DropDownTextField(
              controller: _maritalStatus,
              textFieldDecoration: InputDecoration(
                label: Text("Marital Status"),
                border: OutlineInputBorder(),
              ),
              dropDownList: [
                DropDownValueModel(name: "Single", value: "Single"),
                DropDownValueModel(name: "Engaged", value: "Engaged"),
                DropDownValueModel(name: "Married", value: "Married"),
                DropDownValueModel(name: "Widow", value: "Widow"),
                DropDownValueModel(name: "Divorced", value: "Divorced"),
                DropDownValueModel(name: "Diksha", value: "Diksha"),
              ],
            ),
            SizedBox(height: 10),
            TextfieldDatePicker(
              decoration: InputDecoration(
                label: Text("Marriage Date"),
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
              preferredDateFormat: DateFormat('yyyy-M-dd'),
              textfieldDatePickerController: _marrigeDate,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _education,
              decoration: InputDecoration(
                label: Text("Education"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _occupation,
              decoration: InputDecoration(
                label: Text("Occupation"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lifeInsu,
              decoration: InputDecoration(
                label: Text("Life Insurance"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _sports,
              decoration: InputDecoration(
                label: Text("Sports"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            CupertinoButton(
              color: Colors.blue,
              child: Text("SAVE"),
              onPressed: () {
                addmember();
              },
            ),
          ],
        ),
      ),
    );
  }
}
