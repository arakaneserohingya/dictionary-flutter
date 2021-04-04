import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lidea/scroll.dart';
import 'package:lidea/idea.dart';
import 'package:dictionary/core.dart';
// import 'package:dictionary/widget.dart';

part 'bar.dart';
part 'view.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final core = Core();
  final controller = ScrollController();

  AnimationController animationController;

  int testCounter = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    animationController.animateTo(1.0);
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }
}
