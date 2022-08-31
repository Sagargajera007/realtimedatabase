import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtimedatabase/ViewData.dart';

class insertpage extends StatefulWidget {
  Map? map;

  insertpage({this.map});

  @override
  State<insertpage> createState() => _insertpageState();
}

class _insertpageState extends State<insertpage> {
  TextEditingController tname = TextEditingController();
  TextEditingController tnumber = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.map != null) {
      tname = widget.map!['name'];
      tnumber = widget.map!['contact'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return viewdata();
                  },
                ));
              },
              icon: Icon(Icons.arrow_back)),
          title: Text("Insert Data"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: tname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: tnumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Contact',
                  )),
            ),
            ElevatedButton(
                onPressed: () {
                  if (tname.text.isNotEmpty || tnumber.text.isNotEmpty) {
                    FirebaseDatabase database = FirebaseDatabase.instance;
                    String name = tname.text;
                    String contact = tnumber.text;
                    if (widget.map == null) {
                      DatabaseReference ref = database.ref("contactbook").push();

                      String? userid = ref.key;

                      Map m = {
                        "userid": userid,
                        "name": name,
                        "contact": contact
                      };

                      ref.set(m);
                    }else
                      {
                        String userid = widget.map!['userid'];
                        DatabaseReference ref =
                        database.ref("contactbook").child(userid);

                        Map m = {"userid": userid, "name": name, "contact": contact};
                        ref.set(m);
                      }
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return viewdata();
                      },
                    ));
                  }
                },
                child:Text(widget.map ==null ? "Insert" : "Update")),
          ],
        ),
      ),
    onWillPop: goback,);
  }
  Future<bool> goback(){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return viewdata();
      },
    ));
    return Future.value();
  }
}
