import 'package:flutter/material.dart';
import 'package:gravador_mg/utils/variables.dart';
import 'package:gravador_mg/viewmodel/new_config_modelview.dart';
import 'package:gravador_mg/widgets/buttons_new_config_page.dart';
import 'package:provider/provider.dart';

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
        builder: (context, newConfigViewModel, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst)),
          title: Text('Nova Configuração'),
        ),
        body: FutureBuilder(
          future: newConfigViewModel.getDevicesFromFile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 8,
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
                                    width: 120,
                                    height: 80,
                                    child: Center(
                                      child: Text('Programa:'),
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 140,
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: programSiliconLab,
                                          groupValue: newConfigViewModel
                                              .groupValueRadioButton,
                                          onChanged: (value) {
                                            newConfigViewModel
                                                .groupValueRadioButton = value;
                                            newConfigViewModel.program = value;
                                          },
                                        ),
                                        Center(
                                          child: Text(programSiliconLab),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 140,
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: programST,
                                          groupValue: newConfigViewModel
                                              .groupValueRadioButton,
                                          onChanged: (value) {
                                            newConfigViewModel
                                                .groupValueRadioButton = value;
                                            newConfigViewModel.program = value;
                                          },
                                        ),
                                        Center(
                                          child: Text(programST),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            newConfigViewModel.groupValueRadioButton == null
                                ? Container()
                                : Flexible(
                                    flex: 4,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        bottom: 20,
                                        //   right: 20,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(2, 2),
                                              color: Colors.black,
                                              blurRadius: 2,
                                            )
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 670,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'CONFIGURAÇÃO - ${newConfigViewModel.groupValueRadioButton}',
                                              style:
                                                  TextStyle(letterSpacing: 10),
                                            )),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
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
                                                  width: 430,
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10)),
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        newConfigViewModel
                                                            .lenghtSlots,
                                                    enabled: false,
                                                    onTap: () =>
                                                        newConfigViewModel
                                                            .lenghtSlots
                                                            .clear(),
                                                    onFieldSubmitted: (value) =>
                                                        newConfigViewModel
                                                            .submitSlots(value),
                                                  ),
                                                ),
                                                Container(
                                                    height: 30,
                                                    width: 70,
                                                    child: verifyPorts(context,
                                                        newConfigViewModel)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 120,
                                                  child: Center(
                                                    child: Text(
                                                        newConfigViewModel
                                                                    .program !=
                                                                programST
                                                            ? 'File efm8'
                                                            : 'File s19'),
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 430,
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10)),
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        newConfigViewModel
                                                            .hexFile,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 70,
                                                  child: openFilesButton(() =>
                                                      newConfigViewModel
                                                          .openFile()),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (newConfigViewModel.program ==
                                              programST)
                                            SizedBox(
                                              height: 20,
                                            ),
                                          if (newConfigViewModel.program ==
                                              programST)
                                            Flexible(
                                              flex: 1,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 120,
                                                    child: Center(
                                                      child: Text.rich(
                                                        TextSpan(
                                                            text:
                                                                'Option Byte ',
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                      '(Opcional) ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 7,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ))
                                                            ]),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width: 430,
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10)),
                                                      textAlign:
                                                          TextAlign.center,
                                                      controller:
                                                          newConfigViewModel
                                                              .optionByteFile,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 70,
                                                    child: openFilesButton(() =>
                                                        newConfigViewModel
                                                            .openFile(
                                                                optionByte:
                                                                    true)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          if (newConfigViewModel.program ==
                                              programST)
                                            SizedBox(
                                              height: 20,
                                            ),
                                          if (newConfigViewModel.program ==
                                              programST)
                                            Flexible(
                                              flex: 1,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 120,
                                                    child: Center(
                                                      child: Text('Device'),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width: 430,
                                                    child: DropdownButton(
                                                      underline: Container(),
                                                      onChanged: (value) =>
                                                          newConfigViewModel
                                                              .device = value,
                                                      value: newConfigViewModel
                                                          .device,
                                                      items: newConfigViewModel
                                                          .devicesST
                                                          .map(
                                                            (value) =>
                                                                DropdownMenuItem(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            ),
                                                          )
                                                          .toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                    width: 70,
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
                                              mainAxisSize: MainAxisSize.min,
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
                                                  width: 430,
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10)),
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        newConfigViewModel
                                                            .reference,
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
                                              margin: const EdgeInsets.only(
                                                left: 50,
                                              ),
                                              width: 600,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (newConfigViewModel
                                                      .hasValueInAllFields()) {
                                                    newConfigViewModel
                                                        .setNewConfig();

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.green[300],
                                                        content: Text(
                                                            'ARQUIVO SALVO COM SUCESSO: ' +
                                                                newConfigViewModel
                                                                    .reference
                                                                    .text
                                                                    .toUpperCase()),
                                                      ),
                                                    );
                                                    Navigator.popUntil(
                                                        context,
                                                        (route) =>
                                                            route.isFirst);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.red[300],
                                                        content: Text(
                                                            'FAVOR PREENCHER TODOS OS CAMPOS (SLOTS, FILE E DEVICE)'),
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
                            SizedBox(
                              height: 30,
                            ),
                            newConfigViewModel.groupValueRadioButton == null
                                ? Container()
                                : Flexible(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(2, 2),
                                            blurRadius: 2,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 670,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'PATH DOS SOFTWARES',
                                              style:
                                                  TextStyle(letterSpacing: 10),
                                            )),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 120,
                                                  child: Center(
                                                    child: Text('Silicon Labs'),
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 450,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10)),
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    controller: newConfigViewModel
                                                        .pathSiliconLabProgram,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 70,
                                                  child: openFilesButton(
                                                    () => newConfigViewModel
                                                        .openPathProgram(
                                                            siliconLab: true),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 120,
                                                  child: Center(
                                                    child: Text('ST'),
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 450,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10)),
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    controller:
                                                        newConfigViewModel
                                                            .pathSTProgram,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 70,
                                                  child: openFilesButton(() =>
                                                      newConfigViewModel
                                                          .openPathProgram(
                                                              st: true)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    newConfigViewModel.groupValueRadioButton == null
                        ? Container()
                        : Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 2),
                                      color: Colors.black,
                                      blurRadius: 2,
                                    )
                                  ]),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 670,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'SLOTS',
                                      style: TextStyle(letterSpacing: 10),
                                    )),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            width: 60, child: Text('SLOT')),
                                        /* SizedBox(
                                    width: 40,
                                  ), */
                                        Container(
                                            width: 80,
                                            child: Text(
                                                newConfigViewModel.program ==
                                                        programST
                                                    ? 'ID'
                                                    : 'PORTA')),
                                        /* SizedBox(
                                    width: 30,
                                  ), */
                                        Container(
                                            width: 60, child: Text('ATIVO'))
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: ListView.builder(
                                      itemCount: newConfigViewModel
                                          .slots['config'].length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: 60,
                                              child: Text('SLOT ${index + 1}'),
                                            ),
                                            /* SizedBox(
                                        width: 40,
                                      ), */
                                            Container(
                                              width: 90,
                                              child: DropdownButton(
                                                value: newConfigViewModel
                                                            .slots['config']
                                                        ['SLOT ${index + 1}']
                                                    ['port'],
                                                onChanged: (value) {
                                                  setState(() {
                                                    newConfigViewModel
                                                                .slots['config']
                                                            [
                                                            'SLOT ${index + 1}']
                                                        ['port'] = value;
                                                  });
                                                },
                                                items: newConfigViewModel
                                                            .program ==
                                                        programST
                                                    ? location
                                                        .map((value) =>
                                                            DropdownMenuItem(
                                                                value: value,
                                                                child: Text(
                                                                    value)))
                                                        .toList()
                                                    : ports
                                                        .map((value) =>
                                                            DropdownMenuItem(
                                                                value: value,
                                                                child: Text(
                                                                    value)))
                                                        .toList(),
                                              ),
                                            ),
                                            /* SizedBox(
                                        width: 40,
                                      ), */
                                            Container(
                                              width: 20,
                                              child: Checkbox(
                                                  value: newConfigViewModel
                                                              .slots['config']
                                                          ['SLOT ${index + 1}']
                                                      ['active'],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      newConfigViewModel.slots[
                                                                  'config'][
                                                              'SLOT ${index + 1}']
                                                          ['active'] = value;
                                                    });
                                                  }),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    });
  }
}
