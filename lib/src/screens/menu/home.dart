// ignore_for_file: public_member_api_docs, sort_constructors_first
//FLUTTER NATIVE

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:provider/provider.dart';

import 'package:zune/src/models/tflite/recognition.dart';
import 'package:zune/src/providers/loc_provider.dart';
import 'package:zune/src/providers/recognition_provider.dart';
import 'package:zune/src/widgets/cards/shadow_card.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/widgets/widgets.dart';
import '../../models/utilities/types.dart';

ScrollController? _controller = ScrollController();
ScrollController? _controller2 = ScrollController();

class Home extends StatefulWidget {
  List<Recognition> llista;
  Home(
    this.llista,
  );

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Recognition> llistaAux = [];
  int selected = -1;

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    final locProvider = Provider.of<LocProvider>(context);
    final recognitionProvider = Provider.of<RecognitionProvider>(context);
    final textController = TextEditingController();

    if (firstTime) {
      llistaAux = recognitionProvider.recognitions;
      firstTime = false;
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: Platform.isAndroid
            ? null
            : AppBar(
                title: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 52,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
        body: Container(
          child: Column(children: <Widget>[
            Platform.isAndroid
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      height: 52,
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: CustomText(
                    'Current Location',
                    fontSize: 15,
                    color: HexColor.fromHex("#DBFBB5"),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 180,
                child: locProvider.getValuePosition != null
                    ? StaticMap(
                        zoom: 17,
                        maptype: StaticMapType.hybrid,
                        scaleToDevicePixelRatio: true,
                        googleApiKey: "AIzaSyCnbEUi_fwEpV_TTmgwP6lBArhm-azrhC8",
                        styles: [
                          MapStyle(feature: StyleFeature.road, rules: [
                            StyleRule.color(HexColor.fromHex("#DBFBB5")),
                          ]),
                          MapStyle(
                            element: StyleElement.geometry,
                            feature: StyleFeature.landscape.natural,
                            rules: const [
                              StyleRule.color(Colors.grey),
                            ],
                          )
                        ],
                        markers: [
                          Marker(
                            color: HexColor.fromHex("#8A66E6"),
                            label: "X",
                            locations: [
                              GeocodedLocation.latLng(locProvider.getValuePosition!.latitude, locProvider.getValuePosition!.longitude),
                            ],
                          ),
                        ],
                      )
                    : CircularProgressIndicator(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Center(
                child: ShadowCard(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 25,
                  color: HexColor.fromHex("#343334"),
                  wantsShadow: false,
                  child: TextField(
                    controller: textController,
                    style: TextStyle(color: HexColor.fromHex("#DBFBB5")),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        iconSize: 24,
                        color: HexColor.fromHex("#DBFBB5"),
                        onPressed: () {
                          llistaAux = List.from(recognitionProvider.recognitions);
                          llistaAux.removeWhere((item) => item.label.toLowerCase() != textController.text.toLowerCase());
                          textController.text = "";
                          FocusScope.of(context).unfocus();
                          setState(() {});
                        },
                      ),
                      hintText: 'Search object...',
                      hintStyle: TextStyle(color: HexColor.fromHex("#DBFBB5").withOpacity(0.5)),
                    ),
                    onSubmitted: (value) {
                      llistaAux = List.from(recognitionProvider.recognitions);
                      llistaAux.removeWhere((item) => item.label.toLowerCase() != textController.text.toLowerCase());
                      textController.text = "";
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Scrollbar(
                thumbVisibility: true,
                controller: _controller,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  child: Row(
                    children: List.generate(2, (index) {
                      return CustomIcon(
                        type: index,
                        selected: selected,
                        isHome: true,
                        callback: (arg) {
                          setState(() {
                            selected = arg;
                          });
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Scrollbar(
                thumbVisibility: true,
                controller: _controller2,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _controller2,
                    child: Row(
                      children: [
                        llistaAux.length != 0
                            ? SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: new ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: llistaAux.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                          margin: EdgeInsets.only(left: 15, top: 20),
                                          child: ShadowCard(
                                            height: 200,
                                            width: 200,
                                            color: HexColor.fromHex("#343334"),
                                            wantsShadow: false,
                                            child: CustomText(
                                              llistaAux[index].label,
                                              color: HexColor.fromHex("#DBFBB5"),
                                              fontSize: 20,
                                            ),
                                            action: () {
                                              showAnimatedDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return ObjectDialog(obj: llistaAux[index]);
                                                },
                                                animationType: DialogTransitionType.fadeScale,
                                                curve: Curves.fastOutSlowIn,
                                                duration: Duration(milliseconds: 500),
                                              );
                                            },
                                          ));
                                    }))
                            : Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width - 25,
                                  margin: EdgeInsets.only(left: 15, top: 20),
                                  child: Center(
                                    child: CustomText(
                                      "No results",
                                      color: HexColor.fromHex("#DBFBB5"),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    )),
              ),
            ),
          ]),
        ));
  }
}
