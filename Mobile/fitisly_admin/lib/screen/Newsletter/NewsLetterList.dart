import 'package:fitislyadmin/modele/Newsletter.dart';
import 'package:flutter/material.dart';

import 'CreateNewletter.dart';



class NewsletterList extends StatefulWidget {
  @override
  State<NewsletterList> createState() {
    return _NewsletterListState();
  }
}

class _NewsletterListState extends State<NewsletterList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Newsletter> newsletters = [
    Newsletter(id : '1',title:'Nouvel arrivant',body:'Test',creationDate: null,isSent: false),
    Newsletter(id : '2',title:'Test',body:'test',creationDate: null,isSent: false),
    Newsletter(id : '3',title:'Bob',body:'test',creationDate: null,isSent: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Mes newsletters", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: newsletters.length
          , itemBuilder: (context,index) {
            return Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
              child: Card(
                child: ListTile(

                  onTap: () {
                    /*showDialog(context: context, builder: (context)
                  => _dialogBuilder(context, contacts[index]))*/
                    print("tap");
                  },

                  title: Text(newsletters[index].title),
                ),
              ),
            );
      }),
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: () {

            Navigator.push(context,MaterialPageRoute(
                builder: (context) {
              return CreateNewsletter(newsletters: newsletters);
            })

            )
            .then((value) {
              setState(() {
                newsletters = value;
              });
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Newsletter créée ! ")));

            });
          }
      ),
    );
  }
}