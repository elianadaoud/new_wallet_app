import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Wallet extends StatelessWidget {
  final double income;
  final double outcome;
  final Map<String, double>? pieMap;
  final Color theme;

  const Wallet(
      {Key? key,
      required this.income,
      required this.outcome,
      this.pieMap,
      required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme,
          ),
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account balance ${income - outcome}JD',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' Income \n $income JD',
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    if (pieMap != null && pieMap!.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: PieChart(
                            chartLegendSpacing: 10,
                            chartType: ChartType.disc,
                            chartRadius: 60,
                            dataMap: pieMap!,
                            chartValuesOptions: const ChartValuesOptions(
                                showChartValues: false),
                            legendOptions: const LegendOptions(
                              legendTextStyle: TextStyle(fontSize: 8),
                              legendPosition: LegendPosition.bottom,
                              showLegendsInRow: true,
                            ),
                          ),
                        ),
                      ),
                    Text(
                      ' Outcome \n $outcome JD',
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
