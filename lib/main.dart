import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter/scheduler.dart' show timeDilation;

// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/idea.dart';
// import 'package:lidea/connectivity.dart';

import 'package:dictionary/core.dart';
import 'package:dictionary/theme.dart';
import 'package:dictionary/view/app.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  return runApp(Dictionary());
}

class Dictionary extends StatelessWidget {
  Dictionary({Key? key, this.initialRoute}) : super(key: key);

  final String? initialRoute;

  @override
  Widget build(BuildContext context){
    return IdeaModel(
      initialModel: IdeaTheme(
        themeMode: ThemeMode.system,
        textFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTesting: true
      ),
      child: appProvider()
    );
  }

  Widget appProvider(){
    return MultiProvider(
      providers: [
        // Provider(create: (context) => TestCore),
        // ChangeNotifierProxyProvider<TestCore, TestCoreNotifier>(
        //   create: (context) => TestCoreNotifier(),
        //   update: (context, data, form) {
        //     if (form == null) throw ArgumentError.notNull('form');
        //     // form.searchQuery = data.searchQuery;
        //     // form.keyword = data.keyword;
        //     // form.store = Store();
        //     // form.initiator = data.init();
        //     // initiator
        //     return form;
        //   },
        // ),
        // ChangeNotifierProvider<Core>(
        //   create: (context) => Core(),
        //   // child: MyHomePage(),
        // ),
        // ProxyProvider<TestCore, TestCoreNotifier>(
        //   update: (context, data, form) => TestCoreNotifier()
        // ),
        // ProxyProvider<StoreNotifier, Store>(
        //   update: (context, data, form) => Store()
        // ),
        // ChangeNotifierProvider<FormNotifier>(
        //   create: (context) => FormNotifier(),
        // ),
        ChangeNotifierProvider<Core>(
          create: (context) => Core(),
          // child: MyHomePage(),
        ),
      ],
      child:  app()
    );
  }
  Widget app(){
    return Builder(
      builder: (context) => uiOverlayStyle(
        has: IdeaTheme.of(context).resolvedSystemBrightness == Brightness.light,
        brightness: IdeaTheme.of(context).resolvedSystemBrightness,
        child: MaterialApp(
          title: "MyOrdbok",
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,
          darkTheme: IdeaData.dark.copyWith(
            platform: IdeaTheme.of(context).platform,
            brightness: IdeaTheme.of(context).systemBrightness
          ),
          theme: IdeaData.light.copyWith(
            platform: IdeaTheme.of(context).platform,
            brightness: IdeaTheme.of(context).systemBrightness
          ),
          themeMode: IdeaTheme.of(context).themeMode,
          // localizationsDelegates: const [
          //   ...GalleryLocalizations.localizationsDelegates,
          //   LocaleNamesLocalizationsDelegate()
          // ],
          // supportedLocales: GalleryLocalizations.supportedLocales,
          locale: IdeaTheme.of(context).locale,
          localeResolutionCallback: (locale, supportedLocales) => locale,
          // initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
            builder: (context) => ApplyTextOptions(
              child: AppMain(key: key)
            ),
            settings: settings
          )
          // onUnknownRoute: RouteConfiguration.onUnknownRoute,
        )
      )
    );
  }

  // Widget uiOverlayStyle({Brightness brightness, bool has, Widget child}){
  Widget uiOverlayStyle({required Brightness brightness, required bool has, required Widget child}){
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness,
        systemNavigationBarColor: has?IdeaData.darkScheme.primary:IdeaData.lightScheme.primary,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness
      ),
      child: child
    );
  }
}