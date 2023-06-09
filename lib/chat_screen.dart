import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Chat_Screen extends StatefulWidget {
  String sender, receiver;

  Chat_Screen(this.sender, this.receiver);

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  TextEditingController t = TextEditingController();
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('chat');

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("${widget.receiver}"),
    ),
      body: Column(children: [
        Text("${widget.sender}"),
        Expanded(child: StreamBuilder(
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
                     return (widget.sender == value[index]['sender']) ?
                     ListTile(
                       trailing: Text("${value[index]['Msg']}"),
                     )
                         : ListTile(leading: Text(
                         "${value[index]['Msg']}"),);
                   },
                 );
               } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        ),
        Row(children: [
          Expanded(child: TextField(
            controller: t, decoration: InputDecoration(hintText: "Enter Moblie"),
          ),),
          IconButton(onPressed: () async {
            DatabaseReference ref = FirebaseDatabase.instance.ref('chat').push();
            await ref.set({
              "Msg": "${t.text}",
              "sender": "${widget.sender}",
              "receiver": "${widget.receiver}",
              "time": "${DateTime.now()}",
            });
            t.text = "";
          }, icon: Icon(Icons.send)),
        ],)
      ],),
    );
  }
}
