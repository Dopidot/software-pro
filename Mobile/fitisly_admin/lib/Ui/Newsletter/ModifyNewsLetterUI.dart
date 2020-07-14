// Author : DEYEHE Jean
import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/Newsletter.dart';
import 'package:fitislyadmin/Services/NewsletterService.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Util/Translations.dart';
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
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(Translations.of(context).text("title_news_detail"))),
      body: Form(
        key: _formKey,
        child: _buildFutureNewsletter(),
      ),
    );
  }

  FutureBuilder<Newsletter> _buildFutureNewsletter() {
    return FutureBuilder<Newsletter>(
      future: services.getNewsletterById(widget.newsletterId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? _buildField(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildField(Newsletter newsletter) {

    if(newsletter != null){
      return Center(child: Text(Translations.of(context).text('error_server')));
    }


    final nameField = TextFormField(
      initialValue: newsletter.name,
      validator: _validateField,
      onSaved: (String val) {
        _name = val;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_name"),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    final titleField = TextFormField(
      initialValue: newsletter.title,
      validator: _validateField,
      onSaved: (String val) {
        _title = val;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_title"),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    final bodyField = TextFormField(
      initialValue: newsletter.body,
      validator: _validateField,
      onSaved: (String val) {
        _desc = val;
      },
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: null,
      decoration: InputDecoration(
          hintText:  Translations.of(context).text("field_description"),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    RaisedButton updateBtn = RaisedButton(
      child: Text('Modifier'),
      color: Colors.green,
      onPressed: () {
        _updateNewsletter(newsletter);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );

    RaisedButton cancelBtn = RaisedButton(
      child: Text(Translations.of(context).text("btn_cancel")),
      color: Colors.red,
      onPressed: () {
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );

    var urlImage = ConstApiRoute.baseUrlImage + newsletter.newsletterImage;
    final photoField = Container(
        height: 200,
        width: 175,
        child: GestureDetector(
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: _image == null ? Center(
              child: Image.network(urlImage),
            ): Image.file(_image),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
          onTap: () async {
            final pickedFile = await _picker.getImage(source: ImageSource.gallery);
            setState(() {
              _image = File(pickedFile.path);
            });
          },
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

  void _updateNewsletter(Newsletter nl) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      nl.name = _name;
      nl.title = _title;
      nl.body = _desc;
      nl.newsletterImage = _image != null ? _image.path : _image;

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
  String _validateField(String val) {
    if (val.isEmpty) {
      return Translations.of(context).text("field_is_empty");
    }
    return null;
  }
}


