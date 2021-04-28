import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gravador_mg/styles/home_page_styles.dart';
import 'package:gravador_mg/viewmodel/home_page_modelview.dart';
import 'package:gravador_mg/widgets/buttons_home_page.dart';
import 'package:gravador_mg/widgets/slots.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String message = '';

  FocusNode _recordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Consumer<HomePageViewModel>(
      builder: (context, homeViewModel, child) {
        return FutureBuilder<Directory>(
            future: homeViewModel.verifyDirectory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: HomePageStyles.backgroundColorHomePage,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      centerTitle: true,
                      actions: [
                        passwordButton(context, homeViewModel),
                        HomePageStyles.blankWidthSpace,
                      ],
                      title: Text(
                        widget.title,
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      backgroundColor: Color.fromRGBO(6, 58, 118, 0.9),
                    ),
                    body: RawKeyboardListener(
                      autofocus: true,
                      focusNode: _recordFocusNode,
                      onKey: (value) {
                        if (value.isKeyPressed(LogicalKeyboardKey.enter) &&
                            !homeViewModel.isRecording) {
                          homeViewModel.recordDevice();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Row(
                                children: [
                                  HomePageStyles.blankWidthSpace,
                                  Container(
                                    width: 200,
                                    height: 50,
                                    child: searchProgramButton(
                                        context, homeViewModel),
                                  ),
                                  HomePageStyles.blankWidthSpace,
                                  Flexible(
                                    child: Container(
                                      height: 50,
                                      decoration: HomePageStyles.innerShadowing,
                                      child: Center(
                                        child: TextField(
                                          readOnly: true,
                                          decoration: null,
                                          style: TextStyle(
                                            letterSpacing: 5,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          controller:
                                              homeViewModel.controllerCP,
                                        ),
                                      ),
                                    ),
                                  ),
                                  HomePageStyles.blankWidthSpace,
                                  refreshButton(context, homeViewModel),
                                  HomePageStyles.blankWidthSpace,
                                ],
                              ),
                            ),
                            HomePageStyles.blankHeightSpace,
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: containerSlots(homeViewModel)),
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80.0),
                                child: Container(
                                  height: 60,
                                  child: recordButton(homeViewModel),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'images/logo_colorful.jpg',
                                height: 80,
                                width: 200,
                                filterQuality: FilterQuality.medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
      },
    );
  }
}
