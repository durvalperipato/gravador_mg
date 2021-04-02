import 'package:flutter/material.dart';
import 'package:gravador_mg/variables.dart';
import 'package:process_run/shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences _prefs;

  @override
  void initState() {
    _recording = false;

    super.initState();
  }

  Future<SharedPreferences> get getPrefs => SharedPreferences.getInstance();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<SharedPreferences>(
          future: getPrefs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //            _portsEnabledToRecord.clear();
              _prefs = snapshot.data;
              if (_prefs.containsKey(widget.slot)) {
                //            _portsEnabledToRecord = _prefs.getStringList(widget.slot);

                /*           ports.entries.forEach((element) {
                  if (_portsEnabledToRecord.contains(element.key)) {
                    ports[element.key]['active'] = true;
                  }
                }); */
              } else {
                _prefs.setStringList(widget.slot, []);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Container(
                                height: 250,
                                width: 200,
                                child: ListView.builder(
                                  itemCount: 4,
                                  itemBuilder: (context, index) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('SLOT ${index + 1}'),
                                      DropdownButton(
                                        value: slots['SLOT ${index + 1}']
                                            ['port'],
                                        onChanged: (value) {
                                          setState(() {
                                            slots['SLOT ${index + 1}']['port'] =
                                                value;
                                          });
                                        },
                                        items: ports
                                            .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Text(value)))
                                            .toList(),
                                      ),
                                      Checkbox(
                                          value: slots['SLOT ${index + 1}']
                                              ['active'],
                                          onChanged: (value) {
                                            setState(() {
                                              slots['SLOT ${index + 1}']
                                                  ['active'] = value;
                                            });
                                          })
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Voltar'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('Confirmar'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          child: Text('Config'),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: ElevatedButton(
                        onPressed: () => _recordDevice(),
                        child: Text('GRAVAR'),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  List<Widget> get containerSlots {
    List<Widget> children = [];
    slots.entries
        .where((element) => element.value['active'])
        .forEach((element) {
      children.add(
        Flexible(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.maxFinite,
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
                color: element.value['color']),
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
    });
    return children;
  }

  /*  */

  _recordDevice() async {
    List<String> outputs = [];

    slots.entries
        .where((element) => element.value['active'])
        .forEach((element) {
      element.value['command'] = 'cmd.exe'
          /* '''efm8load.exe -p ${element.value['port']} -b 115200 EFM8BB1_PCA_SoftwareTimerBlinky.efm8''' */;
    });

    try {
      setState(() {
        _recording = true;
      });

      try {
        slots.entries
            .where((element) => element.value['active'])
            .forEach((element) {
          Shell shell = Shell(
            verbose: false,
          );
          shell.run(element.value['command']).then((process) {
            process.outLines.forEach((elementProcess) {
              if (elementProcess.contains('?')) {
                setState(() {});
              } else if (elementProcess.contains('@@@@@@')) {
                setState(() {});
              }
            });
          });
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
