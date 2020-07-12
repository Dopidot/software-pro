import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/Program.dart';
import 'package:fitislyadmin/Services/ProgramService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateProgramScreen extends StatefulWidget {
  @override
  State<CreateProgramScreen> createState() {
    return _CreateProgramScreen();
  }
}

class _CreateProgramScreen extends State<CreateProgramScreen> {
  ProgramService services = ProgramService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  String _desc;
  String _name;
  File _image;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(centerTitle: true, title: Text(Translations.of(context).text("subtitle_creation_prog"))),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: SingleChildScrollView(child: _buildField()),
      ),
    );
  }

  Widget _buildField() {
    
    final nameField = TextFormField(
      validator: validateField,
      onSaved: (String val) {
        _name = val;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_name"),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );
    

    final descField = TextFormField(
      validator: validateField,
      onSaved: (String val) {
        _desc = val;
      },
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: null,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_description"),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    final photoField = Container(
        height: 200,
        width: 175,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Center(
            child: _image == null ? RaisedButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), onPressed: () async {final pickedFile = await _picker.getImage(source: ImageSource.gallery);setState(() {_image = File(pickedFile.path);});}, child: Icon(Icons.add)): Image.file(_image),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ));

    RaisedButton createBtn = RaisedButton(
      child: Text(Translations.of(context).text("btn_create")),
      color: Colors.green,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          Program p = Program(
              name: _name,
              description: _desc,
              programImage: _image.path);
          createProgramInServer(p);
        } else {
          setState(() {
            _autoValidate = true;
          });
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );

    RaisedButton cancelBtn = RaisedButton(
      child: Text('Annuler'),
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: nameField,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: descField,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: photoField,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: createBtn,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cancelBtn,
            ),
          ],
        ),
      ],
    );
  }

  String validateField(String val) {
    if (val.isEmpty) {
      return Translations.of(context).text("field_is_empty");
    }
    return null;
  }

  Future<void> createProgramInServer(Program p) async {
    var isValid = await services.createProgram(p);

    if (isValid) {
      Navigator.pop(context,p);
    } else {
      displayDialog("Erreur d'enregistrement",
          "Le programme n'a pas pu être enregistrer dans la base, veuillez vérifier les champs svp ");
    }
  }

  void displayDialog(String title, String text) => showDialog(
        context: _scaffoldKey.currentState.context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
