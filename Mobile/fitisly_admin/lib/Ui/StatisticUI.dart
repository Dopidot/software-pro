// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Api_Fitisly/ConnectionGenderFitisly.dart';
import 'package:fitislyadmin/Services/ApiFitisly/ConnectionByGenderService.dart';
import 'package:fitislyadmin/Services/ApiFitisly/StatisticService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import '../model/Api_Fitisly/Statistic.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;



class StatisticUI extends StatefulWidget{
  @override
  State<StatisticUI> createState() {
    return _StatisticUI();
  }
}

class _StatisticUI extends State<StatisticUI> {
  StatisticService _serviceStatisticYear = StatisticService();
  ConnectionByGenderService _serviceConnectionGender = ConnectionByGenderService();
  List<charts.Series> seriesList = List<charts.Series>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(Translations.of(context).text("title_stat")), centerTitle: true),
        body: _buildFutureStatistic()
    );
  }

  FutureBuilder<Statistic> _buildFutureStatistic() {
    return FutureBuilder<Statistic>(
      future: _serviceStatisticYear.getStatisticByAge(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.hasError);
          return Center(child: Text("Une erreur est survenue, veuillez contacter le support si le problème persiste"));
        }
        return snapshot.hasData ? _buildField(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }

  FutureBuilder<List<ConnectionGenderFitisly>> _buildTest() {
    return FutureBuilder<List<ConnectionGenderFitisly>>(
      future: _serviceConnectionGender.getConnectionNumber(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.hasError);
          return Center(child: Text("Une erreur est survenue, veuillez contacter le support si le problème persiste"));
        }
        return snapshot.hasData ? _buildBarChart(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }


  Widget _buildBarChart(List<ConnectionGenderFitisly> connections){

    List<charts.Series<ConnectionGenderFitisly, String>> series = [
      charts.Series(
          id: "Connection",
          data: connections,
          domainFn: (ConnectionGenderFitisly connections, _) => connections.men.toString(),
          measureFn: (ConnectionGenderFitisly connections, _) => connections.women)
    ];


      return charts.BarChart(series, animate: true);
  }





  Widget _buildField(Statistic stat) {

    Map<String, double> dataMap = {
      Translations.of(context).text("legend_more_35"):stat.moreThanThirtyFive.toDouble(),
      Translations.of(context).text("legend_30_35"):stat.thirtyOneToThirtyFive.toDouble(),
      Translations.of(context).text("legend_26_30"):stat.twentySixToThirty.toDouble(),
      Translations.of(context).text("legent_18_25"):stat.eighteenToTwentyFive.toDouble(),
      Translations.of(context).text("legend_less_18"):stat.lessThanEighteen.toDouble()
    };


    return Center(
        child: Column(
           mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(Translations.of(context).text("title_stat_detail"),style: TextStyle(fontSize: 25),),
            ),
            Card(child: PieChart(dataMap: dataMap, showChartValuesInPercentage: true)),
            //Card(child: _buildTest())
          ],
        )
    );
  }


}
