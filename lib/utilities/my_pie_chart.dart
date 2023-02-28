import 'package:dresssew/utilities/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class PieChartSample2 extends StatefulWidget {
//   const PieChartSample2({super.key});
//
//   @override
//   State<StatefulWidget> createState() => PieChart2State();
// }
//
// class PieChart2State extends State {
//   int touchedIndex = -1;
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: Column(
//         children: [
//           Flexible(
//             child: PieChart(
//               PieChartData(
//                 sectionsSpace: 0,
//                 centerSpaceRadius: 0,
//
//                 sections: showingSections(),
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const <Widget>[
//               Indicator(
//                 color: Colors.blue,
//                 text: 'On-time Delivery',
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Indicator(
//                 color: Colors.yellow,
//                 text: 'Second',
//               ),
//             ],
//           ),
//           const SizedBox(
//             width: 28,
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<PieChartSectionData> showingSections() {
//     return List.generate(2, (i) {
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: Colors.blue,
//             value: 80,
//             title: '',
//             titleStyle: kInputStyle.copyWith(color: Colors.white),
//           );
//         case 1:
//           return PieChartSectionData(
//             color: Colors.red,
//             value: 20,
//             title: '',
//             titleStyle: kInputStyle.copyWith(color: Colors.white),
//           );
//         default:
//           throw Error();
//       }
//     });
//   }
// }
//
// class Indicator extends StatelessWidget {
//   const Indicator({
//     super.key,
//     required this.color,
//     required this.text,
//     this.size = 16,
//   });
//   final Color color;
//   final String text;
//   final double size;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color,
//           ),
//         ),
//         const SizedBox(
//           width: 4,
//         ),
//         Text(
//           text,
//           style: kInputStyle.copyWith(
//             fontSize: size,
//             locale: context.locale,
//           ),
//         )
//       ],
//     );
//   }
// }

class MyPieChart extends StatelessWidget {
  final Color bgColor;
  final String title;
  final double chartValue;
  final bool isRatingChart;

  const MyPieChart(
      {Key? key,
      this.bgColor = Colors.white,
      required this.title,
      this.isRatingChart = false,
      required this.chartValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.1,
            backgroundColor: isRatingChart && chartValue == 0
                ? Colors.blue
                : isRatingChart
                    ? chartValue <= 3
                        ? Colors.red
                        : Colors.blue
                    : !isRatingChart && chartValue <= 75
                        ? Colors.red
                        : Colors.blue,
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.1 - 2,
              backgroundColor: isRatingChart && chartValue == 0
                  ? Colors.grey.shade200
                  : bgColor,
              child: Text(
                isRatingChart && chartValue == 0
                    ? 'Not rated yet.'
                    : '${isRatingChart ? chartValue : chartValue.toInt()}${isRatingChart ? '' : '%'}',
                style: kInputStyle.copyWith(
                  fontSize: isRatingChart && chartValue == 0
                      ? MediaQuery.of(context).size.width * 0.03
                      : MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            title,
            style: kInputStyle.copyWith(fontSize: 15),
            textAlign: TextAlign.center,
          ).tr(),
        ],
      ),
    );
  }
}
