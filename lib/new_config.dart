import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/variables_functions.dart';
import 'viewmodel/home_page_modelview.dart';
import 'viewmodel/new_config_modelview.dart';

class NewConfig extends StatefulWidget {
  @override
  _NewConfigState createState() => _NewConfigState();
}

class _NewConfigState extends State<NewConfig> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewConfigViewModel>(
      builder: (context, newConfigViewModel, child) => Scaffold(
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
                                controller: newConfigViewModel.lenghtSlots,
                                onTap: () =>
                                    newConfigViewModel.lenghtSlots.clear(),
                                onFieldSubmitted: (value) =>
                                    newConfigViewModel.submitSlots(value),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 150,
                              child: TextButton(
                                  onPressed: () async {
                                    int index = 0;

                                    newConfigViewModel.slots.clear();
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
                                          newConfigViewModel
                                              .slots['SLOT $index'] = {
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
                                controller: newConfigViewModel.hexFile,
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
                                  newConfigViewModel.openFile();
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
                                controller: newConfigViewModel.reference,
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
                              if (newConfigViewModel.hasValueInAllFields()) {
                                _formKey.currentState.save();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green[300],
                                    content: Text(
                                        'ARQUIVO SALVO COM SUCESSO: ' +
                                            newConfigViewModel.reference.text
                                                .toUpperCase()),
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
                        itemCount: newConfigViewModel.slots.length,
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
                                value: newConfigViewModel
                                    .slots['SLOT ${index + 1}']['port'],
                                onChanged: (value) {
                                  setState(() {
                                    newConfigViewModel
                                            .slots['SLOT ${index + 1}']
                                        ['port'] = value;
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
                                  value: newConfigViewModel
                                      .slots['SLOT ${index + 1}']['active'],
                                  onChanged: (value) {
                                    setState(() {
                                      newConfigViewModel
                                              .slots['SLOT ${index + 1}']
                                          ['active'] = value;
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
      ),
    );
  }
}
