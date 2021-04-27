import 'package:flutter/material.dart';
import 'package:gravador_mg/utils/variables.dart';
import 'package:gravador_mg/viewmodel/home_page_modelview.dart';
import 'package:gravador_mg/viewmodel/new_config_modelview.dart';
import 'package:gravador_mg/viewmodel/shell_modelview.dart';
import 'package:gravador_mg/views/new_config_page.dart';
import 'package:provider/provider.dart';

GlobalKey<FormState> _formKey = GlobalKey();

IconButton password(BuildContext context, HomePageViewModel homeViewModel,
        {bool refreshButton = false}) =>
    IconButton(
        icon: Icon(refreshButton ? Icons.refresh : Icons.settings),
        onPressed: () {
          {
            homeViewModel.controllerPassword.clear();
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
                            controller: homeViewModel.controllerPassword,
                            obscureText: true,
                            validator: (value) =>
                                homeViewModel.verifyPassword(value)
                                    ? null
                                    : 'Senha Incorreta',
                            onEditingComplete: () => _routesButton(
                                context, homeViewModel, refreshButton)),
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
                    onPressed: () =>
                        _routesButton(context, homeViewModel, refreshButton),
                    child: Text('Confirmar'),
                  ),
                ],
              ),
            );
          }
        });

IconButton refresh(BuildContext context, HomePageViewModel homeViewModel) {
  return password(context, homeViewModel, refreshButton: true);
}

_routesButton(
    BuildContext context, HomePageViewModel homeViewModel, bool refreshButton) {
  if (_formKey.currentState.validate()) {
    if (refreshButton) {
      homeViewModel.slots['program'] == programST
          ? ShellModelView.refreshSTPorts(homeViewModel)
          : ShellModelView.refreshSiliconLabsPorts(homeViewModel);

      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => NewConfigViewModel(),
            child: NewConfig(),
          ),
        ),
      );
    }
  }
}
