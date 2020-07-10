import 'package:fitislyadmin/Model/Fitisly_Admin/Newsletter.dart';
import 'package:fitislyadmin/Services/NewsletterService.dart';
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

  NewsletterService services = NewsletterService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Newsletter>> futureNl;

  @override
  void initState() {
    super.initState();
   //futureNl = services.fetchNewsletters();
  }




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
              MaterialPageRoute(builder: (context) => CreateNewsletter()))
            .then((value) {
              if(value != null){
                updateUiAfterCreation();
              }
            });
          }
      ),
    );
  }



  FutureBuilder<List<Newsletter>> buildFutureNewsletter() {
    return FutureBuilder<List<Newsletter>>(
      future: services.fetchNewsletters(),
      builder: (context, snapshot) {
       if (snapshot.hasError) {

          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? buildList(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );

  }


  Widget buildList(List<Newsletter> newsletters ){
    return newsletters.isEmpty ? Center(child: Text("Aucune news, veuillez en ajouter svp")) : initListView(newsletters);
  }


  Widget initListView(List<Newsletter> newsletters){
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

                  if(value != null){
                    setState(() {
                      newsletters[index] = value;
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Newsletter modifiée ! ")));
                  }
                });
              },
              title: Text(newsletters[index].name),
            ),
          ),
        ),
      );
    });
  }


  void updateUiAfterCreation() async {
    setState(() {
      buildFutureNewsletter();
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