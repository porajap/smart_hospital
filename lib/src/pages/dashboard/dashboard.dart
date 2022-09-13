import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_hospital/src/utils/app_theme.dart';
import 'package:smart_hospital/src/utils/my_widget.dart';

import '../../utils/app_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => Dashboard());
  }
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context: context, title: "Dashboard"),
      body: MyScreen(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTitle(),
              SizedBox(height: 15),
              Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Column(
                    children: [
                      Text("Total Visit", style: Theme.of(context).textTheme.headline1),
                      Text(
                        "Last updated 2.00 PM",
                        style: TextStyle(fontSize: 12, color: AppColor.textPrimaryColor.withOpacity(0.5)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "600",
                        style: TextStyle(
                          fontSize: 36,
                          color: AppColor.textPrimaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Patient(s)",
                        style: TextStyle(fontSize: 12, color: AppColor.textPrimaryColor.withOpacity(0.5)),
                      ),
                      SizedBox(height: 10),
                      Divider(height: 1),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: chart(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chart() {
    return LineChartSample1();
  }
}

class buildTitle extends StatelessWidget {
  const buildTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "แผนกศัลยกรรม",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "โรงพยาบาลทรวงอก",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            children: [
              Text("กันยายน"),
              Text("27/2565"),
            ],
          ),
        )
      ],
    );
  }
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: AppColor.secondaryColor,
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 37),
                Text(
                  'Over all Patient',
                  style: TextStyle(
                    color: AppColor.textPrimaryColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Last updated 30 Nov 2022 3.00 PM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 37),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0, left: 6.0),
                    child: _LineChart(),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: AppColor.primaryColor,
              ),
              onPressed: () {
                setState(() {
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [lineChartBarData2_1, lineChartBarData2_2];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: AppColor.textPrimaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '5';
        break;
      case 5:
        text = '6';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: AppColor.textPrimaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text('SEPT', style: style);
        break;
      case 7:
        text = Text('OCT', style: style);
        break;
      case 12:
        text = Text('DEC', style: style);
        break;
      default:
        text = Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff4af699),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(33, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: AppColor.primaryColor,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: const Color(0x00aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );


  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: false,
        curveSmoothness: 0,
        color: AppColor.errorColor,
        barWidth: 2,
        isStrokeCapRound: false,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: true),
        spots: const [
          FlSpot(1, 0),
          FlSpot(2, 2),
          FlSpot(3, 1.2),
          FlSpot(4, 2),
          FlSpot(5, 2.6),
          FlSpot(9, 1),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: false,
        color: AppColor.primaryColor,
        barWidth: 2,
        isStrokeCapRound: false,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x33aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 2.8),
          FlSpot(3, 1.2),
          FlSpot(4, 2.8),
          FlSpot(5, 2.6),
          FlSpot(9, 3.9),
        ],
      );
}
