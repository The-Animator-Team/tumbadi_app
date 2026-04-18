import 'package:flutter/material.dart';

class QuickLink extends StatelessWidget {
  const QuickLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quick Link"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            ListTile(
              title: Text("History"),
              onTap: () {},
            ),
            ListTile(
              title: Text("President Message"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Commitee"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Vadala Gaam Darshan"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Mata Ji"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Letest Event"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Image Gallery"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Video Gallery"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Donation"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Directory"),
              onTap: () {},
            ),
            ListTile(
              title: Text("B2B"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Jobs"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Blog"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Contact Us"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
