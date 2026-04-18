import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/Config.dart';

class FamilyAdd extends StatefulWidget {
  const FamilyAdd({super.key});

  @override
  State<FamilyAdd> createState() => _FamilyAddState();
}

class _FamilyAddState extends State<FamilyAdd> {
  TextEditingController _firstname = TextEditingController();
  TextEditingController _middlename = TextEditingController();
  TextEditingController _grandfathername = TextEditingController();
  TextEditingController _sirname = TextEditingController();

  SingleValueDropDownController _gender = SingleValueDropDownController();
  TextEditingController _date = TextEditingController();
  SingleValueDropDownController _bgroup = SingleValueDropDownController();
  SingleValueDropDownController _relation = SingleValueDropDownController();
  SingleValueDropDownController _maritalstatus =
      SingleValueDropDownController();
  SingleValueDropDownController _education = SingleValueDropDownController();
  TextEditingController _contactno = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  List<DropDownValueModel> lst_gender = [
    DropDownValueModel(name: "Male", value: "Male"),
    DropDownValueModel(name: "Female", value: "Female"),
  ];

  List<DropDownValueModel> lst_bloodgroup = [];
  List<DropDownValueModel> lst_relation = [];
  List<DropDownValueModel> lst_marital = [];
  List<DropDownValueModel> lst_education = [];

  void GetBllodGroup() async {
    var res = await http.get(Uri.parse(Config.blood_group));
    var resdata = json.decode(res.body);
    setState(() {
      var bloodgroups = resdata['data'];
      //print(bloodgroups);
      for (var element in bloodgroups) {
        lst_bloodgroup.add(DropDownValueModel(
            name: element['bloodgroup'], value: element['bloodgroup']));
      }
    });
  }

  void GetRelation() async {
    var res = await http.get(Uri.parse(Config.relations));
    var resdata = json.decode(res.body);
    setState(() {
      var bloodgroups = resdata['data'];
      //print(bloodgroups);
      for (var element in bloodgroups) {
        lst_relation.add(DropDownValueModel(
            name: element['relation'], value: element['relation']));
      }
    });
  }

  void GetMaritalStatus() async {
    var res = await http.get(Uri.parse(Config.maritalstatus));
    var resdata = json.decode(res.body);
    setState(() {
      var bloodgroups = resdata['data'];
      //print(bloodgroups);
      for (var element in bloodgroups) {
        lst_marital.add(DropDownValueModel(
            name: element['maritalstatus'], value: element['maritalstatus']));
      }
    });
  }

  void GetEducation() async {
    var res = await http.get(Uri.parse(Config.education));
    var resdata = json.decode(res.body);
    setState(() {
      var bloodgroups = resdata['data'];
      //print(bloodgroups);
      for (var element in bloodgroups) {
        lst_education.add(DropDownValueModel(
            name: element['education'], value: element['education']));
      }
    });
  }

  void saveFamily() async {
    String fmail_id = GetStorage().read("user_data")['family_id'];
    //print(GetStorage().read("user_data"));
    var res = await http.post(Uri.parse(Config.save_member), body: {
      "family_id": fmail_id,
      "first_name": _firstname.text.toString(),
      "middle_name": _middlename.text.toString(),
      "grand_father_name": _grandfathername.text.toString(),
      "last_name": _sirname.text.toString(),
      "email": _email.text.toString(),
      "phone": _contactno.text.toString(),
      "password": _password.text.toString(),
      "gender": _gender.dropDownValue!.name.toString(),
      "blood_group": _bgroup.dropDownValue!.name.toString(),
      "relation": _relation.dropDownValue!.name.toString(),
      "birth_date": _date.text.toString(),
      "marital_status": _maritalstatus.dropDownValue!.name.toString(),
      "education": _education.dropDownValue!.name.toString(),
    });

    var data = json.decode(res.body);
    print(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetBllodGroup();
    GetRelation();
    GetMaritalStatus();
    GetEducation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Family"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(children: [
          TextField(
            controller: _firstname,
            decoration: InputDecoration(
                label: Text("First Name"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: _middlename,
            decoration: InputDecoration(
                label: Text("Middle Name"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: _grandfathername,
            decoration: InputDecoration(
                label: Text("Grand Father Name"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: _sirname,
            decoration: InputDecoration(
                label: Text("Sir Name"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 5,
          ),
          DropDownTextField(
            controller: _gender,
            textFieldDecoration: InputDecoration(
                label: Text("Gender"), border: OutlineInputBorder()),
            dropDownList: lst_gender,
            onChanged: (value) {},
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: _date,
            decoration: InputDecoration(
                label: Text("Date of Birth"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 5,
          ),
          DropDownTextField(
            controller: _bgroup,
            textFieldDecoration: InputDecoration(
                label: Text("Blood Group"), border: OutlineInputBorder()),
            dropDownList: lst_bloodgroup,
            onChanged: (value) {
              // dropdownvalue = _bgroup.dropDownValue
              print("this is" + _bgroup.dropDownValue!.value.toString());
            },
          ),
          SizedBox(
            height: 5,
          ),
          DropDownTextField(
            controller: _relation,
            textFieldDecoration: InputDecoration(
                label: Text("Relation"), border: OutlineInputBorder()),
            dropDownList: lst_relation,
            onChanged: (value) {},
          ),
          SizedBox(
            height: 5,
          ),
          DropDownTextField(
            controller: _maritalstatus,
            textFieldDecoration: InputDecoration(
                label: Text("Marital Status"), border: OutlineInputBorder()),
            dropDownList: lst_marital,
            onChanged: (value) {},
          ),
          SizedBox(
            height: 5,
          ),
          DropDownTextField(
            controller: _education,
            textFieldDecoration: InputDecoration(
                label: Text("Education"), border: OutlineInputBorder()),
            dropDownList: lst_education,
            onChanged: (value) {},
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: _contactno,
            decoration: InputDecoration(
                label: Text("Contact No"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: _email,
            decoration: InputDecoration(
                label: Text("Email ID"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
                label: Text("Password"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          CupertinoButton(
            color: Colors.blueAccent,
            child: Text("SAVE"),
            onPressed: () {
              saveFamily();
              Navigator.pop(context, true);
            },
          ),
        ]),
      ),
    );
  }
}
