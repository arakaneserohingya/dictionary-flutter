part of 'main.dart';

mixin _Bar on _State {
  Widget bar(bool hasValue) {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight, 50],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            // TweenAnimationBuilder<double>(
            //   tween: Tween<double>(begin: arguments.canPop ? 0 : 30, end: 0),
            //   duration: const Duration(milliseconds: 300),
            //   builder: (BuildContext context, double align, Widget? child) {
            //     return Positioned(
            //       left: align,
            //       top: 0,
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            //         child: (align == 0)
            //             ? Hero(
            //                 tag: 'appbar-left',
            //                 child: CupertinoButton(
            //                   padding: EdgeInsets.zero,
            //                   minSize: 30,
            //                   onPressed: () => Navigator.of(context).pop(),
            //                   child: WidgetLabel(
            //                     icon: CupertinoIcons.left_chevron,
            //                     label: translate.back,
            //                   ),
            //                 ),
            //               )
            //             : WidgetLabel(
            //                 icon: CupertinoIcons.left_chevron,
            //                 label: translate.back,
            //               ),
            //       ),
            //     );
            //   },
            // ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: canPop ? 30 : 0, end: 0),
              duration: const Duration(milliseconds: 300),
              builder: (BuildContext context, double align, Widget? child) {
                return Positioned(
                  left: align,
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    child: canPop
                        ? (align == 0)
                            ? Hero(
                                tag: 'appbar-left-$canPop',
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minSize: 30,
                                  onPressed: () {
                                    arguments.navigator!.currentState!.maybePop();
                                  },
                                  child: WidgetLabel(
                                    icon: CupertinoIcons.left_chevron,
                                    label: preference.text.back,
                                    // label: AppLocalizations.of(context)!.back,
                                  ),
                                ),
                              )
                            : WidgetLabel(
                                icon: CupertinoIcons.left_chevron,
                                label: preference.text.back,
                              )
                        : const SizedBox(),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, .5),
                snap.shrink,
              )!,
              child: Hero(
                tag: 'appbar-center',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    preference.text.favorite(false),
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: (30 * org.shrink).clamp(22, 30).toDouble()),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                child: Hero(
                  tag: 'appbar-right',
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 30,
                    child: const WidgetLabel(
                      icon: LideaIcon.trash,
                    ),
                    onPressed: hasValue
                        ? () {
                            doConfirmWithDialog(
                              context: context,
                              // message: 'Do you really want to delete all?',
                              message: preference.text.confirmToDelete('all'),
                            ).then((bool? confirmation) {
                              if (confirmation != null && confirmation) onClearAll();
                            });
                          }
                        : null,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}