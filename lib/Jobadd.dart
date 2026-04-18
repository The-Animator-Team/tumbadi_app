import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'Config.dart';
import 'package:intl/intl.dart';

class Jobadd extends StatefulWidget {
  const Jobadd({super.key});

  @override
  State<Jobadd> createState() => _JobaddState();
}

class _JobaddState extends State<Jobadd> {
  File? _logo;
  List list = [];
  TextEditingController _company_name = TextEditingController();
  //SingleValueDropDownController _category = SingleValueDropDownController();
  TextEditingController _designation = TextEditingController();
  TextEditingController _contactperson = TextEditingController();
  TextEditingController _contactno = TextEditingController();
  TextEditingController _emailid = TextEditingController();
  TextEditingController _min_qaulifi = TextEditingController();
  TextEditingController _startdate = TextEditingController();
  TextEditingController _enddate = TextEditingController();
  TextEditingController _novaccancy = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _expe = TextEditingController();
  TextEditingController _ctcfrom = TextEditingController();
  TextEditingController _ctcto = TextEditingController();
  TextEditingController _description = TextEditingController();

  void saveJob() async {
    var loginuser = GetStorage().read("user_data");
    String user_id = loginuser['user_id'].toString();

    var req = http.MultipartRequest('POST', Uri.parse(Config.job_add));

    if (_logo != null) {
      req.files.add(http.MultipartFile(
          'logo', _logo!.readAsBytes().asStream(), _logo!.lengthSync(),
          filename: _logo!.path.split('/').last));
    }

    req.fields['business_name'] = _company_name.text.toString();
    req.fields['designation'] = _designation.text.toString();
    req.fields['contact_person'] = _contactperson.text.toString();
    req.fields['contact_number'] = _contactno.text.toString();
    req.fields['email_id'] = _emailid.text.toString();
    req.fields['start_date'] = _startdate.text.toString();
    req.fields['end_date'] = _enddate.text.toString();
    req.fields['vaccancy'] = _novaccancy.text.toString();
    req.fields['location'] = _location.text.toString();
    req.fields['experience'] = _expe.text.toString();
    req.fields['ctc_from'] = _ctcfrom.text.toString();
    req.fields['ctc_to'] = _ctcto.text.toString();
    req.fields['job_descrp'] = _description.text.toString();
    req.fields['user_id'] = user_id.toString();
    var res = await req.send();
    http.Response response = await http.Response.fromStream(res);
    print(response.body);
    var rsdata = json.decode(response.body);

    if (rsdata['status'] == 'TRUE') {
      Fluttertoast.showToast(
          msg: "Data Save Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
    Navigator.pop(context);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Jobs"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            TextField(
              controller: _company_name,
              decoration: InputDecoration(
                  label: Text("Company Name"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _designation,
              decoration: InputDecoration(
                  label: Text("Designation"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
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
                          color: Colors.grey, style: BorderStyle.solid)),
                ),
                IconButton(
                  onPressed: () {
                    getFile("logo");
                  },
                  icon: Icon(Icons.image),
                  iconSize: 50,
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _contactperson,
              decoration: InputDecoration(
                  label: Text("Contact Person"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _contactno,
              decoration: InputDecoration(
                  label: Text("Contact Number"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _emailid,
              decoration: InputDecoration(
                  label: Text("Email ID"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            // TextField(
            //   controller: _min_qaulifi,
            //   decoration: InputDecoration(
            //       label: Text("Min. Qualification"),
            //       border: OutlineInputBorder()),
            // ),
            SizedBox(
              height: 5,
            ),

            TextfieldDatePicker(
              decoration: InputDecoration(
                  label: Text("Start Date"), border: OutlineInputBorder()),
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
              textfieldDatePickerController: _startdate,
            ),
            SizedBox(
              height: 5,
            ),

            TextfieldDatePicker(
              decoration: InputDecoration(
                  label: Text("End Date"), border: OutlineInputBorder()),
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
              textfieldDatePickerController: _enddate,
            ),

            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _novaccancy,
              decoration: InputDecoration(
                  label: Text("No of Vaccancy"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _location,
              decoration: InputDecoration(
                  label: Text("Location"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _expe,
              decoration: InputDecoration(
                  label: Text("Experience"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _ctcfrom,
              decoration: InputDecoration(
                  label: Text("CTC Range From"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _ctcto,
              decoration: InputDecoration(
                  label: Text("CTC Range To"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _description,
              maxLines: 3,
              decoration: InputDecoration(
                  label: Text("Job Description"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5,
            ),
            CupertinoButton(
              onPressed: () {
                saveJob();
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
