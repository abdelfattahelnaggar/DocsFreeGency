import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
class KeepAlivePage extends StatefulWidget {
  const KeepAlivePage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
class KeepAlivePageView extends StatelessWidget {
  const KeepAlivePageView({
    super.key,
    this.controller,
    this.onPageChanged,
    required this.children,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.physics,
    this.pageSnapping = true,
    this.padEnds = true,
  });

  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final List<Widget> children;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollPhysics? physics;
  final bool pageSnapping;
  final bool padEnds;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: onPageChanged,
      scrollDirection: scrollDirection,
      reverse: reverse,
      physics: physics,
      pageSnapping: pageSnapping,
      padEnds: padEnds,
      children: children.map((child) => KeepAlivePage(child: child)).toList(),
    );
  }
}
class KeepAliveTabBarView extends StatelessWidget {
  const KeepAliveTabBarView({
    super.key,
    required this.controller,
    required this.children,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
  });

  final TabController controller;
  final List<Widget> children;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final double viewportFraction;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics,
      dragStartBehavior: dragStartBehavior,
      viewportFraction: viewportFraction,
      clipBehavior: clipBehavior,
      children: children.map((child) => KeepAlivePage(child: child)).toList(),
    );
  }
}
