import 'package:fitislyadmin/Services/ApiFitisly/StatisticService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
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
            title: Text(Translations.of(context).text("title_stat")), centerTitle: true),
        body: _buildFutureStatistic()
    );
  }

  FutureBuilder<Statistic> _buildFutureStatistic() {
    return FutureBuilder<Statistic>(
      future: _service.getStatisticByAge(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.hasError);

          return Center(child: Text("Une erreur est survenue, veuillez contacter le support si le problème persiste"));
        }
        return snapshot.hasData ? _buildField(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
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
          ],
        )
    );
  }
   void initData(){



   }

}
