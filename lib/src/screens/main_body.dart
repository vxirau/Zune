//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//MODELS
import 'package:zune/src/models/utilities/app_colors.dart';
import 'package:zune/src/models/utilities/hex_color.dart';

//SCREENS
import 'package:zune/src/screens/screens.dart';

//PROVIDERS
import 'package:zune/src/providers/ui_provider.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';

//PAQUETS INSTALATS
import 'package:provider/provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class MainBody extends StatefulWidget {
  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(AppColors.systemTheme);

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    _animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UiProvider uiProvider = Provider.of<UiProvider>(context);

    final iconList = <IconData>[uiProvider.selectedMenuOpt == 0 ? Icons.home_filled : Icons.home_outlined, uiProvider.selectedMenuOpt == 1 ? Icons.person : Icons.person_outline_rounded];

    return Scaffold(
        backgroundColor: HexColor.fromHex("#292828"),
        floatingActionButton: ScaleTransition(
          scale: animation,
          child: Container(
            height: 80.0,
            width: 80.0,
            child: FittedBox(
              child: FloatingActionButton(
                elevation: 8,
                backgroundColor: HexColor.fromHex("#DBFBB5"),
                child: Icon(
                  Icons.view_in_ar_rounded,
                  color: HexColor.fromHex("#8A66E6"),
                  size: 30,
                ),
                onPressed: () async {
                  uiProvider.selectedMenuOpt = 2;
                },
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: uiProvider.selectedMenuOpt,
          backgroundColor: HexColor.fromHex("#343334"),
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          iconSize: 30,
          height: 70,
          leftCornerRadius: 20,
          rightCornerRadius: 20,
          notchAndCornersAnimation: animation,
          splashSpeedInMilliseconds: 300,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) => setState(() => uiProvider.selectedMenuOpt = index),
          //other params
        ),
        body: SafeArea(child: _HomePageBody()));
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    switch (uiProvider.selectedMenuOpt) {
      case 0:
        return Home();
      case 1:
        return Profile();

      case 2:
        return ScannerView();

      default:
        return Container(
          child: Center(
            child: CustomText("Error"),
          ),
        );
    }
  }
}
