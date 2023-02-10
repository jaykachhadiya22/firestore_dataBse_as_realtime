import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'insertpage.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  List l=[];
  bool status =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllData();
  }
  loadAllData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("otp_firebase");

    DatabaseEvent databaseEvent = await ref.once();

    DataSnapshot snapshot = databaseEvent.snapshot;

    print(snapshot.value);

    Map<String,dynamic>? map = (snapshot.value==null ? null :snapshot.value) as Map<String, dynamic>?;

    map?.forEach((key, value) {
      Map m = {"key" : key};
      m.addAll(value);
      l.add(value);
    });

    setState(() {
      status = true;
    });
    print(l);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("view data"),),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return InsertPage();
        },));
      },child: const Icon(Icons.add),
      ),
      body: status
      ?ListView.builder(
        itemCount: l.length,
        itemBuilder: (context, index) {
          Map m=l[index];
          User user=User.fromJson(m);
          return ListTile(
            title: Text("${user.name}"),
            subtitle:Text("${user.contact}") ,
            onTap: () {
              showDialog( builder:(context1) {
                return SimpleDialog(
                  title: const Text("Select choice"),
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context1);

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return InsertPage(map:m);
                        },));
                      },
                      title: const Text("Update"),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context1);
                        DatabaseReference ref =FirebaseDatabase
                            .instance.ref("otp_firebase")
                            .child(user.userid!);
                        await ref.remove();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return const ViewPage();
                        },));
                      },
                    )
                  ],
                );
              },context: context);
            },
          );
      },):const Center(child: CircularProgressIndicator())
    );
  }
}


class User {
  String? contact;
  String? name;
  String? userid;

  User({this.contact, this.name, this.userid});

  User.fromJson(Map json) {
    contact = json['contact'];
    name = json['name'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    data['name'] = this.name;
    data['userid'] = this.userid;
    return data;
  }
}

