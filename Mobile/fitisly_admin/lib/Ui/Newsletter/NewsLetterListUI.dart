// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Fitisly_Admin/Newsletter.dart';
import 'package:fitislyadmin/Services/NewsletterService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Translations.of(context).text("title_application_news"),
            style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _updateUI();
            },
          ),

        ],
      ),
      body: _buildFutureNewsletter(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateNewsletter()))
                .then((value) {
              if (value != null) {
                _updateUI();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("add_exercise"))));
              }
            });
          }
      ),
    );
  }


  FutureBuilder<List<Newsletter>> _buildFutureNewsletter() {
    return FutureBuilder<List<Newsletter>>(
      future: services.fetchNewsletters(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? _buildList(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }


  Widget _buildList(List<Newsletter> newsletters) {
    return newsletters.isEmpty ? Center(
        child: Text(Translations.of(context).text("no_news"))) : _initListView(newsletters);
  }


  Widget _initListView(List<Newsletter> newsletters) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: newsletters.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Dismissible(
                      key: Key(newsletters[index].id),
                      //confirmDismiss: ,
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.cancel),
                      ),
                      onDismissed: (direction) {
                        _delete(index, newsletters);
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 4.0),
                        child: Card(
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return ModifyNewsletter(newsletterId: newsletters[index].id);
                                  })
                              )
                                  .then((value) {
                                if (value != null) {
                                  _updateUI();

                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(content: Text(Translations.of(context).text("update_news"))));
                                }
                              });
                            },
                            title: Text(newsletters[index].name),
                          ),
                        ),
                      )
                  ),
                ),
              )
          );
        },
      ),
    );
  }

  void _updateUI() async {
    setState(() {
      _buildFutureNewsletter();
    });
  }


  void _delete(var index, List<Newsletter> nl) async {
    var isDelete = await services.deleteNewsletter(nl[index].id);

    if (isDelete) {
      setState(() {
        nl.removeAt(index);
      });
    }
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(Translations.of(context).text("delete_news"))));
  }
}