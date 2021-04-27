import 'package:flutter/material.dart';
import 'package:gravador_mg/viewmodel/home_page_modelview.dart';
import 'package:gravador_mg/viewmodel/new_config_modelview.dart';
import 'package:gravador_mg/views/new_config_page.dart';
import 'package:provider/provider.dart';

GlobalKey<FormState> _formKey = GlobalKey();

IconButton password(BuildContext context, HomePageViewModel homeViewModel) =>
    IconButton(
        icon: Icon(Icons.settings),
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
                          onEditingComplete: () => {
                            if (_formKey.currentState.validate())
                              {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                      create: (context) => NewConfigViewModel(),
                                      child: NewConfig(),
                                    ),
                                  ),
                                ),
                              },
                          },
                        ),
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
                    onPressed: () => {
                      if (_formKey.currentState.validate())
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                      create: (context) => NewConfigViewModel(),
                                      child: NewConfig(),
                                    )),
                          ),
                        },
                    },
                    child: Text('Confirmar'),
                  ),
                ],
              ),
            );
          }
        });

IconButton refresh(BuildContext context, HomePageViewModel homeViewModel) {
  return password(context, homeViewModel);
}
