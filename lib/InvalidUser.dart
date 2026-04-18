import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Config.dart';

class InvalidUser extends StatefulWidget {
  final String firstName;
  final String middleName;
  final String sirName;
  final String mobileNo;
  final String birthDate;

  const InvalidUser({
    required this.firstName,
    required this.middleName,
    required this.sirName,
    required this.mobileNo,
    required this.birthDate,
    super.key,
  });

  @override
  State<InvalidUser> createState() => _InvalidUserState();
}

class _InvalidUserState extends State<InvalidUser> {
  launchWhatsApp() async {
    String message = "User this does not exist ";
    message = message + "\n First Name  :  " + widget.firstName.toString();
    message = message + "\n Middle Name  :  " + widget.middleName.toString();
    message = message + "\n Sir Name  :  " + widget.sirName.toString();
    message = message + "\n Mobile No  :  " + widget.mobileNo.toString();
    message = message + "\n Birth Date  :  " + widget.birthDate.toString();

    final link = WhatsAppUnilink(phoneNumber: '919699449902', text: message);
    print(link);
    await launch('$link');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invalid User")),
      body: Padding(
        padding: EdgeInsets.all(8),
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
                "User Does not exits",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text(widget.firstName.toString()),
              subtitle: Text("First Name"),
            ),
            ListTile(
              title: Text(widget.middleName.toString()),
              subtitle: Text("Middle Name"),
            ),
            ListTile(
              title: Text(widget.sirName.toString()),
              subtitle: Text("Sur Name"),
            ),
            ListTile(
              title: Text(widget.mobileNo.toString()),
              subtitle: Text("Moile Number"),
            ),
            ListTile(
              title: Text(widget.birthDate.toString()),
              subtitle: Text("Date of birth"),
            ),
            Divider(thickness: 2),
            SizedBox(height: 20),
            Text(
              "Contact With Admin",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     CupertinoButton(
            //       child: Container(
            //         width: 200,
            //         padding: EdgeInsets.symmetric(vertical: 10),
            //         alignment: Alignment.center,
            //         decoration: BoxDecoration(
            //             color: Colors.green,
            //             borderRadius: BorderRadius.circular(10)),
            //         child: Text(
            //           "Whatsapp",
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //       onPressed: () {
            //         launchWhatsApp();
            //         //print(withPhoneNumberAndText);
            //       },
            //     ),

            //     // CupertinoButton(
            //     //   child: Container(
            //     //     width: 100,
            //     //     padding: EdgeInsets.symmetric(vertical: 10),
            //     //     alignment: Alignment.center,
            //     //     decoration: BoxDecoration(
            //     //         color: Colors.blue,
            //     //         borderRadius: BorderRadius.circular(10)),
            //     //     child: Text(
            //     //       "E-Mail",
            //     //       style: TextStyle(color: Colors.white),
            //     //     ),
            //     //   ),
            //     //   onPressed: () {},
            //     // )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
