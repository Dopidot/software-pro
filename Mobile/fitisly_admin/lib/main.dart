import 'package:flutter/material.dart';
//import 'package:flu
//import 'dashboard_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fitisly Admin',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Fitisly admin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextStyle style = TextStyle(fontFamily: 'OpenSans' , fontSize: 20.0);
  static const color = const Color(0xFF45E15F);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        hintText: "Mot de passe",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      )
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
     color: color,
      child: MaterialButton(
       // minWidth: MediaQuery.of(context).size.width,
        //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );



    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitisly Admin'),
        centerTitle: true,
      ),

      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  child: Image.asset(
                    "assets/logo.png",

                  ),
                ),
                SizedBox(height: width *0.1),
                emailField,
                SizedBox(height: width* 0.05),
                passwordField,
                SizedBox(
                  height: width*0.1,
                ),
                loginButon,
                SizedBox(
                  height: width*0.15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
