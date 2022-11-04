// ignore_for_file: public_member_api_docs, sort_constructors_first
//FLUTTER NATIVE

import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:provider/provider.dart';

import 'package:zune/src/models/tflite/recognition.dart';
import 'package:zune/src/providers/loc_provider.dart';
import 'package:zune/src/widgets/cards/shadow_card.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import '../../models/utilities/types.dart';



ScrollController? _controller = ScrollController();
ScrollController? _controller2 = ScrollController();

List<bool> pressed = List<bool>.filled(Types.icons.length, true);

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

  @override
  Widget build(BuildContext context) {

    final locProvider = Provider.of<LocProvider>(context);
    final textController = TextEditingController();
    
    
    return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
          child: Column(
            children: <Widget>[
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
                        MapStyle(
                          feature: StyleFeature.road,
                          rules: [
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
                    ) :
                    CircularProgressIndicator(),
                  
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
                      style: TextStyle(color:HexColor.fromHex("#DBFBB5")),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search), 
                          iconSize: 24,
                          color: HexColor.fromHex("#DBFBB5"),
                          onPressed: () {
                            llistaAux = List.from(widget.llista);   
                            llistaAux.removeWhere((item) => item.label != textController.text);
                            textController.text = "";
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                        ),
                        hintText: 'Search object...',
                        hintStyle: TextStyle(color: HexColor.fromHex("#DBFBB5").withOpacity(0.5)),
                      ),
                      onSubmitted: (value) {
                        llistaAux = List.from(widget.llista); 
                        llistaAux.removeWhere((item) => item.label != textController.text);
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
                          children: List.generate(2/*icons.length*/, (index){
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 15, top: 15),
                                  child: ShadowCard(
                                    height: 50, 
                                    width: 50, 
                                    color: pressed[index] ? HexColor.fromHex("#343334"): HexColor.fromHex("#DBFBB5"),
                                    wantsShadow: !pressed[index],
                                    action: (){
                                      setState(() { 
                                        pressed[index] = !pressed[index];
                                      });
                                    },
                                    child: Icon(Types.icons[index]!.data, color: pressed[index] ? HexColor.fromHex("#DBFBB5"): HexColor.fromHex("#343334"), size: 25,)
                                    ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15, top: 5),
                                  child: CustomText(
                                    Types.icons[index]!.text, 
                                    color: pressed[index] ? HexColor.fromHex("#DBFBB5"): HexColor.fromHex("#343334"), 
                                    fontSize: 12,),
                                )
                              ],
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
                      children: [ llistaAux.length != 0 ? SizedBox(
                        height: 200, 
                        width: MediaQuery.of(context).size.width, 
                        child: new ListView.builder(scrollDirection: Axis.horizontal, itemCount: llistaAux.length, itemBuilder: (BuildContext context, int index) {
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
                                )
                            );
                          })
                      ) : Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width-25,
                          margin: EdgeInsets.only(left: 15, top: 20),
                          child: CustomText(
                              "No results",
                              color: HexColor.fromHex("#DBFBB5"),
                              fontSize: 20,
                              ),
                          ),
                      )
                      ],               
                    )
                          
                    /*Row(
                      children: llistaAux.length != 0 ? List.generate(llistaAux.length, (index){
                        print("PRINTING: " + llistaAux.toString());
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
                            )
                            
                        );
                      }): [Container(
                        margin: EdgeInsets.only(left: 15, top: 20),
                        child: ShadowCard(
                          height: 200, 
                          width: MediaQuery.of(context).size.width - 25, 
                          color: HexColor.fromHex("#343334"),
                          wantsShadow: false,
                          child: CustomText(
                            "No results",
                            color: HexColor.fromHex("#DBFBB5"),
                            fontSize: 20,
                          ),
                          )
                          
                      )],       
                    ),*/
                  ),
                ),
              ),
            ]
          ),
        ));
  }
}