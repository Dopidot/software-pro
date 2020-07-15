// Author : DEYEHE Jean
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'HomeUI.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandler;


class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {

  TextStyle styleOS = TextStyle(fontFamily: 'OpenSans', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _pw;
  String _email;
  Future<int> _futureLogin;
  HttpServices services = HttpServices();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;


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
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: buildForm()),
        ),
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
            hintText: Translations.of(context).text('field_login_email'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        validator: (value){

          if (value.isEmpty) {
            return Translations.of(context).text('field_is_empty');
          } else if (!value.contains('@')) {
            return Translations.of(context).text('email_is_valid');
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
          return Translations.of(context).text('field_is_empty');
        }
        return null;
      },
      obscureText: true,
      decoration: InputDecoration(
          hintText: Translations.of(context).text('field_login_pw'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: new Color(0xFF45E15F),

        child: MaterialButton(

            onPressed: _asyncAction,
            child:
            Text(Translations.of(context).text("login_btn"),
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
              Padding(
                child: Image.asset("assets/logo.png"),
                padding: EdgeInsets.only(top: 5,bottom: 20),),
              Padding(
                  child: emailField,
                  padding: EdgeInsets.only(bottom: 5),
                ),
             Padding(
                padding: EdgeInsets.only(top:10, bottom: 5),
                child: passwordField,
              ),
              Padding(child: _isLoading ? CircularProgressIndicator() : loginButton,
                      padding: EdgeInsets.only(top:5,bottom: 10)),
            ],
          ),
        ),
      ),
    );
  }



  void _asyncAction() async {

    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() => _isLoading = true);

      _futureLogin = services.login(_email, _pw);

                _futureLogin
                    .then((value) {

                  if(value == 200){
                    setState(() => _isLoading = false);

                    Navigator.pushAndRemoveUntil(context,
                      PageRouteTransition(
                    animationType: AnimationType.fade,
                    builder: (context) => HomeScreenPage(),
                  ), (route) => false);

                  }else{
                    setState(() => _isLoading = false);

                    ConstApiRoute.displayDialog(Translations.of(context).text('title_no_access'),Translations.of(context).text('login_descption_no_access'),_scaffoldKey);
                  }
                }).catchError((onError){

                  ConstApiRoute.displayDialog(Translations.of(context).text('title_no_access'),Translations.of(context).text('login_descption_no_access'),_scaffoldKey);

                });
    }
    else {
      setState (() {
        _autoValidate = true ;
      });
    }

  }




}




