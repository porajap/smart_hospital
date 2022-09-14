import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_hospital/src/utils/app_theme.dart';
import 'package:smart_hospital/src/utils/my_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../utils/app_bar.dart';
import '../../utils/my_dialog.dart';
import '../login/login_page.dart';

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
      appBar: MyAppBar(
        context: context,
        title: "Smart Hospital - Dashboard",
        action: AppBarAction(
          onPressed: () {
            MyDialog.dialogConfirm(
              context: context,
              callback: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  ModalRoute.withName('/login'),
                );
              },
              title: "ออกจากระบบ",
              msg: 'คุณต้องการออกจากระบบใช่หรือไม่?',
            );
          },
          icon: Icon(Icons.logout),
        ),
      ),
      body: MyScreen(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTitle(),
              SizedBox(height: 15),
              buildTotalVisit(),
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
    return Card(
      child: _buildDefaultLineChart(),
    );
  }

  Widget buildTotalVisit() => Card(
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: _buildRangePointerExampleGauge(),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Appointment",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.textPrimaryColor,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "450",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.textPrimaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Patient(s)",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColor.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 20,
                      thickness: 1,
                      indent: 20,
                      endIndent: 0,
                      color: Colors.red,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Walk in",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textPrimaryColor,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "150",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textPrimaryColor,
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Patient(s)",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColor.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  SfRadialGauge _buildRangePointerExampleGauge() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showLabels: false,
          showTicks: false,
          startAngle: 270,
          endAngle: 270,
          radiusFactor: 0.8,
          maximum: 500,
          axisLineStyle: AxisLineStyle(thicknessUnit: GaugeSizeUnit.logicalPixel, thickness: 0.15),
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 100,
                widget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '500',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
          ],
          pointers: <GaugePointer>[
            RangePointer(
              value: 450,
              enableAnimation: false,
              animationDuration: 1200,
              sizeUnit: GaugeSizeUnit.factor,
              color: AppColor.primaryColor,
              width: 0.1,
            ),
          ],
        ),
      ],
    );
  }

  List<_ChartData> chartDataMen = <_ChartData>[
    _ChartData((DateTime(2022, 6)), 568),
    _ChartData((DateTime(2022, 7)), 787),
    _ChartData((DateTime(2022, 8)), 867),
    _ChartData((DateTime(2022, 9)), 898),
    _ChartData((DateTime(2022, 10)), 450),
  ];

  List<_ChartData> chartDataWomen = <_ChartData>[
    _ChartData((DateTime(2022, 6)), 550),
    _ChartData((DateTime(2022, 7)), 766),
    _ChartData((DateTime(2022, 8)), 879),
    _ChartData((DateTime(2022, 9)), 246),
    _ChartData((DateTime(2022, 10)), 159),
  ];

  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(
        isVisible: true,
        alignment: ChartAlignment.center,
        isResponsive: true,
        position: LegendPosition.bottom,
      ),
      title: ChartTitle(text: 'Over all Patients of Month 2022'),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat.MMM(),
        intervalType: DateTimeIntervalType.months,
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
        interval: 100,
        majorGridLines: MajorGridLines(color: Colors.transparent),
      ),
      series: _getDefaultLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<_ChartData, DateTime>> _getDefaultLineSeries() {
    return [
      LineSeries<_ChartData, DateTime>(
        animationDuration: 2500,
        dataSource: chartDataMen,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
        name: 'ชาย',
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<_ChartData, DateTime>(
        animationDuration: 2500,
        dataSource: chartDataWomen!,
        width: 2,
        name: 'หญิง',
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        markerSettings: MarkerSettings(isVisible: true),
      )
    ];
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
              Text(
                "Nov",
                style: TextStyle(color: AppColor.whiteColor),
              ),
              Text(
                "27/2565",
                style: TextStyle(color: AppColor.whiteColor),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ChartData {
  _ChartData(
    this.x,
    this.y,
  );

  final DateTime x;
  final double y;
}
