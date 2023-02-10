import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


class InsertPageView extends StatelessWidget {
  InsertPageView({Key? key}) : super(key: key);
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Insert Data"), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.red)),
                label: Text("Name"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.red)),
                label: Text("Email"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: date,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.red)),
                label: Text("Date"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await insertData(name.text, email.text, date.text).then((value){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Insert Data")));
                });
                Navigator.pop(context);
              },
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future insertData(String name, String email, String date) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  final user =
      InsetUserDataModal(id: docUser.id, name: name, email: email, date: date);

  final json = user.toJson();

  await docUser.set(json);
}

InsetUserDataModal insetUserDataModalFromJson(String str) =>
    InsetUserDataModal.fromJson(json.decode(str));

String insetUserDataModalToJson(InsetUserDataModal data) =>
    json.encode(data.toJson());

class InsetUserDataModal {
  InsetUserDataModal({
    required this.id,
    required this.name,
    required this.email,
    required this.date,
  });

  String id;
  String name;
  String email;
  String date;

  factory InsetUserDataModal.fromJson(Map<String, dynamic> json) =>
      InsetUserDataModal(
        id: json["id"],
        name: json["Name"],
        email: json["Email"],
        date: json["Date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Email": email,
        "Date": date,
      };
}
