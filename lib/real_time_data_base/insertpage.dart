
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:real_time_data_storage/real_time_data_base/viewpage.dart';


class InsertPage extends StatefulWidget {
 final Map? map;
 const InsertPage({Key? key,  this.map}) : super(key: key);

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  TextEditingController tName =TextEditingController();
  TextEditingController tContact =TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.map!=null)
      {
        tName.text=widget.map!['name'];
        tContact.text=widget.map!['contact'];
      }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const ViewPage();
          },));
        }, icon: const Icon(Icons.arrow_back)),
        title: const Text("Insert page"),),
        body: Column(
          children: [
            TextField(
              controller: tName,),
            TextField(controller: tContact,),
            ElevatedButton(onPressed: () {
              FirebaseDatabase database =FirebaseDatabase.instance;

              String name = tName.text;
              String contact = tContact.text;

              if(widget.map==null)
                {
                  DatabaseReference ref = database.ref("student").push();
                  String? userid = ref.key;
                  Map m = {"userid" : userid,"name" : name,"contact":contact};

                  ref.set(m);
                }else
                  {
                    String userid=widget.map!['userid'];
                    DatabaseReference ref=database.ref("otp_firebase").child(userid);
                    Map m = {"userid" : userid,"name" : name,"contact":contact};
                    ref.set(m);
                  }
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const ViewPage();
                },
              ));
            }, child:  Text(widget.map==null?"Insert":"update"))
          ],
        ),
      ),  onWillPop: (goBack) ,
    );
  }
  Future<bool> goBack()
  {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const ViewPage();
      },
    ));

    return Future.value();
  }
}
