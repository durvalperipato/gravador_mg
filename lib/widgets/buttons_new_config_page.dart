import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gravador_mg/utils/variables.dart';
import 'package:gravador_mg/viewmodel/new_config_modelview.dart';
import 'package:gravador_mg/viewmodel/shell_modelview.dart';

IconButton openFilesButton(VoidCallback onPressed) => IconButton(
    icon: Icon(
      Icons.folder_rounded,
      color: Colors.yellow[600],
    ),
    onPressed: onPressed);

TextButton verifyPorts(
        BuildContext context, NewConfigViewModel newConfigViewModel) =>
    TextButton(
      onPressed: () async {
        newConfigViewModel.isVerifyPorts = true;
        try {
          await newConfigViewModel.program == programST
              ? ShellModelView.shellSTToVerifyPorts(newConfigViewModel)
              : ShellModelView.shellSiliconLabsToVerifyPorts(
                  newConfigViewModel);
          Timer(Duration(seconds: 8), () {
            newConfigViewModel.isVerifyPorts = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Configuração das portas realizada com sucesso'),
              backgroundColor: Colors.green[300],
            ));
          });
        } catch (e) {
          newConfigViewModel.isVerifyPorts = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Não foi possível realizar a configuração'),
            backgroundColor: Colors.red[300],
          ));
        }
      },
      child: newConfigViewModel.isVerifyPorts
          ? Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: LinearProgressIndicator(),
            )
          : Text('Verificar Portas'),
    );
