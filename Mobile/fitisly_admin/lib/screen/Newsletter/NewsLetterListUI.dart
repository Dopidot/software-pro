
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/modele/Newsletter.dart';
import 'package:flutter/material.dart';
import 'CreateNewletterUI.dart';
import 'ModifyNewsLetterUI.dart';



class NewsletterList extends StatefulWidget {
  @override
  State<NewsletterList> createState() {
    return _NewsletterListState();
  }
}

class _NewsletterListState extends State<NewsletterList> {

  Future<List<Newsletter>> futureNl;
  @override
  void initState() {
    super.initState();
    futureNl = services.fetchNewsletters();
  }

  HttpServices services = HttpServices();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Mes newsletters", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
      body: buildFutureNewsletter() ,
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateNewsletter()));
          }
      ),
    );
  }



  FutureBuilder<List<Newsletter>> buildFutureNewsletter() {
    return FutureBuilder<List<Newsletter>>(
      future: futureNl,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot.data);

        } else if (snapshot.hasError) {

          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );

  }


  Widget buildList(List<Newsletter> newsletters ){
    return ListView.builder(
        itemCount: newsletters.length
        , itemBuilder: (context,index) {
      return Dismissible(
        key: Key(newsletters[index].id),
        //confirmDismiss: ,
        background: Container(
          color: Colors.red,
          child: Icon(Icons.cancel),
        ),
        onDismissed: (direction) {
          delete(index,newsletters);
        },
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
          child: Card(
            child: ListTile(
              onTap: () {
                  Navigator.push(context,MaterialPageRoute(
                    builder: (context) {
                      return ModifyNewsletter(newsletterId: newsletters[index].id);
                    })
                )
                    .then((value) {

                    setState(() {
                      newsletters[index] = value;
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Newsletter modifiée ! ")));
                });
              },

              title: Text(newsletters[index].name),
            ),
          ),
        ),
      );
    });
  }


  void delete(var index,List<Newsletter> nl) async {

    var isDelete = await services.deleteNewsletter(nl[index].id);

    if(isDelete){

      setState(() {
        nl.removeAt(index);
      });
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("La newsletter a été supprimé")));

  }

}