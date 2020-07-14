// Author : DEYEHE Jean
import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/Program.dart';
import 'package:fitislyadmin/Services/ExerciseService.dart';
import 'package:fitislyadmin/Services/ProgramService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateProgramScreen extends StatefulWidget {
  @override
  State<CreateProgramScreen> createState() {
    return _CreateProgramScreen();
  }
}

class _CreateProgramScreen extends State<CreateProgramScreen> {
  List<String> _selectExercise;
  ProgramService servicesProg = ProgramService();
  ExerciseService serviceEx = ExerciseService();

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
      appBar: AppBar(
          centerTitle: true,
          title: Text(Translations.of(context).text("subtitle_creation_prog"))),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: futureBuilderExercise(), //SingleChildScrollView(child: _buildField()),
        ),
      ),
    );
  }

  FutureBuilder<List<Exercise>> futureBuilderExercise() {
    return FutureBuilder<List<Exercise>>(
        future: serviceEx.fetchExercises(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(Translations.of(context).text("error_server")));
          }
          return snapshot.hasData ? _buildField(snapshot.data) : Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildField(List<Exercise> exercises) {

    if(exercises.isEmpty){
      return Center(child: Text(Translations.of(context).text("no_exercise")));
    }



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
            child: _image == null
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () async {
                      final pickedFile =
                          await _picker.getImage(source: ImageSource.gallery);
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    },
                    child: Icon(Icons.add))
                : Image.file(_image),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ));

    final createBtn =  Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: _validateForm,
          child: Text(Translations.of(context).text("btn_Create")),
        )
    );

    final cancelBtn =  Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.redAccent,

        child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(Translations.of(context).text("btn_cancel"))
        )
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
          child: _listExercise(exercises),
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
    var isValid = await servicesProg.createProgram(p);

    if (isValid) {
      Navigator.pop(context, p);
    } else {
      displayDialog("Erreur d'enregistrement", "Le programme n'a pas pu être enregistrer dans la base, veuillez vérifier les champs svp ");
    }
  }


  Widget _listExercise(List<Exercise> exercises) {

    if(exercises.isEmpty){
      return Center(child: Text(Translations.of(context).text('no_exercise')));
    }

    final items = exercises.map((e) => MultiSelectItem<String>("${e.id}-${e.name}", e.name)).toList();
    return Container(
      child: MultiSelectField(
        searchable: true,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        buttonText: "Exercises",
        title: "Exercises",
        items: items,
        onConfirm: (results) {
          setState(() {
            _selectExercise = results;
          });
        },
        chipDisplay: MultiSelectChipDisplay(
          items: _selectExercise != null ? _selectExercise.map((e) => MultiSelectItem<String>(e, e.split("-").last)).toList() : [],
          onTap: (value) {
            setState(() {
              _selectExercise.remove(value);
            });
          },
        ),
      ),
    );
  }

  void _validateForm(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var idExercise = List<String>();
      if(_selectExercise.isNotEmpty){
        _selectExercise.forEach((element) {
          idExercise.add(element.split("-").first);
        });
      }

      if(_name == null || _image == null || _desc == null ){
        displayDialog(Translations.of(context).text("error_title"), Translations.of(context).text('error_field_null'));
      }
      Program p = Program(name: _name, description: _desc, programImage: _image.path,exercises: idExercise);


      createProgramInServer(p);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }


  void displayDialog(String title, String text) => showDialog(
    context: _scaffoldKey.currentState.context,
    builder: (context) =>
        AlertDialog(title: Text(title), content: Text(text)),
  );

}
