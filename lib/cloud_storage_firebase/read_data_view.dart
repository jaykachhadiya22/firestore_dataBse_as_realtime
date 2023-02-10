import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_time_data_storage/cloud_storage_firebase/inser_page_view.dart';

class ReadDataView extends StatefulWidget {
  const ReadDataView({Key? key}) : super(key: key);

  @override
  State<ReadDataView> createState() => _ReadDataViewState();
}

class _ReadDataViewState extends State<ReadDataView> {
  List<dynamic> userData = [];
  bool ready = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController date = TextEditingController();
  CollectionReference docUser =
  FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    readUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Read Data"), backgroundColor: Colors.red),
      body: SafeArea(
        child: ready
            ?   Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      itemCount: userData.length,
                      itemBuilder: (context, index) {
                        String h = userData[index]['Name'];
                        return ListTile(
                          title: Text(
                            "${userData[index]['Name']}",
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text(
                            "${userData[index]['Email']}",
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            child: Center(
                                child: Text(
                                  h.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    name.text=userData[index]['Name'];
                                    email.text=userData[index]['Email'];
                                    date.text=userData[index]['Date'];
                                    showDialog(
                                        builder: (context) => SimpleDialog(
                                          title: const Text('Update Data'),
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    controller: name,
                                                    decoration:
                                                    const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              width: 2,
                                                              color: Colors
                                                                  .red)),
                                                      label: Text("Name"),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller: email,
                                                    decoration:
                                                    const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              width: 2,
                                                              color: Colors
                                                                  .red)),
                                                      label: Text("Email"),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller: date,
                                                    decoration:
                                                    const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              width: 2,
                                                              color: Colors
                                                                  .red)),
                                                      label: Text("Date"),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 140,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                       await updateData(
                                                            InsetUserDataModal(
                                                                id: userData[
                                                                index]
                                                                ['id'],
                                                                name: name.text,
                                                                email:
                                                                email.text,
                                                                date:
                                                                date.text),
                                                            userData[index]
                                                           );

                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                      const Text("Update"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.red,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        context: context);
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Colors.red),
                              IconButton(
                                  onPressed: () async {
                                   await deleteUseData(userData[index]);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red),
                            ],
                          ),
                        );
                      },
                    ),
                  ) : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return InsertPageView();
            },
          ));
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

   readUserData() async {
    // return FirebaseFirestore.instance.collection('users').snapshots().map(
    //     (snapShot) => snapShot.docs
    //         .map((e) => InsetUserDataModal.fromJson(e.data()))
    //         .toList());

    var docUser = FirebaseFirestore.instance.collection('users').doc("lNIcNFXTr0rTaK0bgyDW");

    docUser.snapshots().listen((event) {
      // print(docUser.doc().get());
      // print(event.docs[0]);
      // userData.clear();
      // ready = false;
      // for (int i = 0; i < event.docs.length; i++) {
      //   userData.add(event.docs[i]);
      // }
      userData.clear();
      userData.add(event);
      ready = true;
      setState(() {});
    });

  }

  updateData(InsetUserDataModal insetUserDataModal, QueryDocumentSnapshot userData)
  async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.id)
        .update(insetUserDataModal.toJson())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully Update Data")));
    });
  }

  deleteUseData(QueryDocumentSnapshot userData)
  async {
    await FirebaseFirestore.instance.collection('users').doc(userData.id).delete().then((value){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully Delete Data")));
    });
  }
}
// final CollectionReference _products =
// FirebaseFirestore.instance.collection('products');
