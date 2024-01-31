import 'package:live_manage_dinesoft/system_all_library.dart';

class PaymentChart extends StatefulWidget {
  final List<Map<String, dynamic>> chartData;

  const PaymentChart({
    Key? key,
    required this.chartData,
  }) : super(key: key);

  @override
  State<PaymentChart> createState() => _PaymentChartState();
}

class _PaymentChartState extends State<PaymentChart> {
  bool rebuild = false;

  @override
  Widget build(BuildContext context) {
    if (widget.chartData.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noChartAvailable,
          style: AppTextStyle.titleMedium,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 360,
      height: 300,
      child: Chart(
        rebuild: rebuild,
        data: widget.chartData,
        variables: {
          'genre': Variable(
            accessor: (Map map) => map['genre'] as String,
          ),
          'sold': Variable(
            accessor: (Map map) => map['sold'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        transforms: [
          Sort(
            compare: (tuple1, tuple2) => tuple1['sold'] - tuple2['sold'],
          ),
        ],
        marks: [
          IntervalMark(
            transition: Transition(
              duration: const Duration(
                seconds: 1,
              ), // Adjust transition duration
              curve: Curves.easeInOut, // Adjust transition curve
            ),
            entrance: {MarkEntrance.y},
            label: LabelEncode(
              encoder: (tuple) => Label(tuple['sold'].toString()),
            ),
            tag: (tuple) => tuple['genre'].toString(),
          ),
        ],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
      ),
    );
  }

  void updateChartData(List<Map<String, dynamic>> newChartData) {
    setState(() {
      widget.chartData.clear();
      widget.chartData.addAll(newChartData);
      rebuild = !rebuild;
    });
  }
}
