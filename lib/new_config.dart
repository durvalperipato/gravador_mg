import 'package:flutter/material.dart';
import 'package:gravador_mg/variables.dart';

class NewConfig extends StatefulWidget {
  @override
  _NewConfigState createState() => _NewConfigState();
}

class _NewConfigState extends State<NewConfig> {
  TextEditingController _lengthSlots;
  TextEditingController _reference;
  TextEditingController _hexFile;
  TextEditingController _command;

  @override
  void initState() {
    _lengthSlots = TextEditingController(text: '0');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Configuração'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Form(
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                            height: 100,
                            width: 150,
                            child: Center(
                              child: Text(
                                'Quantidade de Slots:',
                              ),
                            )),
                        Container(
                          height: 100,
                          width: 100,
                          child: TextFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            textAlign: TextAlign.center,
                            controller: _lengthSlots,
                            onTap: () => _lengthSlots.clear(),
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty &&
                                  int.tryParse(value) > 0 &&
                                  int.tryParse(value) < 30) {
                                int _length = int.parse(value);
                                slots.clear();
                                for (int index = 1; index <= _length; index++) {
                                  slots['SLOT $index'] = {
                                    'port': 'COM$index',
                                    'active': true,
                                    'color': Colors.grey[300],
                                    'command': '',
                                  };
                                }
                                setState(() {});
                              }
                            },
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
                          height: 100,
                          width: 150,
                          child: Center(
                            child: Text('Programa:'),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: TextFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            textAlign: TextAlign.center,
                            controller: _hexFile,
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
                          height: 100,
                          width: 150,
                          child: Center(
                            child: Text('Referência:'),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: TextFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            textAlign: TextAlign.center,
                            controller: _reference,
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
                          height: 100,
                          width: 150,
                          child: Center(
                            child: Text('Comando:'),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: TextFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            textAlign: TextAlign.center,
                            controller: _command,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 9,
            child: ListView.builder(
              itemCount: slots.length,
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('SLOT ${index + 1}'),
                  DropdownButton(
                    value: slots['SLOT ${index + 1}']['port'],
                    onChanged: (value) {
                      setState(() {
                        slots['SLOT ${index + 1}']['port'] = value;
                      });
                    },
                    items: ports
                        .map((value) =>
                            DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                  ),
                  Checkbox(
                      value: slots['SLOT ${index + 1}']['active'],
                      onChanged: (value) {
                        setState(() {
                          slots['SLOT ${index + 1}']['active'] = value;
                        });
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
