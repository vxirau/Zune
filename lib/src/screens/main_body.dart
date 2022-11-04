//FLUTTER NATIVE
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//MODELS
import 'package:zune/src/models/utilities/app_colors.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/providers/loc_provider.dart';

//SCREENS
import 'package:zune/src/screens/screens.dart';

//PROVIDERS
import 'package:zune/src/providers/ui_provider.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';

//PAQUETS INSTALATS
import 'package:provider/provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';

class MainBody extends StatefulWidget {
  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  final routeObserver = RouteObserver<PageRoute>();

  GlobalKey _fabKey = GlobalKey();

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
        curve: Curves.decelerate,
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
void dispose() {
  _animationController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    UiProvider uiProvider = Provider.of<UiProvider>(context);

    final iconList = <IconData>[uiProvider.selectedMenuOpt == 0 ? Icons.home_filled : Icons.home_outlined, uiProvider.selectedMenuOpt == 1 ? Icons.person : Icons.person_outline_rounded];

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: HexColor.fromHex("#292828"),
        resizeToAvoidBottomInset: false,
        floatingActionButton: ScaleTransition(
          scale: animation,
          child: Container(
            height: 80.0,
            width: 80.0,
            child: FittedBox(
              child: Visibility(
                visible: uiProvider.isFABVisible,
                child: _buildFAB(context, uiProvider, width, height, key: _fabKey),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: uiProvider.selectedMenuOpt != 2
            ? AnimatedBottomNavigationBar(
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
              )
            : null,
        body: SafeArea(child: _HomePageBody()));
  }

  Widget _buildFAB(context, uiProvider, width, height, {key}) => FloatingActionButton(
        elevation: 8,
        backgroundColor: HexColor.fromHex("#DBFBB5"),
        child: Icon(
          Icons.view_in_ar_rounded,
          color: HexColor.fromHex("#8A66E6"),
          size: 30,
        ),
        onPressed: () => _onFabTap(context, uiProvider, width, height),
      );

  _onFabTap(BuildContext context, uiProvider, width, height) {
    setState(() => uiProvider.isFabVisible = false);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => ARView(),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => _buildTransition(child, animation, Size(80, 80), Offset(width / 2, height), width, height, uiProvider),
    ));
  }

  Widget _buildTransition(Widget page, Animation<double> animation, Size fabSize, Offset fabOffset, width, height, uiProvider) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: mounted ? MediaQuery.of(context).size : Size(0, 0),
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context, uiProvider, width, height),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size!.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
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
        return ARView();

      default:
        return Container(
          child: Center(
            child: CustomText("Error"),
          ),
        );
    }
  }
}
