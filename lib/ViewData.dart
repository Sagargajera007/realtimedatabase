import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtimedatabase/InsertPage.dart';

class viewdata extends StatefulWidget {
  const viewdata({Key? key}) : super(key: key);

  @override
  State<viewdata> createState() => _viewdataState();
}

class _viewdataState extends State<viewdata> {
  List l = [];
  bool status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadAllData();
  }

  loadAllData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("contactbook");

    DatabaseEvent databaseEvent = await ref.once();

    DataSnapshot snapshot = databaseEvent.snapshot;

    print(snapshot.value);

    Map map = snapshot.value as Map;

    map.forEach((key, value) {
      // Map m = {"key" : key};
      // m.addAll(value);
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
      appBar: AppBar(
        title: Text("View Data"),
      ),
      body: status
          ? ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                Map m = l[index];
                User user = User.fromJson(m);
                return ListTile(
                  onTap: () {
                    showDialog(
                        builder: (context1) {
                          return SimpleDialog(
                            title: Text("Select Choice"),
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.pop(context1);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return insertpage(map : m);
                                  },));
                                },
                                title: Text("Update"),
                              ),
                              ListTile(
                                onTap: () async {
                                  Navigator.pop(context1);
                                  DatabaseReference ref = FirebaseDatabase.instance.ref("contactbook").child(user.userid!);
                                  await ref.remove();

                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return viewdata();
                                        },
                                      ));
                                },
                                title: Text("Delete"),
                              )
                            ],
                          );
                        },
                        context: context);
                  },
                  title: Text("${user.name}"),
                  subtitle: Text("${user.contact}"),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class User {
  String? userid;
  String? name;
  String? contact;

  User({this.userid, this.name, this.contact});

  User.fromJson(Map json) {
    userid = json['userid'];
    name = json['name'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['name'] = this.name;
    data['contact'] = this.contact;
    return data;
  }
}
