
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

/*class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("Fitisly Admin"),
        backgroundColor: Colors.green,
        centerTitle: true

      ),
    );
  }
}*/




class LoginScreen extends StatelessWidget {

  TextStyle styleOS = TextStyle(fontFamily: 'OpenSans' , fontSize: 20.0);
  static const color = const Color(0xFF45E15F);
  TextEditingController emailController = new TextEditingController();
  TextEditingController pwController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String email;
    String pw;

    final emailField = TextField(
      obscureText: false,
      style: styleOS,
      decoration: InputDecoration(
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
        controller: emailController
    );

    final passwordField = TextField(
        obscureText: true,
        style: styleOS,
        decoration: InputDecoration(
            hintText: "Mot de passe",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: color,

      child: MaterialButton(
        // minWidth: MediaQuery.of(context).size.width,
        //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          printInConsole(emailController.text);
          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
               return new HomeScreen("Accueil");}));
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: styleOS.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
        minWidth: width,
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title:  Text('Fistily Admin', style: styleOS),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: width*0.2,
                  child: Image.asset(
                    "assets/logo.png",
                    // fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 35.0),
                emailField,
                SizedBox(height: 15.0),
                passwordField,
                SizedBox(height: 25.0),
                loginButon,
                SizedBox(height: 15.0,width: width,),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void goToHomePage(){
   // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
   //   return new HomePage('Accueil');
   // }));

  }

  void printInConsole(String email){
    print(email);
  }


}


