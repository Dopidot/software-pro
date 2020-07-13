// Author : DEYEHE Jean
import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/Exercise.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Program.dart';
import 'package:fitislyadmin/Services/ExerciseService.dart';
import 'package:fitislyadmin/Services/ProgramService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ModifyProgramUI extends StatefulWidget {
  String programId;

  ModifyProgramUI({Key key, @required this.programId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ModifyProgramUI();
  }
}

class _ModifyProgramUI extends State<ModifyProgramUI> {
  ExerciseService serviceEx = ExerciseService();

  List<String> _selectExercise;
  ProgramService services = ProgramService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  String _desc;
  String _name;
  File _image;
  final _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(Translations.of(context).text("title_program_detail"))),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[buildFutureProgram(), futureBuilderAllExercises()],
        )),
      ),
    );
  }

  FutureBuilder<List<Exercise>> futureBuilderAllExercises() {
    return FutureBuilder<List<Exercise>>(
        future: serviceEx.fetchExercises(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(Translations.of(context).text("error_server")));
          }
          return snapshot.hasData
              ? futureBuilderExercisesByProgram(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  FutureBuilder<List<Exercise>> futureBuilderExercisesByProgram(List<Exercise> allExercises) {
    return FutureBuilder<List<Exercise>>(
        future: serviceEx.getExerciseByProgram(widget.programId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(Translations.of(context).text("error_server")));
          }
          return snapshot.hasData ? buildUI(snapshot.data, allExercises) : Center(child: CircularProgressIndicator());
        });
  }

  Widget buildUI(
      List<Exercise> exercisesByProgram, List<Exercise> allExercises) {
    return allExercises.isEmpty
        ? Center(child: Text(Translations.of(context).text("no_exercise"))) : _listExercise(
            exercisesByProgram, allExercises); //buildListView(exercises);
  }

  Widget _listExercise(
      List<Exercise> exercisesByProgram, List<Exercise> allExercises) {
    if (exercisesByProgram != null &&
        exercisesByProgram.isNotEmpty &&
        _selectExercise == null) {
      _selectExercise =
          exercisesByProgram.map((e) => "${e.id}-${e.name}").toList();
    }

    final items = allExercises
        .map((e) => MultiSelectItem<String>("${e.id}-${e.name}", e.name))
        .toList();

    return Container(
      child: MultiSelectField(
        searchable: true,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        buttonText: "Exercises",
        title: "Exercises",
        initialValue: _selectExercise,
        items: items,
        onConfirm: (results) {
          setState(() {
            _selectExercise = results;
          });
        },
        chipDisplay: MultiSelectChipDisplay(
          items: _selectExercise
              .map((e) => MultiSelectItem<String>(e, e.split("-").last))
              .toList(),
          onTap: (value) {
            setState(() {
              _selectExercise.remove(value);
            });
          },
        ),
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
          hintText: Translations.of(context).text("field_name"),
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
          hintText: Translations.of(context).text("field_description"),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    var urlImage = "http://localhost:4000/" + prog.programImage;

    final photoField = Container(
        height: 200,
        width: 175,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Center(child: Image.network(urlImage)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ));

    var updateBtn = RaisedButton(
      child: Text(Translations.of(context).text("btn_update")),
      color: Colors.green,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          _updateProgram(prog);
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
      child: Text(Translations.of(context).text("btn_cancel")),
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
      return Translations.of(context).text("field_is_empty");
    }
    return null;
  }


  FutureBuilder<Program> buildFutureProgram() {
    return FutureBuilder<Program>(
      future: services.getProgramById(widget.programId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? _buildField(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _updateProgram(Program p) async {
    p.name = _name;
    p.description = _desc;
    p.programImage = _image != null ? _image.path : p.programImage;

    var idExercise = List<String>();

    if(_selectExercise.isNotEmpty){
      _selectExercise.forEach((element) {
        idExercise.add(element.split("-").first);
      });

      p.exercises = idExercise;
    }

    var isValid = await services.updateProgram(p);
    if (isValid) {
      Navigator.pop(context, p);
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
