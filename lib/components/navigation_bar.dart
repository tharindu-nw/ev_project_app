import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart';
import 'navigation_bar_item.dart';

// ignore: must_be_immutable
class TitledBottomNavigationBar extends StatefulWidget {
  final bool reverse;
  final Curve curve;
  final Color activeColor;
  final Color inactiveColor;
  final Color indicatorColor;
  final int initialIndex;
  int currentIndex;
  // final ValueChanged<int> onTap;
  final List<TitledNavigationBarItem> items;

  TitledBottomNavigationBar({
    Key key,
    this.reverse = false,
    this.curve = Curves.linear,
    // @required this.onTap,
    @required this.items,
    this.activeColor = const Color(0xFF090446),
    this.inactiveColor,
    this.indicatorColor,
    this.initialIndex = 0,
    this.currentIndex = 0,
  }) : super(key: key) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 5);
    // assert(onTap != null);
    assert(initialIndex != null);
  }

  @override
  State createState() => _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState extends State<TitledBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  static const double BAR_HEIGHT = 60;
  static const double INDICATOR_HEIGHT = 4;

  bool get reverse => widget.reverse;
  Curve get curve => widget.curve;
  List<TitledNavigationBarItem> get items => widget.items;

  double width = 0;
  Color activeColor;
  Duration duration = Duration(milliseconds: 180);

  @override
  void initState() {
    // select a default item
    widget.currentIndex = widget.currentIndex ?? widget.initialIndex;

    _select(widget.currentIndex);

    super.initState();
  }

  double _getIndicatorPosition(int index) {
    print(index);
    print(items.length);
    return (-1 + (2 / (items.length - 1) * index));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    activeColor = widget.activeColor ?? Theme.of(context).indicatorColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: BAR_HEIGHT,
          width: width,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                top: INDICATOR_HEIGHT,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: items.map((item) {
                    var index = items.indexOf(item);
                    return GestureDetector(
                      onTap: () => _select(index),
                      child:
                          _buildItemWidget(item, index == widget.currentIndex),
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                top: 0,
                width: width,
                child: AnimatedAlign(
                  alignment:
                      Alignment(_getIndicatorPosition(widget.currentIndex), 0),
                  curve: curve,
                  duration: duration,
                  child: Container(
                    color: widget.indicatorColor ?? activeColor,
                    width: width / items.length,
                    height: INDICATOR_HEIGHT,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _select(int index) {
    widget.currentIndex = index;
    // widget.onTap(widget.currentIndex);

    setState(() {});
  }

  Widget _buildIcon(TitledNavigationBarItem item) {
    return Icon(
      item.icon,
      color: reverse ? widget.inactiveColor : activeColor,
    );
  }

  Widget _buildText(TitledNavigationBarItem item) {
    return Text(
      item.title,
      style: TextStyle(color: reverse ? activeColor : widget.inactiveColor),
    );
  }

  Widget _buildItemWidget(TitledNavigationBarItem item, bool isSelected) {
    return Container(
      color: item.backgroundColor,
      height: BAR_HEIGHT,
      width: width / items.length,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: isSelected ? 0.0 : 1.0,
            duration: duration,
            curve: curve,
            child: reverse ? _buildIcon(item) : _buildText(item),
          ),
          AnimatedAlign(
            duration: duration,
            alignment: isSelected ? Alignment.center : Alignment(0, 2.6),
            child: reverse ? _buildText(item) : _buildIcon(item),
          ),
        ],
      ),
    );
  }
}
