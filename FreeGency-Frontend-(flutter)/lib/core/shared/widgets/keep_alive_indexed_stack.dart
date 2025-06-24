import 'package:flutter/material.dart';
import 'package:freegency_gp/core/shared/widgets/keep_alive_page.dart';
class KeepAliveIndexedStack extends StatelessWidget {
  const KeepAliveIndexedStack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
    this.sizing = StackFit.loose,
    this.index = 0,
    required this.children,
  });

  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final Clip clipBehavior;
  final StackFit sizing;
  final int? index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      alignment: alignment,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      sizing: sizing,
      index: index,
      children:
          children.map((child) => KeepAlivePage(child: child)).toList(),
    );
  }
}
// class _KeepAliveWidget extends StatefulWidget {
//   const _KeepAliveWidget({required this.child});

//   final Widget child;

//   @override
//   State<_KeepAliveWidget> createState() => _KeepAliveWidgetState();
// }

// class _KeepAliveWidgetState extends State<_KeepAliveWidget>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return widget.child;
//   }
// }
