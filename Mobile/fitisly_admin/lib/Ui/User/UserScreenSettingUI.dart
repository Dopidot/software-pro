import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/User.dart';
import 'package:fitislyadmin/Services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserScreenSetting extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _UserScreenSetting();
  }
}

class _UserScreenSetting extends State<UserScreenSetting> {

  UserService services = UserService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _email;
  String _firstName;
  String _lastName;
  File _image;
  final _picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Bonjour"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: buildFutureUser()),
          ),
        ),
    );

  }

  Widget buildForm(User currentUser){

    final photoField = GestureDetector(
      child: CircleAvatar(
        //child: ,
        backgroundImage: _image != null ? FileImage(_image) : null,
        minRadius: 40,
        maxRadius: 80,
      ),
      onTap: () async {

        final pickedFile =
            await _picker.getImage(source: ImageSource.gallery);
        setState(() {
          _image = File(pickedFile.path);
        });
        print("Clic !!");
    },
    );


    final emailField = TextFormField(
      initialValue: currentUser.email,
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


    final firstNameField = TextFormField(
      initialValue: currentUser.firstName,
      onSaved: (String val){
        _firstName = val;
      },
      validator: (value){
        if(value.isEmpty){
          return "Attention votre champs mot de passe est vide";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "Prénom",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final lastNameField = TextFormField(
      initialValue: currentUser.lastName,
      onSaved: (String val){
        _lastName = val;
      },
      validator: (value){
        if(value.isEmpty){
          return "Attention votre champs mot de passe est vide";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "Nom",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final updateButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: () {
            _updateInput(currentUser);
          },
          child: Text("Modifier"),
        )
    );

    final cancelButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red,

        child: MaterialButton(
          onPressed: () {
           // Navigator.popUntil(context, (route) => false);
            Navigator.pop(context);

          },
          child: Text("Annuler"),
        )
    );


    return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: photoField,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: emailField,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: firstNameField,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: lastNameField,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: updateButton,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: cancelButton,
              ),
            ],
          ),
        ]
    );

  }


  FutureBuilder<User> buildFutureUser() {
    return FutureBuilder<User>(
      future: services.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildForm(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );

  }

  Future<void> _updateInput(User user) async {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      user.email = _email;
      user.lastName = _lastName;
      user.firstName = _firstName;
      user.userImage = _image.path;

      var futureUser = await services.updateUser(user);

      if(futureUser){
      //  Navigator.popUntil(context, (route) => false);
        Navigator.pop(context);

      }

    } else {
      setState (() {
        _autoValidate = true ;
      });
    }
  }



}




