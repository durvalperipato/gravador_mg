import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gravador_mg/config.dart';
import 'package:gravador_mg/new_config.dart';
import 'package:gravador_mg/variables.dart';
import 'package:process_run/shell.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Gravador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Gravador AKT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final String slot = 'SLOT';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _recording;
  double _percentageLinearIndicator;
  TextEditingController _controllerCP = TextEditingController();
  Map config = {};
  List<Widget> _slotsWidget = [];
  List<Widget> _linearProgressWidget = [];

  @override
  void initState() {
    _recording = false;
    _percentageLinearIndicator = 0;

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewConfig(),
                    ),
                  ),
                  child: Text('Config'),
                ),
                ElevatedButton(
                    onPressed: () => _openFile(),
                    child: Text('Carregar Programa')),
                Flexible(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _controllerCP,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 8,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: containerSlots),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _linearProgressWidget),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: () => _recordDevice(),
                child: Text('GRAVAR'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get containerSlots {
    _slotsWidget.clear();
    _linearProgressWidget.clear();
    if (config.isNotEmpty) {
      config['config'].entries.forEach((element) {
        _slotsWidget.add(
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
                color: element.value['active']
                    ? element.value['color']
                    : Colors.grey[300],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(element.key),
                  Text('PORTA: ' + element.value['port'])
                ],
              ),
            ),
          ),
        );
        _linearProgressWidget.add(
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.maxFinite,
              child: LinearProgressIndicator(
                value: _percentageLinearIndicator,
              ),
            ),
          ),
        );
      });
    }

    return _slotsWidget;
  }

  _openFile() async {
    Directory dir = Directory(
        'C:\\Users\\DURVAL\\Documents\\Flutter Projects\\gravador_mg\\lib');
    String path = await FilesystemPicker.open(
      title: 'Carregar Programa',
      context: context,
      rootDirectory: dir,
      fsType: FilesystemType.file,
      folderIconColor: Colors.teal,
      allowedExtensions: ['.json'],
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    if (path.isNotEmpty) {
      File _file = File(path);
      config = jsonDecode(_file.readAsStringSync());
      String _hex = config['hex'];
      String _ref = config['ref'];
      config['config'].values.forEach((element) {
        element['color'] = Colors.grey[300];
        element['command'] =
            '''efm8load.exe -p ${element['port']} -b 115200 $_hex''';
      });
      _controllerCP.text = _ref;
      setState(() {});
    }
  }

  _recordDevice() async {
    try {
      setState(() {
        _recording = true;
        _percentageLinearIndicator = 0.0;
      });

      try {
        if (config.isNotEmpty) {
          config['config'].values.forEach((element) {
            element['color'] = Colors.yellow;
            /* Shell shell = Shell(
              verbose: false,
            );
            shell.run(element['command']).then((process) {
              process.outLines.forEach((elementProcess) {
                if (elementProcess.contains('?')) {
                  element['color'] = Colors.red;
                  setState(() {});
                } else if (elementProcess.contains('@@@@@@')) {
                  element['color'] = Colors.green;
                  setState(() {});
                }
              });
            }); */
          });
        }

        Timer.periodic(Duration(milliseconds: 10), (timer) {
          if (_percentageLinearIndicator >= 1.0) {
            timer.cancel();
          } else if (_percentageLinearIndicator >= 0 &&
              _percentageLinearIndicator < 0.5) {
            _percentageLinearIndicator += 0.05;
          } else if (_percentageLinearIndicator >= 0.5 &&
              _percentageLinearIndicator < 0.8) {
            _percentageLinearIndicator += 0.001;
          }
          setState(() {});
        });

        Timer(Duration(seconds: 2), () {
          int index = 0;
          config['config'].values.forEach((element) {
            if (index % 2 == 0) {
              element['color'] = Colors.green;
              _percentageLinearIndicator = 1.0;
            }
            index++;
          });
          setState(() {});
        });
        Timer(Duration(seconds: 4), () {
          int index = 0;
          config['config'].values.forEach((element) {
            if (index % 2 != 0) {
              element['color'] = Colors.red;
            }
            index++;
          });
          setState(() {});
        });
      } catch (e) {}
    } /* on ShellException catch (e) {
      
    }  */
     finally {
      setState(() {
        _recording = false;
      });
    }
  }
}
