import 'package:chat_app/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  static SharedPreferences? prefs;
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  bool temp=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_prefs();
    }
    get_prefs() async {
      Home.prefs = await SharedPreferences.getInstance();
      temp=Home.prefs!.getBool("is_login")??false;
      if(temp==true)
        {
          Future.delayed(Duration.zero).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) {
            return View();
          },)));
        }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo Chat app"),
      ),
      body: Column(
        children: [
          Text("New user Registration"),
          TextField(
            controller: t1,
            decoration: InputDecoration(hintText: "Enter Name"),
          ),
          TextField(
            controller: t2,
            decoration: InputDecoration(hintText: "Enter Moblie"),
          ),
          ElevatedButton(
              onPressed: () async {
                DatabaseReference ref = FirebaseDatabase.instance.ref('users').push();
                await ref.set({
                  "name":"${t1.text}",
                  "Moblie":"${t2.text}",
                });
                setState(() {
                  Home.prefs!.setBool("is login", true);
                  print("data:${Home.prefs!.setBool("is_login", true)}");

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return View(t1.text);
                  },));
                });

              },
              child: Text("Submit")),
          // ElevatedButton(onPressed: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) {
          //     return View("123");
          //   },));
          //   // }, child: Text("abc")),
            // ElevatedButton(onPressed: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) {
            //     return View("321");
            //   },));
            // }, child: Text("xyz")),
            // ElevatedButton(onPressed: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) {
            //     return View("5555");
            //   },));
            // }, child: Text("hello")),
        ],
      ),
    );
  }
}
