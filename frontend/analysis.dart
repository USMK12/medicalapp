import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medicalapp/ip.dart';

class barchart extends StatefulWidget {
  barchart({super.key});
  final Color leftBarColor = Colors.green;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.yellow;
  @override
  State<StatefulWidget> createState() => barchartState();
}

class barchartState extends State<barchart> {
  final double width = 7;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;
  late List<dynamic> patientCount;
  double maxY = 10; // Initial default maxY value

  @override
  void initState() {
    super.initState();
    showingBarGroups = [];
    fetchDataFromPHP();
  }

  // Function to fetch data from PHP backend
  void fetchDataFromPHP() async {
    String url = graphurl;
    var response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      patientCount = json.decode(response.body);

      List<BarChartGroupData> barGroups = [];
      double maxCount = 0;

      for (var data in patientCount) {
        double aliveCount = double.parse(data['alive_count'].toString());
        double deadCount = double.parse(data['dead_count'].toString());

        // Update maxCount to find the highest alive or dead value
        if (aliveCount > maxCount) maxCount = aliveCount;
        if (deadCount > maxCount) maxCount = deadCount;

        final barGroup = makeGroupData(
          patientCount.indexOf(data),
          aliveCount,
          deadCount,
        );
        barGroups.add(barGroup);
      }

      setState(() {
        rawBarGroups = barGroups;
        showingBarGroups = rawBarGroups;

        // Adjust the maximum y-axis value dynamically with some padding
        maxY = (maxCount * 1.2).ceilToDouble(); // Adding 20% padding
      });
    } else {
      print('Failed to load patient data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Analysis',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: appcolor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/7616.jpg', // Replace with your image asset path
              width: double.infinity,
              fit: BoxFit.scaleDown,
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    makeTransactionsIcon(),
                    const Text(
                      'Bar Chart',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          maxY: maxY, // Dynamic maxY value based on data
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (group) => Colors.grey,
                              getTooltipItem: (a, b, c, d) => null,
                            ),
                            touchCallback: (FlTouchEvent event, response) {
                              if (response == null || response.spot == null) {
                                setState(() {
                                  touchedGroupIndex = -1;
                                  showingBarGroups = List.of(rawBarGroups);
                                });
                                return;
                              }
                              touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                              setState(() {
                                if (!event.isInterestedForInteractions) {
                                  touchedGroupIndex = -1;
                                  showingBarGroups = List.of(rawBarGroups);
                                  return;
                                }
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  var sum = 0.0;
                                  for (final rod
                                      in showingBarGroups[touchedGroupIndex].barRods) {
                                    sum += rod.toY;
                                  }
                                  final avg = sum /
                                      showingBarGroups[touchedGroupIndex].barRods.length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex].copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
                                      return rod.copyWith(
                                          toY: avg, color: widget.avgColor);
                                    }).toList(),
                                  );
                                }
                              });
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) =>
                                    bottomTitles(value, meta, patientCount),
                                reservedSize: 42,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: maxY / 5, // Dynamic interval
                                getTitlesWidget: leftTitles,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: showingBarGroups,
                          gridData: const FlGridData(show: false),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to create left axis titles based on values
  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    // Display only whole numbers
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  // Widget to create bottom axis titles based on the score ranges
  Widget bottomTitles(double value, TitleMeta meta, List<dynamic> patientCount) {
    String scoreRange = patientCount[value.toInt()]['score_range'].toString();

    final Widget text = Text(
      scoreRange,
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  // Function to generate bar data for each group (alive and dead counts)
  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  // Icon widget for the header
  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
