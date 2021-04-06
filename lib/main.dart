import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gravador_mg/new_config.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:process_run/shell.dart';
import 'package:file/file.dart' as file;
import 'package:file/local.dart' as local;

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
        fontFamily: 'Roboto',
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<double> _percentageLinearIndicator = [];
  TextEditingController _controllerCP = TextEditingController();
  Map config = {};
  List<Widget> _slotsWidget = [];
  List<Widget> _linearProgressWidget = [];
  String message = '';
  bool _isRecording;
  FocusNode _recordFocusNode = FocusNode();

  @override
  void initState() {
    _isRecording = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: _recordFocusNode,
        onKey: (value) {
          if (value.data.logicalKey.debugName == "Enter" &&
              _isRecording == false) {
            _isRecording = true;
            _recordDevice();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
                      child: Text('Configuração'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () => _openFile(),
                        child: Text('Carregar Programa')),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        controller: _controllerCP,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                flex: 3,
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
                    onPressed: () => {
                      null,
                    }, //_recordDevice(),
                    child: Text('GRAVAR'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get containerSlots {
    _slotsWidget.clear();
    _linearProgressWidget.clear();
    if (config.isNotEmpty) {
      int index = 0;
      config['config'].entries.forEach((element) {
        _slotsWidget.add(
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.maxFinite,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(2, 2),
                      color: Colors.black87,
                      blurRadius: 2),
                  BoxShadow(
                      offset: Offset(-2, -2),
                      color: Colors.white,
                      blurRadius: 2),
                ],
                //border: Border.all(),
                borderRadius: BorderRadius.circular(20),
                color: element.value['active']
                    ? element.value['color']
                    : Colors.grey[300],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(element.key),
                  Text('PORTA: ' + element.value['port']),
                  Text(message),
                ],
              ),
            ),
          ),
        );
        _percentageLinearIndicator.add(0.0);

        _linearProgressWidget.add(
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.maxFinite,
              child: LinearProgressIndicator(
                minHeight: 10,
                value: _percentageLinearIndicator[index],
              ),
            ),
          ),
        );
        index++;
      });
    }

    return _slotsWidget;
  }

  _openFile() async {
    final file.FileSystem fs = local.LocalFileSystem();

    Directory dir =
        fs.currentDirectory.childDirectory(fs.currentDirectory.path + '\\lib');

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
        _percentageLinearIndicator.forEach((element) {
          _percentageLinearIndicator[
              _percentageLinearIndicator.indexOf(element)] = 0.0;
        });
      });

      try {
        if (config.isNotEmpty) {
          config['config'].values.forEach((element) {
            element['color'] = Colors.yellow[200];
            Shell shell = Shell(
              verbose: false,
            );
            shell.run('cmd.exe' /* element['command'] */).then((process) {
              process.outLines.forEach((elementProcess) {
                if (elementProcess.contains('?')) {
                  element['color'] = Colors.red[200];
                  setState(() {});
                } else if (elementProcess.contains('@@@@@@')) {
                  element['color'] = Colors.green[200];
                  setState(() {});
                }
              });
            });
          });
        }

        /* Timer.periodic(Duration(milliseconds: 200), (timer) {
          for (int index = 0;
              index < _percentageLinearIndicator.length;
              index++) {
            if (_percentageLinearIndicator[index] >= 1.0) {
              timer.cancel();
            } else if (_percentageLinearIndicator[index] >= 0 &&
                _percentageLinearIndicator[index] < 0.5) {
              _percentageLinearIndicator[index] += 0.05;
            } else if (_percentageLinearIndicator[index] >= 0.5 &&
                _percentageLinearIndicator[index] < 1.0) {
              _percentageLinearIndicator[index] += 0.001;
            }
          }
          setState(() {});
        }); */
      } catch (e) {}
    } catch (e) {} finally {
      setState(() {
        _isRecording = false;
      });
    }
  }
}
