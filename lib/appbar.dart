import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
 
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueListenable<bool> isVisible;
  final GlobalKey<ScaffoldState> skey;
  final ValueSetter<String> onPressed;
  @override
  final Size preferredSize;
  const HomeAppBar({
    super.key,
    required this.isVisible,
    required this.skey,
    required this.onPressed,
  }) : preferredSize = const Size.fromHeight(70.0);

  static const headeritalic = TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontSize: 18,
    letterSpacing: 1,

    //fontFamily:
  );
  static const header = TextStyle(
    color: Colors.white,
    fontSize: 18,
    letterSpacing: 1,
    //fontFamily:
  );
  static const headerunder = TextStyle(
    color: Colors.white,
    decoration: TextDecoration.underline,
    decorationThickness: 1.6,
    decorationColor: Colors.white,

    fontSize: 18,
    letterSpacing: 1,
    //  fontWeight: FontWeight.w500,
    //fontFamily:
  );

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
      valueListenable: isVisible,
      builder: (BuildContext context, dynamic value, Widget? child) => ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: AnimatedContainer(
                color: value
                    ? const Color.fromRGBO(27, 25, 27, 0.4)
                    : const Color.fromRGBO(27, 25, 27, 0.1),
                duration: const Duration(milliseconds: 200),
                height: value ? 70 : 0,
                //    padding: EdgeInsets.symmetric(horizontal: mediaQueryData.size.width * .1),
                child: TextField(
                  decoration: const InputDecoration(hintText: "Search"),
                  onSubmitted: (text) => onPressed(text),
                ),
              ),
            ),
          ));
}
