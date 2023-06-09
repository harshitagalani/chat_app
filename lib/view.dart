import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class View extends StatefulWidget {
  String? moblie;
  View([this.moblie]);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('users');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: () {
        Home.prefs!.setBool("is_login", false);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Home();
        },));
      }, icon: Icon(Icons.logout))],
        title: Text("View"),
      ),
      body: StreamBuilder(
        stream: starCountRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data!.snapshot.value;
            Map m = data as Map;
            List value = m.values.toList();
            print(value);
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return (widget.moblie!=value[index]['Moblie'])?Card(
                  child: ListTile(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Chat_Screen("${widget.moblie}","${value[index]['Moblie']}");
                    },));
                  },
                    title: Text("${value[index]['name']}"),
                    subtitle: Text("${value[index]['Moblie']}"),
                  ),
                ):Text("");
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
