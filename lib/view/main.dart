import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/connectivity.dart';
import 'package:lidea/view/main.dart';
// import 'package:lidea/icon.dart';
// import 'package:lidea/extension.dart';

import '/core/main.dart';
// import '/type/main.dart';

import 'routes.dart';

part 'view.dart';
part 'launcher.dart';
part 'other.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static const route = '/root';

  @override
  _State createState() => AppView();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController(keepPage: true);
  final _controller = ScrollController();

  late StreamSubscription<ConnectivityResult> _connection;

  // late final Core core = Provider.of<Core>(context, listen: false);
  late final Core core = context.read<Core>();
  // late final NavigationNotify _navigationNotify = context.read<NavigationNotify>();

  late final Future<void> initiator = core.init(context);

  Preference get preference => core.preference;
  List<ViewNavigationModel> get _pageButton => AppPageNavigation.button(preference);

  late final List<Widget> _pageView = AppPageNavigation.page;

  @override
  void initState() {
    super.initState();
    core.navigate = navigate;

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      // ConnectivityResult.mobile
      // ConnectivityResult.wifi
      // ConnectivityResult.none
    });
  }

  @override
  void dispose() {
    // core.store?.subscription?.cancel();
    _controller.dispose();
    super.dispose();
    _connection.cancel();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void Function()? _navButtonAction(ViewNavigationModel item, bool disable) {
    if (disable) {
      return null;
    } else if (item.action == null) {
      return () => _navPageViewAction(item.key);
    } else {
      return item.action;
    }
  }

  void _navPageViewAction(int index) {
    core.navigation.index = index;
    ViewNavigationModel page = _pageButton.firstWhere(
      (e) => e.key == index,
      orElse: () => _pageButton.first,
    );
    final screenName = core.collection.screenName(page.name);
    // final screenClass = core.collection.screenClass(page.name);
    final screenClass = core.collection.screenClass(core.navigation.name);

    core.analytics.screen(screenName, screenClass);

    // NOTE: check State isMounted
    // if(page.key.currentState != null){
    //   page.key.currentState.setState(() {});
    // }
    _pageController.jumpToPage(index);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  void navigate({int at = 0, String? to, Object? args, bool routePush = true}) {
    if (core.navigation.index != at) {
      _navPageViewAction(at);
    }
    final _vi = AppRoutes.homeNavigator;
    final state = _vi.currentState;
    if (to != null && state != null) {
      final canPop = state.canPop();
      // final canPop = Navigator.canPop(context);
      final arguments = ViewNavigationArguments(
        navigator: _vi,
        args: args,
        canPop: canPop,
      );
      if (routePush) {
        state.pushNamed(to, arguments: arguments);
        // Navigator.of(context).pushNamed(to, arguments: arguments);
      } else {
        state.pushReplacementNamed(to, arguments: arguments);
        // Navigator.of(context).pushReplacementNamed(to, arguments: arguments);
      }
      final screenName = core.collection.screenName(to);
      final screenClass = core.collection.screenClass(core.navigation.name);
      core.analytics.screen(screenName, screenClass);
    }
  }
}
