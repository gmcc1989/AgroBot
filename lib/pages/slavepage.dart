import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

// Próximo passo: corrigir o erro que quando não tem slave, não entra na pagia de adiconar outro slave

class SlavePage extends StatefulWidget {
  final String slaveserialnumber, slaveapelido, masterserialnumber;

  SlavePage(
      {Key key,
      @required this.slaveserialnumber,
      @required this.slaveapelido,
      @required this.masterserialnumber})
      : super(key: key);
  @override
  _SlavePageState createState() => _SlavePageState();
}

class _SlavePageState extends State<SlavePage>
    with SingleTickerProviderStateMixin {
  List<Data> chartdata = [];
  ZoomPanBehavior _zoomPanBehavior;
  TooltipBehavior _tooltipBehavior;
  TabController _tabController;
  //DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    // para ver o retangulo vermelho:botão do meio pressionado um segundo, botão esquerde e mexer
    _zoomPanBehavior = ZoomPanBehavior(
        enableSelectionZooming: true,
        // movimentar no zoom: panning
        selectionRectBorderColor: Colors.red,
        selectionRectBorderWidth: 1,
        selectionRectColor: Colors.grey);
    _tooltipBehavior =
        TooltipBehavior(enable: true, tooltipPosition: TooltipPosition.pointer);
    readData();
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.slaveapelido),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          labelStyle: TextStyle(fontSize: 24.0),
          // for selected
          indicatorWeight: 5.0,
          tabs: [
            new Tab(
              text: 'T20',
            ),
            new Tab(
              text: 'T40',
            ),
            new Tab(
              text: 'Vin',
            )
          ],
          controller: _tabController,
        ),
      ),
      body: Column(children: <Widget>[
        ElevatedButton(
          child: Text('Read Data'),
          onPressed: () {
            readData();
          },
        ),
        ElevatedButton(
          onPressed: () {
            _zoomPanBehavior.reset();
          },
          child: Text('Reset Zoom Level'),
        ),
        Expanded(
          child: SfCartesianChart(
            zoomPanBehavior: _zoomPanBehavior,
            tooltipBehavior: _tooltipBehavior,
            enableAxisAnimation: true,
            primaryYAxis: NumericAxis(
                // '°C' will be append to all the labels in Y axis
                labelFormat: '{value}kPa'),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.yMd().add_jm(),
              //intervalType: DateTimeIntervalType.days,
              labelRotation: 30,
              //interval: 0.1,
            ),
            series: <LineSeries<Data, DateTime>>[
              LineSeries<Data, DateTime>(
                  enableTooltip: true,
                  dataSource: chartdata,
                  markerSettings: MarkerSettings(isVisible: true),
                  /*trendlines: <Trendline>[
                    Trendline(
                        type: TrendlineType.polynomial, color: Colors.blue)
                  ],*/
                  xValueMapper: (Data sales, _) => sales.x,
                  yValueMapper: (Data sales, _) => sales.y),
            ],
          ),
        )
      ]),
    );
  }

// Essa funcao pega todos os dados da base de dados e joga no console
// proximos passos:
// 1.colocar dados de timestamp no firebase
// 2.trazer esses valores de timestamp para o flutter
// 3.converter o timestamp para DateTime do Dart
// 4. pegar os valores do sensor e o DateTime do dart e colocar em Data(x: DateTime(2006, 01, 01), y: 2.3), chartdata.add(Data(value['VoltageIn'], value['Sensor40']));
// 1.colocar dados de timestamp no firebase
// 1.colocar dados de timestamp no firebase

  void readData() {
    User currentUser = FirebaseAuth.instance.currentUser;
    String path = currentUser.uid +
        "/userProducts/" +
        widget.masterserialnumber +
        "/slaves/" +
        widget.slaveserialnumber +
        "/data";
    final databaseReference = FirebaseDatabase.instance.reference().child(path);
    chartdata.clear();
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> dados = snapshot.value;
      dados.forEach((key, value) {
        print("entrei no loop");
        print(key);
        print(value);
        // conversao do int que esta no firebase para datetime do flutter
        var dateToTimeStamp =
            DateTime.fromMillisecondsSinceEpoch(value['timestamp'] * 1000);
        //print(dateToTimeStamp);
        chartdata.add(Data(dateToTimeStamp, value['t20'].toDouble()));
      });

      // atualiza o gráfico
      setState(() {
        // orderna os dados pela data antes de plotar
        chartdata.sort((a, b) => a.x.compareTo(b.x));
      });
    });
  }
}

class Data {
  Data(this.x, this.y);
  final DateTime x;
  final double y;
}
