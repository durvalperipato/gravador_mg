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
                                  Checkbox(
                                      value: newConfigViewModel.valueCheckBox,
                                      onChanged: (value) {
                                        newConfigViewModel.program =
                                            programSiliconLab;
                                        newConfigViewModel.onClickCheckBox();
                                      }),
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
                                  Checkbox(
                                      value: !newConfigViewModel.valueCheckBox,
                                      onChanged: (value) {
                                        newConfigViewModel.program = programST;

                                        newConfigViewModel.onClickCheckBox();
                                      }),
                                  Center(
                                    child: Text(programST),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                enabled: false,
                                onTap: () =>
                                    newConfigViewModel.lenghtSlots.clear(),
                                onFieldSubmitted: (value) =>
                                    newConfigViewModel.submitSlots(value),
                              ),
                            ),
                            Container(
                                height: 30,
                                width: 150,
                                child:
                                    verifyPorts(context, newConfigViewModel)),
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
                                child: Text(
                                    newConfigViewModel.program != programST
                                        ? 'File efm8'
                                        : 'File s19'),
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
                              child: openFilesButton(
                                  () => newConfigViewModel.openFile()),
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
                                newConfigViewModel.setNewConfig();

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
                      SizedBox(height: 80),
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: 120,
                              child: Center(
                                child: Text('Path Silicon Labs'),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 450,
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.zero),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                                controller:
                                    newConfigViewModel.pathSiliconLabProgram,
                              ),
                            ),
                            Container(
                                height: 50,
                                width: 70,
                                child: openFilesButton(() => newConfigViewModel
                                    .openPathProgram(siliconLab: true))),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: 120,
                              child: Center(
                                child: Text('Path ST'),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 450,
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.zero),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                                controller: newConfigViewModel.pathSTProgram,
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 70,
                              child: openFilesButton(() =>
                                  newConfigViewModel.openPathProgram(st: true)),
                            ),
                          ],
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
                          Container(
                              width: 80,
                              child: Text(
                                  newConfigViewModel.program == programST
                                      ? 'ID'
                                      : 'PORTA')),
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
                        itemCount: newConfigViewModel.slots['config'].length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                width: 60,
                                child: Text('SLOT ${index + 1}'),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                width: 90,
                                child: DropdownButton(
                                  value: newConfigViewModel.slots['config']
                                      ['SLOT ${index + 1}']['port'],
                                  onChanged: (value) {
                                    setState(() {
                                      newConfigViewModel.slots['config']
                                          ['SLOT ${index + 1}']['port'] = value;
                                    });
                                  },
                                  items: newConfigViewModel.program == programST
                                      ? location
                                          .map((value) => DropdownMenuItem(
                                              value: value, child: Text(value)))
                                          .toList()
                                      : ports
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
                                    value: newConfigViewModel.slots['config']
                                        ['SLOT ${index + 1}']['active'],
                                    onChanged: (value) {
                                      setState(() {
                                        newConfigViewModel.slots['config']
                                                ['SLOT ${index + 1}']
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
            ],
          ),
        ),
      ),
    );
  }
}
