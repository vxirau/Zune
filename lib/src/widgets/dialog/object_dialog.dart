import 'package:flutter/material.dart';
import 'package:zune/src/models/models.dart';
import  'package:zune/src/widgets/widgets.dart';

class ObjectDialog extends StatelessWidget {
  //const name({super.key});
  late Obj obj;

  ObjectDialog({required this.obj});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.76,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Dialog(
            child: Padding(padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                SizedBox(height: 12),
                Align(alignment: Alignment.centerLeft,
                  child:
                    CustomText(this.obj.title, fontSize: 30),    
                ),
                SizedBox(height: 12),
                Align(alignment: Alignment.centerLeft,
                  child:
                    CustomIcon(isText: this.obj.isText),  
                ),
                SizedBox(height: 12),
                Align(alignment: Alignment.centerLeft,
                  child:
                    CustomText("Action", fontSize: 30,),
                ),
                SizedBox(height: 20),  
                // Aqui vendria el card personalizado donde se metera el texto
                Align(alignment: Alignment.centerLeft,
                  child:
                   _buildBasicCard(this.obj.content, context),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // Row con los dos botones alineados en bottom center
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          }, 
                          child: CustomText("eyy",),
                          style: TextButton.styleFrom(backgroundColor: Color(0xFFDBFBB5))),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          }, 
                          child: CustomText("yos"),
                          style: TextButton.styleFrom(backgroundColor: Color(0xFFDBFBB5)))
                      ],)
                  )
                //CustomText(this.obj.isText.toString())
                )])),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
            ),
        ],
      )  
    );
  }

  Widget _buildBasicCard(String content, BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        child: 
          Padding(
            padding: EdgeInsets.all(14),
            child: CustomText(content))),
      color: Colors.grey, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16))
    );
  }
}