//FLUTTER NATIVE
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StatusBars extends StatelessWidget {

  Color selectedColor;
  Color unselectedColor;
  int position;
  int totalElements;

  StatusBars({
    required this.selectedColor,
    required this.unselectedColor,
    required this.position,
    required this.totalElements
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _generateRows(),
    );
  }


  List<Widget> _generateRows(){
    List<Widget> all = [];
    Color c = this.selectedColor;
    EdgeInsets marg;
    EdgeInsets original = EdgeInsets.only(
      left: 5,
      right: 5
    );
    EdgeInsets first = EdgeInsets.only(
      left: 0,
      right: 5
    );
    EdgeInsets last = EdgeInsets.only(
      left: 5,
      right: 0
    );

    for(int i=1; i<=this.totalElements; i++){
      if(i> position){
        c = this.unselectedColor;
      }
      if(i==1){
        marg = first;
      }else if(i == this.totalElements){
        marg = last;
      }else{
        marg = original;
      }
      all.add(Expanded(
        child: Container(
          margin: marg,
          height: 6,
          color: c,
        ),
      ));
    }

    return all;
  }

}