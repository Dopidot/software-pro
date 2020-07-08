import 'package:fitislyadmin/modele/Newsletter.dart';
import 'package:flutter/material.dart';

import 'NewsLetterList.dart';

class CreateNewsletter extends StatefulWidget{
  List<Newsletter> newsletters;
  CreateNewsletter({Key key, @required this.newsletters}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return _CreateNewsletter();
  }
}


class _CreateNewsletter extends State<CreateNewsletter>{
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _title = "";
  String _desc = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(centerTitle: true,
          title: Text("Nouvelle newsletter"),),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildField(widget.newsletters),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildField(List<Newsletter> listNewsletter){
    Text titleScreen = Text("Les informations de la newsletter", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,);

    final titleField = TextFormField(
      validator: validateField,
        onSaved: (String val){
          _title = val ;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "Object du mail",
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
        ),
    );


    final descField = TextFormField(
      validator: validateField,
      onSaved: (String val){
        _desc = val ;
      },
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: null,
      decoration: InputDecoration(
          hintText: "Ecrire le contenu du mail ici",
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
         ),
    );


   RaisedButton createBtn = RaisedButton(
     child: Text('Créer'),
     color: Colors.green,
     onPressed: () {
        if (_formKey.currentState.validate()) {
          // If the form is valid, display a Snackbar.
          _formKey.currentState.save();
          Newsletter l = Newsletter(title:_title,body:_desc);

          setState(() {
            listNewsletter.add(l);
          });

          Navigator.pop(context,listNewsletter);


        }else{
          setState (() {
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


    return[
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: <Widget>[

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: titleScreen,
           ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: titleField,
          ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: descField,
           ),Row(
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
       ),
    ];
  }
}


String validateField(String val){
  if(val.isEmpty){
    return "Attention votre champs mot de passe est vide";
  }
  return null;
}