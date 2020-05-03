import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Accueil"),
            centerTitle: true
        ),
        body: StaggeredGridView.count(
            crossAxisCount: 2,


            children:List.generate(100, (index) {
              return Card(
                child:  InkWell(
                  onTap: (){
                    print("Item $index");
                  },
                  child:  Center(
                    child: Text(
                      'Item $index',
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ),
                margin: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
                elevation: 10.0,
              )
              ;
            }),
            staggeredTiles:[
              StaggeredTile.count(2, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 2),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),

            ]
        )
    );
  }
}