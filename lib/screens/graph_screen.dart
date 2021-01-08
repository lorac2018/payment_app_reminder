import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/payments.dart';
import '../models/payment.dart';

class ChartScreen extends StatefulWidget {
  static const routeName = '/charts';

  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  //Chart Pie with  namePayment and Amount
  List<charts.Series<Payment, String>> _seriesPieData;

  // Chart Bar with DateTime and Amount
  List<charts.Series<Payment, String>> _seriesBarData;
  List<charts.Series<Payment, String>> _seriesBarYearData;

  //Bar Line
  List<charts.Series<Payment, DateTime>> _seriesLineData;

  List<Payment> payments;

  _generateData(payments) {
    _seriesPieData = List<charts.Series<Payment, String>>();
    _seriesPieData.add(charts.Series(
      domainFn: (Payment payment, _) => payment.namePayment,
      measureFn: (Payment payment, _) => payment.amount,
      id: "payments",
      data: payments,
      labelAccessorFn: (Payment row, _) => "${row.amount}",
    ));

    _seriesBarData = List<charts.Series<Payment, String>>();
    _seriesBarData.add(charts.Series(
      domainFn: (Payment payment, _) => payment.date.month.toString(),
      measureFn: (Payment payment, _) => payment.amount,
      id: "payments",
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      data: payments,
    ));

    _seriesBarYearData = List<charts.Series<Payment, String>>();
    _seriesBarYearData.add(charts.Series(
      domainFn: (Payment payment, _) => payment.date.year.toString(),
      measureFn: (Payment payment, _) => payment.amount,
      id: "payments",
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      data: payments,
    ));

    _seriesLineData = List<charts.Series<Payment, DateTime>>();
    _seriesLineData.add(charts.Series(
      domainFn: (Payment payment, _) => payment.date,
      measureFn: (Payment payment, _) => payment.amount,
      id: "payments",
      data: payments,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (!userSnapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            var payment = Provider.of<Payments>(context, listen: false);
            print(payment);

            return _buildChart(context, payment.itemsPayments);
          }
        });
  }

  Widget _buildChart(BuildContext context, List<Payment> payment) {
    payments = payment;
    _generateData(payments);
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                bottom: TabBar(
                  indicatorColor: Theme.of(context).backgroundColor,
                  tabs: [
                    Tab(
                      icon: Icon(FontAwesomeIcons.chartPie),
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.solidChartBar),
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.chartBar),
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.chartLine),
                    ),
                  ],
                ),
                automaticallyImplyLeading: true,
              ),
              body: TabBarView(children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    margin: EdgeInsets.all(25),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Text('Historic'),
                          Expanded(
                            child: charts.PieChart(_seriesPieData,
                                animate: true,
                                animationDuration: Duration(seconds: 2),
                                behaviors: [
                                  new charts.DatumLegend(
                                      outsideJustification: charts
                                          .OutsideJustification.startDrawArea,
                                      horizontalFirst: false,
                                      desiredMaxRows: 4,
                                      cellPadding:
                                          EdgeInsets.only(right: 5, bottom: 5),
                                      legendDefaultMeasure: charts
                                          .LegendDefaultMeasure.firstValue,
                                      entryTextStyle: charts.TextStyleSpec(
                                        color: charts
                                            .MaterialPalette.blue.shadeDefault,
                                        fontFamily: "Quicksand",
                                        fontSize: 13,
                                      ))
                                ],
                                defaultRenderer: new charts.ArcRendererConfig(
                                    arcWidth: 100,
                                    arcRendererDecorators: [
                                      new charts.ArcLabelDecorator()
                                    ])),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: charts.BarChart(
                              _seriesBarData,
                              animate: true,
                              animationDuration: Duration(seconds: 5),
                            ),
                          )
                        ],
                        mainAxisSize: MainAxisSize.max,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: charts.BarChart(
                              _seriesBarYearData,
                              animate: true,
                              animationDuration: Duration(seconds: 5),
                            ),
                          )
                        ],
                        mainAxisSize: MainAxisSize.max,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                              child: charts.TimeSeriesChart(_seriesLineData,
                                  animate: true,
                                  animationDuration: Duration(seconds: 2),
                                  domainAxis: charts.EndPointsTimeAxisSpec())),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            )));
  }
}
