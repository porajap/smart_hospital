import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_hospital/src/model/dashboard/data_of_day_model.dart';
import 'package:smart_hospital/src/model/dashboard/data_of_year_model.dart';
import 'package:smart_hospital/src/utils/app_theme.dart';
import 'package:smart_hospital/src/utils/my_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../model/dashboard/data_of_year_model.dart';
import '../../services/dashboard_service.dart';
import '../../utils/app_bar.dart';
import '../../utils/my_dialog.dart';
import '../login/login_page.dart';
import '../my_app.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => Dashboard());
  }
}

class DataSourceOfYear {
  DataSourceOfYear({required this.month, required this.total, required this.monthName});

  final String month;
  final String monthName;
  final int total;
}

class _DashboardState extends State<Dashboard> {
  DashboardService dashboardService = DashboardService();
  DataOfYearModel dataOfYear = DataOfYearModel();
  DataOfDayModel dataOfDay = DataOfDayModel();

  List<DataSourceOfYear> menData = [];
  List<DataSourceOfYear> femaleData = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async{
    await getDataOfDay();
    await getDataOfYear();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getDataOfDay() async{
    dataOfDay = await dashboardService.getDataOfDay();
  }

  Future<void> getDataOfYear() async {
    dataOfYear = await dashboardService.getDataOfYear();

    if (dataOfYear.data?.men != null) {
      var _data = dataOfYear.data?.men ?? [];
      for (var item in _data) {
        var _total = item.total ?? 0;
        menData.add(DataSourceOfYear(
          month: '${item.month}',
          total: _total as int,
          monthName: '${item.monthName}',
        ));
      }
    }

    if (dataOfYear.data?.female != null) {
      var _data = dataOfYear.data?.female ?? [];
      for (var item in _data) {
        var _total = item.total ?? 0;
        femaleData.add(DataSourceOfYear(
          month: '${item.month}',
          total: _total as int,
          monthName: '${item.monthName}',
        ));
      }
    }

  }

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
                context.read<AuthBloc>().add(AuthEventLoggedOut());
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

  Widget buildTotalVisit() {
    var _total = dataOfDay.data?.countPatient ?? 0;
    var _lastUpdate = dataOfDay.data?.lastUpdated ?? "";

    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Column(
          children: [
            Text("Total Visit", style: Theme.of(context).textTheme.headline1),
            Text(
              "Last updated $_lastUpdate",
              style: TextStyle(fontSize: 12, color: AppColor.textPrimaryColor.withOpacity(0.5)),
            ),
            SizedBox(height: 20),
            Text(
              "$_total",
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
            Visibility(
              visible: true,
              child: Column(
                children: [
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
          ],
        ),
      ),
    );
  }

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
      primaryXAxis: _categoryAxis(),
      primaryYAxis: _numericAxis(text: 'คน'),
      series: _getDefaultLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  NumericAxis _numericAxis({required String text}) => NumericAxis(
        title: AxisTitle(
          text: '$text',
        ),
      );

  CategoryAxis _categoryAxis() => CategoryAxis(
        labelRotation: 0,
      );

  List<LineSeries<DataSourceOfYear, String>> _getDefaultLineSeries() {
    return [
      LineSeries<DataSourceOfYear, String>(
        animationDuration: 2500,
        dataSource: menData,
        width: 2,
        name: 'ชาย',
        xValueMapper: (DataSourceOfYear data, _) => data.monthName,
        yValueMapper: (DataSourceOfYear data, _) => data.total,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<DataSourceOfYear, String>(
        animationDuration: 2500,
        dataSource: femaleData,
        width: 2,
        name: 'หญิง',
        xValueMapper: (DataSourceOfYear data, _) => data.monthName,
        yValueMapper: (DataSourceOfYear data, _) => data.total,
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
