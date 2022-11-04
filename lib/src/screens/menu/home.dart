//FLUTTER NATIVE

import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:provider/provider.dart';
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
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {
    


  @override
  Widget build(BuildContext context) {

    final locProvider = Provider.of<LocProvider>(context);

    return Scaffold(
        backgroundColor: Colors.transparent,
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
              SizedBox(height: 20),
              Container(
                child: Center(
                  child: locProvider.getValuePosition != null
                  ? StaticMap(
                    height: 150,
                    width:  MediaQuery.of(context).size.width - 25,
                    scaleToDevicePixelRatio: true,
                    googleApiKey: "AIzaSyCnbEUi_fwEpV_TTmgwP6lBArhm-azrhC8",
                    markers: [
                      Marker(
                        color: HexColor.fromHex("#DBFBB5"),
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
                      style: TextStyle(color:HexColor.fromHex("#DBFBB5")),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search, 
                          size: 36,
                          color: HexColor.fromHex("#DBFBB5")),
                        hintText: 'Search object...',
                        hintStyle: TextStyle(color: HexColor.fromHex("#DBFBB5").withOpacity(0.5))
                      ),
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
                      children: List.generate(Types.icons.length, (index){
                        return Container(
                          margin: EdgeInsets.only(left: 15, top: 20),
                          child: ShadowCard(
                            height: 230, 
                            width: 200, 
                            color: HexColor.fromHex("#343334"),
                            wantsShadow: false,
                            child: Icon(Types.icons[index]!.data, color: HexColor.fromHex("#DBFBB5"), size: 25,)
                            ),
                        );
                      }),       
                    ),
                  ),
                ),
              ),
            ]
          ),
        ));
  }
}