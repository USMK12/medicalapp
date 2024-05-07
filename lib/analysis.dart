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
  late List<dynamic> patientCount; // Declare patientCount here

  @override
  void initState() {
    super.initState();
    // Call the function to fetch data from PHP script
    showingBarGroups = [];
    fetchDataFromPHP();
  }

  // Function to fetch data from PHP script
  void fetchDataFromPHP() async {
    // Define the URL of your PHP script
    String url = graphurl;

    // Make a POST request to the PHP script
    var response = await http.post(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      patientCount = json.decode(response.body);

      // Prepare bar groups using fetched data
      List<BarChartGroupData> barGroups = [];
      for (var data in patientCount) {
        final barGroup = makeGroupData(
          patientCount.indexOf(data) as int,
          double.parse(data['alive_count'].toString()),
          double.parse(data['dead_count'].toString()),
        );
        barGroups.add(barGroup);
      }

      setState(() {
        rawBarGroups = barGroups;
        showingBarGroups = rawBarGroups;
      });
    } else {
      // Print an error message if the request fails
      print('Failed to load patient data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color : Colors.white,
        ),
        title: Text(
          'Home Page',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: appcolor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/7616.jpg', // Replace 'your_image_asset.png' with your image asset path
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
                          maxY: 10,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: ((group) {
                                return Colors.grey;
                              }),
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
                                      showingBarGroups[touchedGroupIndex]
                                          .barRods
                                          .length;
            
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
                                interval: 1,
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

  Widget leftTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xff7589a2),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  // Adjust the interval to increase the distance between values
  int displayValue = value.toInt() + 1; // Add 1 to start from 1 instead of 0
  
  if (displayValue > 10) {
    // Return an empty container for values greater than 10
    return Container();
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 5,
    child: Text(displayValue.toString(), style: style),
  );
}




  Widget bottomTitles(double value, TitleMeta meta, List<dynamic> patientCount) {
    // Modify this method to display the score values
    // Assuming 'value' represents the index of the score in the list
    // 'patientCount', you can use this index to fetch the corresponding
    // score value.
    // Replace 'patientCount' with your actual list name.
    String scoreValue = patientCount[value.toInt()]['score'].toString();

    final Widget text = Text(
      scoreValue,
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

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
