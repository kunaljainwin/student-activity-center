import 'package:flutter/material.dart';

class SplashContainer extends StatefulWidget {
  final Widget wid;
  final double splashRadius;
  final onDoubleTap;

  final double padding;

  final VoidCallback? onTap;
  const SplashContainer(
      {Key? key,
      required this.wid,
      required this.splashRadius,
      this.padding = 8.0,
      this.onDoubleTap,
      this.onTap})
      : super(key: key);

  @override
  State<SplashContainer> createState() => _SplashContainerState();
}

class _SplashContainerState extends State<SplashContainer> {
  @override
  Widget build(BuildContext context) {
    bool coloredBack = false;
    return StatefulBuilder(builder: (context, set) {
      return Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          onEnd: widget.onTap,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.splashRadius),
            boxShadow: [
              BoxShadow(
                  color: coloredBack ? Colors.black38 : Colors.transparent,
                  spreadRadius: 0.0,
                  blurStyle: BlurStyle.outer,
                  blurRadius: coloredBack ? 4 : 0)
            ],
          ),
          // curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 300),
          child: InkWell(
              borderRadius: BorderRadius.circular(widget.splashRadius),
              onTap: () async {
                set(() {
                  coloredBack = !coloredBack;
                });
                await Future.delayed(Duration(milliseconds: 200)).then((value) {
                  set(() {
                    coloredBack = !coloredBack;
                  });
                });
              },
              onDoubleTap: widget.onDoubleTap,
              child: Padding(
                padding: EdgeInsets.all(widget.padding),
                child: widget.wid,
              )),
        ),
      );
    });
  }
}
