import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/Gym.dart';
import 'package:fitislyadmin/Services/GymService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateGymUI extends StatefulWidget{
  @override
  State<UpdateGymUI> createState() {
    return _UpdateGymUI();
  }

}

class _UpdateGymUI extends State<UpdateGymUI>{

  GymService services = GymService();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _address;
  String _name;
  String _zipCode;
  String _country;
  String _city;
  File _image;
  final _picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    final int gymId = ModalRoute.of(context).settings.arguments;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(centerTitle: true,
          title: Text("Ma newsletter")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: buildFutureNewsletter(gymId.toString()),
        ),
      ),
    );
  }



  FutureBuilder<Gym> buildFutureNewsletter(String id) {
    return FutureBuilder<Gym>(
      future: services.getGymById(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildField(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return snapshot.hasData ?  _buildField(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );

  }

  Widget _buildField(Gym gym){
    Text titleScreen = Text("Les informations de la salle", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,);

    final nameField = TextFormField(
      initialValue: gym.name,
      onSaved: (String val){
        _name = val;
      },
      validator: validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: "Nom de la salle",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final addressField = TextFormField(
      initialValue: gym.address,
      onSaved: (String val){
        _address = val;
      },
      validator: validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: "Numéro et rue du lieu de la salle",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final zipCodeField = TextFormField(
      initialValue: gym.zipCode,
      onSaved: (String val){
        _zipCode = val;
      },
      validator: validateField,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: "Code postal",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final cityField = TextFormField(
      initialValue: gym.city,
      onSaved: (String val){
        _city = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Ville",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final countryField = TextFormField(
      initialValue: gym.country,
      onSaved: (String val){
        _country = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Pays",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    var urlImage = "http://localhost:4000/"+gym.gymImage;

    final photoField = Container (
        height: 200,
        width: 175,

        child:Card(
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
        )
    );

    final updateBtn = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: new Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: _updateGym,
          child: Text("Modifier"),
        )
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


    return
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
            child: nameField,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: addressField,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: zipCodeField,
          ), Padding(
            padding: const EdgeInsets.all(8.0),
            child: cityField,
          ), Padding(
            padding: const EdgeInsets.all(8.0),
            child: countryField,
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


  void _updateGym() {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();
      Gym gym = Gym(name: _name,address: _address,zipCode: _zipCode,city: _city,country: _country,gymImage: _image.path);
      Navigator.pop(context,gym);

    } else {
      setState (() {
        _autoValidate = true ;
      });
    }
  }





String validateField(String value){
  if(value.isEmpty){
    return "Attention votre champs est vide";
  }
  return null;
}
}