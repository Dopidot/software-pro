import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/Newsletter.dart';
import 'package:fitislyadmin/Services/NewsletterService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModifyNewsletter extends StatefulWidget {
  String newsletterId;

  ModifyNewsletter({Key key, @required this.newsletterId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ModifyNewsletter();
  }
}

class _ModifyNewsletter extends State<ModifyNewsletter> {
  NewsletterService services = NewsletterService();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _title;
  String _desc;
  String _name;
  File _image;
  final _picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Ma newsletter")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: buildFutureNewsletter(),
        ),
      ),
    );
  }

  FutureBuilder<Newsletter> buildFutureNewsletter() {
    return FutureBuilder<Newsletter>(
      future: services.getNewsletterById(widget.newsletterId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData
            ? _buildField(snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildField(Newsletter newsletter) {
    Text titleScreen = Text(
      "Les informations de la newsletter",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      textAlign: TextAlign.center,
    );

    final nameField = TextFormField(
      initialValue: newsletter.name,
      validator: validateField,
      onSaved: (String val) {
        _name = val;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Nom de la newsletter",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    final titleField = TextFormField(
      initialValue: newsletter.title,
      validator: validateField,
      onSaved: (String val) {
        _title = val;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Object du mail",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    final bodyField = TextFormField(
      initialValue: newsletter.body,
      validator: validateField,
      onSaved: (String val) {
        _desc = val;
      },
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: null,
      decoration: InputDecoration(
          hintText: "Ecrire le contenu du mail ici",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    RaisedButton updateBtn = RaisedButton(
      child: Text('Modifier'),
      color: Colors.green,
      onPressed: () {
        updateNewsletter(newsletter);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );

    RaisedButton cancelBtn = RaisedButton(
      child: Text('Annuler'),
      color: Colors.red,
      onPressed: () {
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );

    var urlImage = "http://localhost:4000/" + newsletter.newsletterImage;
    final photoField = Container(
        height: 200,
        width: 175,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Center(
            child: Image.network(urlImage),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: titleScreen,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: nameField,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: titleField,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: bodyField,
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

  void updateNewsletter(Newsletter nl) {
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a Snackbar.
      _formKey.currentState.save();

      nl.name = _name;
      nl.title = _title;
      nl.body = _desc;
      nl.newsletterImage = _image != null ? _image.path : nl.newsletterImage;

      services.updateNewsletter(nl)
          .then((value) {
        Navigator.pop(context, nl);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}

String validateField(String val) {
  if (val.isEmpty) {
    return "Attention votre champs mot de passe est vide";
  }
  return null;
}
