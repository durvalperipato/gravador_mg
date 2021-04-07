import 'dart:convert';
import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gravador_mg/config.dart';
import 'package:gravador_mg/variables.dart';
import 'package:file/file.dart' as file;
import 'package:file/local.dart' as local;
import 'package:process_run/shell.dart';

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
                              width: 150,
                              child: Center(
                                child: Text(
                                  'Slots:',
                                ),
                              )),
                          Container(
                            height: 30,
                            width: 150,
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
                                onPressed: () {
                                  Shell shell = Shell(verbose: true);
                                  int index = 1;
                                  slots.clear();
                                  shell
                                      .run('chgport')
                                      .then(
                                          (process) => process.outLines
                                                  .forEach((element) {
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
                                              }),
                                          onError: (onError) {})
                                      .whenComplete(() {
                                    setState(() {});
                                  });
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
                            width: 150,
                            child: Center(
                              child: Text('Programa:'),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 150,
                            child: TextFormField(
                              onTap: () async {
                                Directory dir;
                                String result = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Container(
                                      //height: 160,
                                      width: 280,
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 80,
                                              width: 180,
                                              child: Center(
                                                child: Text(
                                                    'Digite o diretório raiz: '),
                                              )),
                                          Container(
                                            height: 80,
                                            width: 40,
                                            child: Center(
                                              child: TextField(
                                                maxLength: 1,
                                                decoration: InputDecoration(
                                                    counterText: '',
                                                    border:
                                                        OutlineInputBorder()),
                                                autofocus: true,
                                                onSubmitted: (value) =>
                                                    Navigator.pop(
                                                        context, value),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  try {
                                    dir = Directory('$result:\\');
                                  } catch (e) {
                                    dir = Directory('N:\\');
                                  }
                                } else {
                                  dir = Directory('N:\\');
                                }

                                String path = await FilesystemPicker.open(
                                  title: 'Carregar Programa',
                                  context: context,
                                  rootDirectory: dir,
                                  fsType: FilesystemType.file,
                                  folderIconColor: Colors.teal,
                                  allowedExtensions: ['.efm8'],
                                  fileTileSelectMode:
                                      FileTileSelectMode.wholeTile,
                                );
                                if (path.isNotEmpty) {
                                  _hexFile.text = path /* .split("\\").last */;
                                  _reference.text = _hexFile.text
                                      .split("\\")
                                      .last
                                      .split(".")
                                      .first
                                      .toUpperCase();
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.zero),
                              textAlign: TextAlign.center,
                              controller: _hexFile,
                            ),
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
                            width: 150,
                            child: Center(
                              child: Text('Referência:'),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 150,
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
                    SizedBox(height: 20),
                    Flexible(
                      flex: 2,
                      child: Container(
                        width: 300,
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
