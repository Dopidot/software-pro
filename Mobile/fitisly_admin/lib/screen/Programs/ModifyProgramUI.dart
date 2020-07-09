import 'dart:io';
import 'package:fitislyadmin/Services/ProgramService.dart';
import 'package:fitislyadmin/model/Program.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModifyProgramUI extends StatefulWidget{

  String programId ;
  ModifyProgramUI({Key key, @required this.programId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ModifyProgramUI();
  }
  
}

class _ModifyProgramUI extends State<ModifyProgramUI> {
  ProgramService services = ProgramService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  String _desc;
  String _name;
  File _image;
  final _picker = ImagePicker();
  Future<Program> futureProg;

  @override
  void initState() {
    // TODO: implement initState
    futureProg = services.getProgramById(widget.programId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(centerTitle: true, title: Text("Mon programme")),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: SingleChildScrollView(
            child: buildFutureProgram()),
      ),
    );
  }

  Widget _buildField(Program prog) {

    final nameField = TextFormField(
      initialValue: prog.name,
      validator: validateField,
      onSaved: (String val) {
        _name = val;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Nom du programme",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );


    final descField = TextFormField(
      initialValue: prog.description,
      validator: validateField,
      onSaved: (String val) {
        _desc = val;
      },
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: null,
      decoration: InputDecoration(
          hintText: "La description du programme",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    var urlImage = "http://localhost:4000/"+prog.programImage;

    final photoField = Container(
        height: 200,
        width: 175,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Center(
            child: Image.network(urlImage)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ));

    RaisedButton updateBtn = RaisedButton(
      child: Text('Modifier'),
      color: Colors.green,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          Program p = Program(
              name: _name,
              description: _desc,
              programImage: _image != null ? _image.path : prog.programImage);
          updateProgram(p);
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
              child: updateBtn,
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
      return "Attention votre champs mot de passe est vide";
    }
    return null;
  }

  Future<void> updateProgram(Program p) async {
    var isValid = await services.updateProgram(p);
    if (isValid) {
      Navigator.pop(context,p);
    } else {
      displayDialog("Erreur d'enregistrement",
          "Le programme n'a pas pu être enregistrer dans la base, veuillez vérifier les champs svp ");
    }
  }

  FutureBuilder<Program> buildFutureProgram() {
    return FutureBuilder<Program>(
      future: futureProg,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildField(snapshot.data);
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );

  }

  void displayDialog(String title, String text) => showDialog(
    context: _scaffoldKey.currentState.context,
    builder: (context) =>
        AlertDialog(title: Text(title), content: Text(text)),
  );
}
