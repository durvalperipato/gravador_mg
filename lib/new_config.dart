import 'dart:convert';
import 'dart:io';

import 'package:file/file.dart' as file;
import 'package:file/local.dart' as local;
import 'package:flutter/material.dart';
import 'package:gravador_mg/config.dart';
import 'package:gravador_mg/variables.dart';
import 'package:process_run/shell.dart';

import 'package:filepicker_windows/filepicker_windows.dart';

class NewConfig extends StatefulWidget {
  @override
  _NewConfigState createState() => _NewConfigState();
}

class _NewConfigState extends State<NewConfig> {
  TextEditingController _lengthSlots = TextEditingController();
  TextEditingController _reference = TextEditingController();
  TextEditingController _hexFile = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _lengthSlots = TextEditingController(text: '0');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                      'port': 'COM$index',
                                      'active': true,
                                    };
                                  }
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 150,
                            child: TextButton(
                                onPressed: () async {
                                  //Shell shell = Shell(verbose: false);
                                  int index = 1;
                                  slots.clear();
                                  try {
                                    await Process.run('cmd.exe', ['chgport'])
                                        .then(
                                            (process) => process.outLines
                                                    .forEach((element) {
                                                  if (element
                                                      .contains('Silab')) {
                                                    _lengthSlots.text =
                                                        index.toString();
                                                    slots['SLOT $index'] = {
                                                      'port': element.substring(
                                                          0, 4),
                                                      'active': true,
                                                    };
                                                    index++;
                                                  }
                                                }), onError: (onError) {
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
                                    });
                                    /* await shell.run('chgport').then(
                                        (process) =>
                                            process.outLines.forEach((element) {
                                              if (element.contains('Silab')) {
                                                _lengthSlots.text =
                                                    index.toString();
                                                slots['SLOT $index'] = {
                                                  'port':
                                                      element.substring(0, 4),
                                                  'active': true,
                                                };
                                                index++;
                                              }
                                            }), onError: (onError) {
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
                                color: Colors.yellow[400],
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
                              final file.FileSystem fs =
                                  local.LocalFileSystem();

                              Directory dir = fs.currentDirectory;
                              File _file = File(dir.path +
                                  '\\files\\${_reference.text}.json');

                              Config _newConfig = Config(slots, _hexFile.text,
                                  _reference.text.toUpperCase());

                              _file.writeAsStringSync(jsonEncode(_newConfig));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green[300],
                                  content: Text('ARQUIVO SALVO COM SUCESSO: ' +
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
                                  slots['SLOT ${index + 1}']['port'] = value;
                                });
                              },
                              items: ports
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
  }
}
