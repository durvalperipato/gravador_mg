import 'dart:convert';
import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:gravador_mg/model/config.dart';
import 'package:gravador_mg/utils/variables_functions.dart';
import 'package:gravador_mg/viewmodel/home_page_modelview.dart';
import 'package:gravador_mg/viewmodel/new_config_modelview.dart';
import 'package:provider/provider.dart';

class NewConfig extends StatefulWidget {
  @override
  _NewConfigState createState() => _NewConfigState();
}

class _NewConfigState extends State<NewConfig> {
  TextEditingController _lengthSlots = TextEditingController();
  TextEditingController _reference = TextEditingController();
  TextEditingController _hexFile = TextEditingController();
  TextEditingController _program = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> slots = {};

  @override
  void initState() {
    _lengthSlots = TextEditingController(text: '0');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewConfigViewModel>(
      builder: (context, newConfigViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst)),
            title: Text('Nova Configuração'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 6,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Container(
                                  height: 30,
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      'Slots:',
                                    ),
                                  )),
                              Container(
                                height: 30,
                                width: 250,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.zero),
                                  textAlign: TextAlign.center,
                                  controller: _lengthSlots,
                                  onTap: () => _lengthSlots.clear(),
                                  onFieldSubmitted: (value) {
                                    if (value.isNotEmpty &&
                                        int.tryParse(value) > 0 &&
                                        int.tryParse(value) < 30) {
                                      int _length = int.parse(value);
                                      slots.clear();
                                      for (int index = 1;
                                          index <= _length;
                                          index++) {
                                        slots['SLOT $index'] = {
                                          'port': 'PORT$index',
                                          'active': true,
                                        };

                                        setState(() {});
                                      }
                                    }
                                  },
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 150,
                                child: TextButton(
                                    onPressed: () async {
                                      int index = 0;

                                      slots.clear();
                                      try {
                                        List<String> _devicesLocation = [];
                                        await Process.run(
                                            "wmic path CIM_LogicalDevice where \"Caption like 'USB Mass Storage Device'\" get DeviceID",
                                            []).then((process) {
                                          process.stdout
                                              .toString()
                                              .split('\n')
                                              .forEach((element) {
                                            if (element.startsWith('USB') &&
                                                element.contains('PID_3744')) {
                                              _devicesLocation.add(element
                                                  .split('\\')
                                                  .last
                                                  .trim());
                                            }
                                          });
                                          _devicesLocation
                                              .toSet()
                                              .toList()
                                              .forEach((element) {
                                            index++;
                                            slots['SLOT $index'] = {
                                              'port': 'PORT' +
                                                  element.split('&').last,
                                              'active': true,
                                            };
                                          });
                                          setState(() {});
                                        });

                                        /* await Process.run('chgport', []).then(
                                        (process) {
                                      List<String> _ports = [];
                                      _ports = process.stdout.split('\n');
                                      _lengthSlots.text = index.toString();
                                      _ports
                                          .where((element) =>
                                              element.contains('Silab'))
                                          .forEach((element) {
                                        index++;
                                        slots['SLOT $index'] = {
                                          'port': element.split(" ").first,
                                          'active': true,
                                        };
                                        _lengthSlots.text = index.toString();
                                      });
                                    }, onError: (onError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Não foi possível realizar a configuração'),
                                        backgroundColor: Colors.red[300],
                                      ));
                                    }).whenComplete(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Configuração das portas realizada com sucesso'),
                                        backgroundColor: Colors.green[300],
                                      ));
                                      setState(() {});
                                    }); */
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Não foi possível realizar a configuração'),
                                          backgroundColor: Colors.red[300],
                                        ));
                                      }
                                    },
                                    child: Text('Verificar Portas')),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 120,
                                child: Center(
                                  child: Text('Programa:'),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 250,
                                child: TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.zero),
                                  textAlign: TextAlign.center,
                                  controller: _hexFile,
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 70,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.folder_rounded,
                                    color: Colors.yellow[600],
                                  ),
                                  onPressed: () {
                                    final result = OpenFilePicker()
                                      ..defaultExtension = 'efm8'
                                      ..filterSpecification = {
                                        'Program (*.efm8)': '*.efm8'
                                      }
                                      ..title = 'Selecione o arquivo';
                                    final file = result.getFile();
                                    if (file != null) {
                                      if (file.path.isNotEmpty) {
                                        _hexFile.text =
                                            file.path /* .split("\\").last */;
                                        _reference.text = _hexFile.text
                                            .split("\\")
                                            .last
                                            .split(".")
                                            .first
                                            .toUpperCase();
                                      }
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 120,
                                child: Center(
                                  child: Text('Referência:'),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 250,
                                child: TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.zero),
                                  textAlign: TextAlign.center,
                                  controller: _reference,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            width: 370,
                            child: ElevatedButton(
                              onPressed: () {
                                if (/* _formKey.currentState.validate() */ _hexFile
                                        .text.isNotEmpty &&
                                    _reference.text.isNotEmpty &&
                                    _lengthSlots.text.isNotEmpty) {
                                  _formKey.currentState.save();
                                  HomePageViewModel viewModel;
                                  Directory dir =
                                      viewModel.filesPath; //filesPath;
                                  File _file = File(
                                      dir.path + '\\${_reference.text}.json');

                                  Config _newConfig = Config(
                                      slots,
                                      _hexFile.text,
                                      _reference.text.toUpperCase(),
                                      _program.text);

                                  _file.writeAsStringSync(
                                      jsonEncode(_newConfig));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green[300],
                                      content: Text(
                                          'ARQUIVO SALVO COM SUCESSO: ' +
                                              _reference.text.toUpperCase()),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red[300],
                                      content: Text(
                                          'FAVOR PREENCHER TODOS OS CAMPOS (SLOTS, PROGRAMA E REFERENCIA)'),
                                    ),
                                  );
                                }
                              },
                              child: Text('Salvar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(width: 60, child: Text('SLOT')),
                            SizedBox(
                              width: 40,
                            ),
                            Container(width: 80, child: Text('PORTA')),
                            SizedBox(
                              width: 30,
                            ),
                            Container(width: 60, child: Text('ATIVO'))
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: ListView.builder(
                          itemCount: slots.length,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Container(
                                width: 60,
                                child: Text('SLOT ${index + 1}'),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                width: 80,
                                child: DropdownButton(
                                  value: slots['SLOT ${index + 1}']['port'],
                                  onChanged: (value) {
                                    setState(() {
                                      slots['SLOT ${index + 1}']['port'] =
                                          value;
                                    });
                                  },
                                  items: location //ports
                                      .map((value) => DropdownMenuItem(
                                          value: value, child: Text(value)))
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                width: 20,
                                child: Checkbox(
                                    value: slots['SLOT ${index + 1}']['active'],
                                    onChanged: (value) {
                                      setState(() {
                                        slots['SLOT ${index + 1}']['active'] =
                                            value;
                                      });
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
