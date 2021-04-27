import 'package:flutter/material.dart';
import 'package:gravador_mg/styles/home_page_styles.dart';
import 'package:gravador_mg/utils/variables.dart';
import 'package:gravador_mg/viewmodel/home_page_modelview.dart';

List<Widget> containerSlots(HomePageViewModel homeViewModel) {
  List<Widget> _slotsWidget = [];

  homeViewModel.recordingSlots.clear();
  if (homeViewModel.slots.isNotEmpty) {
    homeViewModel.slots['config'].entries.forEach((element) {
      homeViewModel.addRecording = false;
      _slotsWidget.add(
        Flexible(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              homeViewModel.activeOrDisableSlot(element.key);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(2, 2),
                        color: Colors.black87,
                        blurRadius: 2),
                    BoxShadow(
                        offset: Offset(-2, -2),
                        color: Colors.white,
                        blurRadius: 2),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: HomePageStyles.colorSlot(homeViewModel, element.key)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    element.key,
                    style: TextStyle(
                      color: element.value['active']
                          ? Colors.black
                          : Colors.grey[400],
                      fontSize: HomePageStyles.textFontSize(homeViewModel,
                          title: true),
                    ),
                  ),
                  Text(
                    homeViewModel.slots['program'] == programST
                        ? 'ID\n${element.value['port']}'
                        : 'PORTA\n${element.value['port']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: element.value['active']
                          ? Colors.black
                          : Colors.grey[400],
                      fontSize: HomePageStyles.textFontSize(homeViewModel),
                    ),
                  ),
                  Text(
                    element.value['active'] ? 'ON' : 'OFF',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: element.value['active']
                          ? Colors.black
                          : Colors.grey[400],
                      fontSize: HomePageStyles.textFontSize(homeViewModel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  } else {
    _slotsWidget.add(Center(child: Text('NENHUM PROGRAMA SELECIONADO')));
  }

  return _slotsWidget;
}
