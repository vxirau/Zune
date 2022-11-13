import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zune/src/models/models.dart';
import 'package:zune/src/models/utilities/toast_utility.dart';
import 'package:zune/src/providers/recognition_provider.dart';
import 'package:zune/src/widgets/widgets.dart';

class ObjectDialog extends StatefulWidget {
  Recognition obj;

  ObjectDialog({required this.obj});

  @override
  State<ObjectDialog> createState() => _ObjectDialogState();
}

class _ObjectDialogState extends State<ObjectDialog> {
  TextEditingController controller = TextEditingController();
  bool firstTime = false;

  bool isURL(String url) {
    return Uri.parse(url).host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final recProvider = Provider.of<RecognitionProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (!firstTime) {
      controller.text = widget.obj.action ??= "";
      firstTime = true;
    }

    return Container(
        height: height * 0.76,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dialog(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(this.widget.obj.label, fontSize: 30),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: List.generate(2, (index) {
                        return CustomIcon(
                          type: index,
                          selected: widget.obj.type == null ? -1 : widget.obj.type!,
                          isHome: false,
                          callback: (arg) {
                            setState(() {
                              widget.obj.type = arg;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        "Action",
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Aqui vendria el card personalizado donde se metera el texto
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildBasicCard(this.widget.obj.action ??= "", context),
                    ),
                    SizedBox(height: height * 0.05),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: CustomText(
                                "CANCEL",
                                fontWeight: FontWeight.bold,
                              ),
                              style: TextButton.styleFrom(backgroundColor: Color(0xFFDBFBB5), padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20))),
                          SizedBox(width: width * 0.15),
                          TextButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  widget.obj.action = controller.text;
                                  if (isURL(controller.text)) {
                                    widget.obj.type = 1;
                                  } else {
                                    widget.obj.type = 0;
                                  }
                                } else {
                                  ToastUtility.standardToast("El texto no puede estar vacio!");
                                }

                                if (widget.obj.isSaved != null && widget.obj.isSaved!) {
                                  recProvider.updateRecognition(widget.obj);
                                } else {
                                  widget.obj.isSaved = true;
                                  recProvider.addRecognition(widget.obj);
                                }

                                Navigator.of(context).pop();
                              },
                              child: CustomText(
                                "SAVE",
                                fontWeight: FontWeight.bold,
                              ),
                              style: TextButton.styleFrom(backgroundColor: Color(0xFFDBFBB5), padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20)))
                        ],
                      ),
                    )
                  ])),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ));
  }

  Widget _buildBasicCard(String content, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      child: Container(
        width: width,
        height: height * 0.3,
        child: TextField(
          controller: controller,
          expands: true,
          minLines: null,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: "Enter your text",
          ),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
        ),
      ),
      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
