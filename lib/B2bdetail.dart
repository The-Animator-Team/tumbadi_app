import 'package:flutter/material.dart';

class B2bDetail extends StatefulWidget {
  final b2bdata;

  const B2bDetail({required this.b2bdata, super.key});

  @override
  State<B2bDetail> createState() => _B2bDetailState();
}

class _B2bDetailState extends State<B2bDetail> {
  b2bDetail() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.b2bdata['company_name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Image(
              image: NetworkImage(widget.b2bdata['logo']),
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.b2bdata['company_name'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28),
            ),
            Text(
              "Contact Person :   " + widget.b2bdata['contact_person'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Contact Number :   " + widget.b2bdata['contact_number'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Email ID :   " + widget.b2bdata['email_id'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Address :   " + widget.b2bdata['address'],
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
