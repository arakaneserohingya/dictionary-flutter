import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view/main.dart';
// import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/store';
  static const icon = Icons.shopping_bag;
  static const name = 'Store';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        // controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 50],
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      cartWidget(),
    ];
  }

  Widget cartWidget() {
    return Consumer<Core>(
      builder: (BuildContext _, Core core, Widget? child) => buildContainer(),
    );
  }

  Widget buildContainer() {
    List<Widget> sliverChildren = [];
    if (store.errorMessage.isEmpty) {
      sliverChildren.add(
        Column(
          children: [
            _buildProductList(),
            _buildDescription(),
            // _buildConsumableBox(),
            // _buildPurchasesBox()
          ],
        ),
      );
    } else {
      if (store.isPending) {
        sliverChildren.add(const Center(
          child: CircularProgressIndicator(),
        ));
      } else {
        sliverChildren.add(Center(
          child: Text(store.errorMessage),
        ));
      }
    }

    // if (store.isPending) {
    //   _lst.add(
    //     CircularProgressIndicator()
    //   );
    // }
    // sliverChildren.add(
    //   Center(
    //     child: CircularProgressIndicator(
    //       value: 0.7,
    //     ),
    //   )
    // );

    return SliverList(delegate: SliverChildListDelegate(sliverChildren));
  }

  Widget _buildDescription() {
    Widget msgWidget = const Text('Getting products...');
    Widget msgIcon = CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColorDark,
      strokeWidth: 2,
    );

    if (store.isLoading) {
      // NOTE: Connecting to store...
      // } else if (store.isPending) {
      //   msgWidget = const Text('A moment please');
    } else if (store.isAvailable) {
      // NOTE: Purchase is ready, Purchase is available
      msgWidget = Text(
        core.collection.language('ready-to-contribute'),
        style: const TextStyle(fontSize: 20),
      );
      msgIcon = const Icon(Icons.local_police_outlined, size: 50);
    } else {
      // NOTE: Connected to store, but purchase is not ready yet
      msgWidget = const Text('Purchase unavailable');
      msgIcon = const Icon(Icons.error_outlined, size: 50);
    }
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: msgIcon),
          Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: msgWidget),
          _buildConsumableStar(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Text(
              core.collection.language('any-contribute-make'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (store.isLoading) {
      return const Card(child: Text('...'));
    }

    if (!store.isAvailable) {
      return const Card();
    }

    List<Widget> itemsWidget = <Widget>[];

    String storeName = Platform.isAndroid ? 'Play Store' : 'App Store';

    if (store.listOfPurchaseDetail.isEmpty && !store.isAvailable) {
      itemsWidget.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Text('Unable to connect with $storeName!'),
          ),
        ),
      );
    }
    // This app needs special configuration to run. Please see example/README.md for instructions.
    if (store.listOfNotFoundId.isNotEmpty) {
      itemsWidget.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            // child: Text('[${listOfNotFoundId.join(", ")}] not found',
            //   style: TextStyle(color: ThemeData.light().errorColor)
            // )
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Unavailable ',
                style: TextStyle(color: Theme.of(context).primaryColor),
                children: store.listOfNotFoundId
                    .map(
                      (String e) => TextSpan(
                          style: TextStyle(color: Theme.of(context).errorColor), text: "$e, "),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      );
    }

    itemsWidget.addAll(
      store.listOfProductDetail.map(
        (item) {
          return _buildProductItem(item);
        },
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: itemsWidget,
    );
  }

  Widget _buildProductItem(var item) {
    // String title = item.title;
    // String description = item.description;
    // if (title.isEmpty) {
    //   final ev = store.itemOfProduct(item.id);
    //   title = ev.title;
    //   description = ev.description;
    // }
    final title = core.collection.language('${item.id}-title');
    final description = core.collection.language('${item.id}-description');

    final hasPurchased = store.purchasedCheck(item.id);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              // contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: hasPurchased
                  ? Icon(
                      Icons.verified_rounded,
                      color: Theme.of(context).highlightColor,
                      size: 35,
                    )
                  : null,
              title: Text(
                title.replaceAll(RegExp(r'\(.+?\)$'), ""),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 25),
              ),
            ),
            Builder(
              builder: (BuildContext _) {
                if (hasPurchased) {
                  return const SizedBox();
                }
                return WidgetButton(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  color: Theme.of(context).highlightColor,
                  borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: store.listOfProcess.contains(item.id)
                            ? CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 2,
                              )
                            : Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                      ),
                      const Divider(
                        indent: 10,
                      ),
                      Text(
                        item.price,
                        semanticsLabel: item.price,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => store.doPurchase(item),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                description,
                semanticsLabel: description,
                // textScaleFactor:0.9,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumableStar() {
    if (store.isLoading) {
      return const Text('...');
    }

    // !isAvailable || listOfNotFoundId.contains(consumableId)
    if (!store.isAvailable) {
      return const Text('not Available: star');
    }

    return Selector<Core, Iterable<PurchasesType>>(
      selector: (BuildContext _, Core core) => core.collection.boxOfPurchases.valuesWhere((e) {
        return e.consumable == true && !store.listOfNotFoundId.contains(e.productId);
      }),
      builder: (BuildContext _, Iterable<PurchasesType> data, Widget? child) {
        return Card(
          child: Wrap(
            // _kOfConsumable.data
            children: data
                .map(
                  (PurchasesType e) => IconButton(
                    icon: const Icon(Icons.star),
                    iconSize: 35,
                    color: Theme.of(context).primaryColorDark,
                    // onPressed: () async => _buildConsumableDialog(e.productId)
                    onPressed: () {
                      doConfirmWithDialog(context: context, message: 'Are you sure to remove?')
                          .then(
                        (bool? confirmation) {
                          // debugPrint('TODO: Consumable consume');
                          if (confirmation != null && confirmation) {
                            store.doConsume(e.purchaseId!);
                          }
                        },
                      );
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  // Widget _buildPurchasesBox() {
  //   if (store.isLoading) {
  //     return const Card(child: Text('loading'));
  //   }

  //   if (!store.isAvailable) {
  //     return const Text('not Available box');
  //   }

  //   return Selector<Core, Iterable<PurchasesType>>(
  //     selector: (BuildContext _, Core core) => core.collection.boxOfPurchase.values
  //         .toList()
  //         .where((e) => e.consumable == false && !store.listOfNotFoundId.contains(e.productId)),
  //     builder: (BuildContext _, Iterable<PurchasesType> data, Widget? child) {
  //       return Card(
  //         child: Wrap(
  //           // _kOfPurchase.data
  //           children: data
  //               .map(
  //                 (PurchasesType e) => ListTile(
  //                   title: Text(e.productId),
  //                   // subtitle: Text(e.value.type +': press to consume it'),
  //                   onTap: () {
  //                     doConfirmWithDialog(context: context, message: 'Are you sure to remove?')
  //                         .then(
  //                       (bool? confirmation) {
  //                         // debugPrint('TODO: Purchase consume');
  //                         if (confirmation != null && confirmation) {
  //                           store.doConsume(e.purchaseId!);
  //                         }
  //                       },
  //                     );
  //                   },
  //                 ),
  //               )
  //               .toList(),
  //         ),
  //       );
  //     },
  //   );
  // }
}
