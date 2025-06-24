import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freegency_gp/Features/home/presentation/view_model/cubits/client_home_page/client_home_page_cubit.dart';

class HomeScrollHandler extends StatefulWidget {
  final Widget child;
  final ClientHomePageCubit cubit;
  final int currentIndex;

  const HomeScrollHandler({
    super.key,
    required this.child,
    required this.cubit,
    required this.currentIndex,
  });

  @override
  State<HomeScrollHandler> createState() => _HomeScrollHandlerState();
}

class _HomeScrollHandlerState extends State<HomeScrollHandler> {
  ScrollController? _currentController;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  @override
  void didUpdateWidget(HomeScrollHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _setupScrollListener();
    }
  }

  void _setupScrollListener() {
    // Remove listener from previous controller
    _currentController?.removeListener(_handleScroll);

    // Get current active scroll controller
    _currentController =
        widget.cubit.getCurrentScrollController(widget.currentIndex);

    // Add listener to new controller
    _currentController?.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_currentController == null || !_currentController!.hasClients) return;

    final scrollDirection = _currentController!.position.userScrollDirection;

    if (scrollDirection == ScrollDirection.reverse) {
      if (widget.cubit.isFabVisible) {
        widget.cubit.updateFabVisibility(false);
      }
    } else if (scrollDirection == ScrollDirection.forward) {
      if (!widget.cubit.isFabVisible) {
        widget.cubit.updateFabVisibility(true);
      }
    }
  }

  @override
  void dispose() {
    _currentController?.removeListener(_handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
