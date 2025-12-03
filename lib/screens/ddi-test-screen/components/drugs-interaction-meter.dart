import 'package:flutter/material.dart';

class DrugsInteractionMeter extends StatelessWidget {
  final double? width;
  final int index;

  List<Widget> gridItems = [
    SizedBox(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
    Container(color: Color(0xff29A336)),
    Container(color: Color(0xff948B35)),
    Container(color: Color(0xffFF7333)),
    Container(color: Color(0xffF44C30)),
    Container(color: Color(0xffE8242D)),
  ];

  DrugsInteractionMeter(this.index, {this.width, super.key})
    : assert(index >= 0 && index <= 4);

  @override
  Widget build(BuildContext context) {
    gridItems[index] = Icon(Icons.arrow_drop_down_outlined);
    return SizedBox(
      width: width,
      child: GridView.count(
        crossAxisCount: 5,
        childAspectRatio: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridItems,
      ),
    );
  }
}
