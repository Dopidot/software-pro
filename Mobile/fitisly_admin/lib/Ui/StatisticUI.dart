import 'package:fitislyadmin/Services/ApiFitisly/StatisticService.dart';
import 'package:flutter/material.dart';
import '../model/Api_Fitisly/Statistic.dart';
import 'package:pie_chart/pie_chart.dart';


class StatisticUI extends StatefulWidget{
  @override
  State<StatisticUI> createState() {
    return _StatisticUI();
  }
}

class _StatisticUI extends State<StatisticUI> {
  StatisticService _service = StatisticService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Statistiques"), centerTitle: true),
        body: _buildFutureStatistic()
    );
  }

  FutureBuilder<Statistic> _buildFutureStatistic() {
    return FutureBuilder<Statistic>(
      future: _service.getStatisticByAge(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? _buildField(snapshot.data) : Center(
            child: CircularProgressIndicator());
      },
    );
  }


  Widget _buildField(Statistic stat) {

    Map<String, double> dataMap = {
      "Plus de 35 ans":stat.moreThanThirtyFive.toDouble(),
      "De 30 à 35 ans":stat.thirtyOneToThirtyFive.toDouble(),
      "De 26 à 30 ans":stat.twentySixToThirty.toDouble(),
      "De 18 à 25 ans":stat.eighteenToTwentyFive.toDouble(),
      "Moins de 18 ans":stat.lessThanEighteen.toDouble()
    };


    return Center(
        child: PieChart(dataMap: dataMap,
          showChartValuesInPercentage: true,
        )
    );
  }
   void initData(){



   }

}
