import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file/file.dart' as file;
import 'package:file/local.dart' as local;
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gravador_mg/new_config.dart';
import 'package:gravador_mg/variables.dart';

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
      home: MyHomePage(title: 'Gravador MarGirius'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Widget> _slotsWidget = [];
  List<bool> _recording = [];

  TextEditingController _controllerCP = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();

  Map config = {};

  String message = '';

  bool _isRecording;

  FocusNode _recordFocusNode = FocusNode();

  @override
  void initState() {
    _isRecording = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[300],
            Colors.grey[300],
            Colors.grey[200],
            Colors.grey[200],
            Colors.grey[100],
          ],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  {
                    _passwordController.clear();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Container(
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('SENHA'),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: _passwordController,
                                  obscureText: true,
                                  validator: (value) =>
                                      value.compareTo(passwordConfig) == 0
                                          ? null
                                          : 'Senha Incorreta',
                                  onEditingComplete: () => {
                                    if (_formKey.currentState.validate())
                                      {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => NewConfig(),
                                          ),
                                        ),
                                      },
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Voltar'),
                          ),
                          TextButton(
                            onPressed: () => {
                              if (_formKey.currentState.validate())
                                {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NewConfig(),
                                    ),
                                  ),
                                },
                            },
                            child: Text('Confirmar'),
                          ),
                        ],
                      ),
                    );
                  }
                }),
            SizedBox(
              width: 30,
            ),
          ],
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          backgroundColor: Color.fromRGBO(6, 58, 118, 0.9),
        ),
        body: RawKeyboardListener(
          autofocus: true,
          focusNode: _recordFocusNode,
          onKey: (value) {
            if (value.isKeyPressed(LogicalKeyboardKey.enter) &&
                _isRecording == false) {
              _recordDevice();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(10),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[600])),
                          onPressed: () => _openFile(),
                          child: Text(
                            'Carregar Programa',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(-2, -2),
                                  blurRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.white70,
                                  offset: Offset(2, 2),
                                  blurRadius: 2,
                                ),
                              ]),
                          child: Center(
                            child: TextField(
                              readOnly: true,
                              decoration: null,
                              style: TextStyle(
                                letterSpacing: 5,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              controller: _controllerCP,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
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
                SizedBox(
                  height: 80,
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Container(
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10),
                        ),
                        onPressed: _isRecording ? null : () => _recordDevice(),
                        child: _isRecording
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.blue[900],
                              )
                            : Text(
                                'GRAVAR',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 40,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/logo_colorful.jpg',
                    height: 80,
                    width: 200,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get containerSlots {
    _slotsWidget.clear();
    _recording.clear();
    if (config.isNotEmpty) {
      config['config'].entries.forEach((element) {
        _recording.add(false);
        _slotsWidget.add(
          Flexible(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  element.value['active'] = !element.value['active'];
                });
              },
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
                  borderRadius: BorderRadius.circular(20),
                  color: element.value['active']
                      ? element.value['color']
                      : Colors.grey[200],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      element.key,
                      style: TextStyle(
                        color: element.value['active']
                            ? Colors.black
                            : Colors.grey[400],
                        fontSize: config['config'].length > 7 &&
                                config['config'].length < 11
                            ? 15
                            : config['config'].length >= 11
                                ? 10
                                : 30,
                      ),
                    ),
                    Text(
                      'PORTA\n${element.value['port']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: element.value['active']
                            ? Colors.black
                            : Colors.grey[400],
                        fontSize: config['config'].length > 7 &&
                                config['config'].length < 11
                            ? 10
                            : config['config'].length >= 11
                                ? 7
                                : 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }

    return _slotsWidget;
  }

  _openFile() async {
    final file.FileSystem fs = local.LocalFileSystem();

    Directory dir = fs.currentDirectory
        .childDirectory(fs.currentDirectory.path + '\\files');

    String path = await FilesystemPicker.open(
      title: 'Carregar Programa',
      context: context,
      rootDirectory: dir,
      fsType: FilesystemType.file,
      folderIconColor: Colors.teal,
      allowedExtensions: ['.json'],
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    if (path != null) {
      if (path.isNotEmpty) {
        File _file = File(path);
        config = jsonDecode(_file.readAsStringSync());
        String _hex = config['hex'];
        String _ref = config['ref'];
        config['config'].values.forEach((element) {
          element['color'] = Colors.grey[400];

          element['port'] = element['port'];
          element['hex'] = _hex;
        });
        _controllerCP.text = _ref;
        setState(() {});
      }
    }
  }

  _recordDevice() async {
    if (!config['config']
        .values
        .every((element) => element['active'] == false)) {
      setState(() {
        _isRecording = true;
      });
      try {
        if (config.isNotEmpty) {
          int index = 0;
          int length = 0;
          config['config'].values.forEach((element) async {
            if (element['active']) {
              element['color'] = Colors.yellow[200];

              try {
                Process.run(
                  'efm8load.exe',
                  ['-p', '${element['port']}', element['hex']],
                ).then((process) {
                  if (process.exitCode != 0) {
                    _recording[index] = true;
                    index++;
                    element['color'] = Colors.red[200];
                    setState(() {});
                  } else {
                    if (process.stdout.contains('?')) {
                      _recording[index] = true;
                      index++;
                      element['color'] = Colors.red[200];
                      setState(() {});
                    } else if (process.stdout.contains('@@@@@@')) {
                      _recording[index] = true;
                      index++;
                      element['color'] = Colors.green[200];
                      setState(() {});
                    }
                  }
                }, onError: (error) {
                  element['color'] = Colors.red[200];
                  _recording[index] = true;
                  index++;
                  setState(() {});
                }).whenComplete(() {
                  _recording.forEach((element) {
                    if (element) {
                      length += 1;
                      if (length == _recording.length) {
                        setState(() {
                          _isRecording = false;
                        });
                      }
                    }
                  });
                });
              } catch (e) {
                setState(() {
                  _isRecording = false;
                });
              }
            } else {
              _recording[index] = true;
              index++;
              length++;
            }
          });
        }
      } catch (e) {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }
}
