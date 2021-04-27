/*     IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: config['config'] == null
                                      ? null
                                      : () async {
                                          try {
                                            int index = 0;
                                            List<String> _ports = [];

                                            await Process.run('chgport', [])
                                                .then((process) {
                                              if (process.stdout.length > 0) {
                                                _ports =
                                                    process.stdout.split('\n');
                                                config['config'] = {};
                                                _ports
                                                    .where((element) => element
                                                        .contains('Silab'))
                                                    .forEach((element) {
                                                  print('Entrei');

                                                  index++;
                                                  config['config']
                                                      ['SLOT $index'] = {
                                                    'port': element
                                                        .split(" ")
                                                        .first,
                                                    'active': true,
                                                    'color': Colors.grey[400],
                                                  };
                                                });
                                              }
                                            }, onError: (onError) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Não foi possível realizar a configuração'),
                                                backgroundColor:
                                                    Colors.red[300],
                                              ));
                                            }).whenComplete(() {
                                              if (_ports.length == 0) {
                                                config['config']
                                                    .values
                                                    .forEach((element) {
                                                  element['active'] = false;
                                                });
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(_ports.length > 0
                                                    ? 'Configuração das portas realizada com sucesso'
                                                    : 'Nenhum Dispositivo Conectado'),
                                                backgroundColor:
                                                    _ports.length > 0
                                                        ? Colors.green[300]
                                                        : Colors.red[300],
                                              ));
                                              setState(() {});
                                            });
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Não foi possível realizar a configuração'),
                                              backgroundColor: Colors.red[300],
                                            ));
                                          }
                                        }),
                           */