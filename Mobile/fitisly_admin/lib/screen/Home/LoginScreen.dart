import 'package:fitislyadmin/Services/HttpServices.dart';

import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenForm();
  }
}

class LoginScreenForm extends State<LoginScreen> {


  TextStyle styleOS = TextStyle(fontFamily: 'OpenSans', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _pw;
  String _email;
  Future<int> _futureLogin;
  HttpServices services = HttpServices();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pw = "";
    _email = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Fitisly Admin",style: styleOS),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: buildForm()),
      ),
    );
  }

  Widget buildForm(){


    final emailField = TextFormField(
        onSaved: (String val){
          _email = val ;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        validator: (value){
          String pattern = r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp = new RegExp(pattern);
          if (value.isEmpty) {
            return "Attention votre champs email est vide";
          } else if (!regExp.hasMatch(value)) {
            return "Email invalide";
          } else {
            return null;
          }
        }
    );


    final passwordField = TextFormField(
      onSaved: (String val){
        _pw = val;
      },
      validator: (value){
        if(value.isEmpty){
          return "Attention votre champs mot de passe est vide";
        }
        return null;
      },
      obscureText: true,
      decoration: InputDecoration(
          hintText: "Mot de passe",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final loginButon = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: new Color(0xFF45E15F),

        child: MaterialButton(
          // minWidth: MediaQuery.of(context).size.width,
          //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              if ( _formKey.currentState.validate()) {
                _formKey.currentState.save();
                _futureLogin = services.login(_email, _pw,_scaffoldKey);

                _futureLogin
                    .then((value) {

                  if(value == 200){

                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return HomeScreenPage();
                    }));

                  }else{
                    displayDialog("Accès refusé", "Aucun compte ne correspond à l'email ou au mot de passe");

                  }
                });
              }
              else {
                setState (() {
                  _autoValidate = true ;
                });
              }
            },
            child:
            Text("Login",
                textAlign: TextAlign.center)
        )
    );
    return Center(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Padding(child: Image.asset("assets/logo.png"),padding: EdgeInsets.only(top: 5,bottom: 20),),
                flex:1,
                fit: FlexFit.loose,
              ),

              Flexible(
                child: Padding(
                  child: emailField,
                  padding: EdgeInsets.only(bottom: 5),
                ),
                flex: 1,
                //fit: FlexFit.loose,
              ),
              Flexible(child: Padding(
                padding: EdgeInsets.only(top:10, bottom: 5),
                child: passwordField,
              ),
                  flex:1,
                  fit: FlexFit.loose),
              Flexible(
                  child: Padding(child: loginButon,
                      padding: EdgeInsets.only(top:5,bottom: 10)),
                  flex: 1)
            ],
          ),
        ),
      ),
    );

  }
  void displayDialog(String title, String text) =>
      showDialog(
        context: _scaffoldKey.currentState.context,
        builder: (context) =>
            AlertDialog(
                title: Text(title),
                content: Text(text)
            ),
      );

}




