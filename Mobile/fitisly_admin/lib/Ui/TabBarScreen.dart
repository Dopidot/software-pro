
import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  @override
  State<TabBarScreen> createState() {
    return _TabBarScreen();
  }
}

class _TabBarScreen extends State<TabBarScreen> {

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      title: Text("TabBar"),
      bottom: TabBar(tabs: [
        new Tab(icon: new Icon(Icons.call)),
        new Tab(
          icon: new Icon(Icons.chat),
        )
      ] ,
      controller: _tabController)
      ),
      body: Center(child: Text("TabBar")),
    );
  }

}



