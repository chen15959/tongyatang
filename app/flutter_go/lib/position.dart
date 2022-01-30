import 'package:flutter/cupertino.dart';

import 'event.dart';
import 'game.dart';

/// 这个控件对应着棋盘上的一个交叉点
/// 根据位置不同，type通过0~15来表示画不画某条线 x&1 -> 中心向上 x&2 ->中心向右 x&4 ->中心向下 x&8 ->中心向左
/// value 0 空 -1 黑棋 1 白棋
///
///


class PositionValue {
  int x;
  int y;
  int value;

  PositionValue(this.x, this.y, this.value);

  @override
  bool operator ==(Object other) {
    return other is PositionValue && other.x == this.x && other.y == this.y && other.value == this.value;
  }

}


class Position extends StatefulWidget {

  final String type;

  final PositionController? controller;

  Position(this.type, this.controller) {
    //print(type + "\tx=" + this.controller.value.x.toString() + "\ty=" + this.controller.value.y.toString() + "\n");
  }


  @override
  State<StatefulWidget> createState() => PositionState();

}



class PositionState extends State<Position> {
  @override
  Widget build(BuildContext context) {
    widget.controller?.addListener(_onValueChanged);

    return GestureDetector(
      child: Image(
        image: AssetImage('assets/' + widget.controller.toString() + '_' + widget.type + '.png'),
        fit: BoxFit.fill,
      ),
      onTap: () => widget.controller?.setValue(),
      onDoubleTap: () => widget.controller?.setClear(),
    );
  }

  void _onValueChanged(dynamic v) {
    setState(() {
    });
  }
}



class PositionController extends MyValueNotifier<PositionValue> {

  GameController _gameController;


  PositionController(int x, int y, this._gameController, int initValue) : super(PositionValue(x, y, initValue));

  void setValue() {
    super.value = PositionValue(super.value.x, super.value.y, _gameController.current);
  }

  void turnOver() {
    super.value.value = -super.value.value;
  }

  void setClear() {
    super.value = PositionValue(super.value.x, super.value.y, 0);
  }

  @override
  String toString() {
    return super.value.value.toString();
  }

}