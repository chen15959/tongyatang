



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go/position.dart';


abstract class GameController {
  int get current;
}

class Game extends StatefulWidget {
  final String definition;
  final String initialization;
  int current;
//  final String answer;

  Game({this.definition = 'FULL', this.initialization = '', this.current = 1});

  @override
  State<StatefulWidget> createState() => GameState();
}



class GameState extends State<Game> implements GameController {

  /// 当前的落子棋子是什么（点击后落子）
  @override
  int get current => widget.current;

  //void set current(int newValue) => _current = newValue;

  //int _current = 1;

  /// 改变当前落子棋子
  void switchCurrent() {
    widget.current = -widget.current;
  }

  /// 交换棋子颜色
  ///
  void turnOver() {
    setState(() {
      switchCurrent();
      for (PositionController? pc in _game) {
        pc?.turnOver();
      }
    });
  }

  void onValueChanged(dynamic positionValue) {
    if (positionValue is PositionValue) {
      //TODO
    }
  }


  List<PositionController?> _game = List<PositionController?>.filled(361, null);


  @override
  void initState() {
    super.initState();

    for (int b = 0; b < 19; ++b) {
      for (int a = 0; a < 19; ++a) {
        PositionController pc = PositionController(a, b, this, 0);
        pc.addListener(onValueChanged);
        _game[a * 19 + b] = pc;
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return buildBoard(context);
  }


  Widget buildBoard(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 150,
          child: _buildControlArea(context)
        ),
        SizedBox(height: 20),
        Expanded(
          child: Container(
            child: _buildBoardArea(context),
            padding: EdgeInsets.all(16),
          )
        )
      ],
    );
  }


  Widget _buildControlArea(BuildContext context) {
    return Row(children: [
        SizedBox(
          child: MaterialButton(
            child: Image(
              image: AssetImage('assets/' + current.toString() + '_current.png'),
              fit: BoxFit.fill,
            ),
            onPressed: () => setState(() => widget.current = -widget.current )
          ),
          width: 128, height: 128,
        ),
        SizedBox(width: 20,),
        SizedBox(
          child: MaterialButton(
            child: Image(
              image: AssetImage('assets/turnover.png'),
              fit: BoxFit.fill,
            ),
            onPressed: () => turnOver()
          ),
          width: 128, height: 128,
        ),

      ],
    );
  }

  Widget _buildBoardArea(BuildContext context) {
    List<Widget> positions = [];
    int a1 = 0, a2 = 19, b1 = 0, b2 = 19;

    try {
      String board = widget.definition.toLowerCase();

      if (board.contains('-')) {
        List<String> cmd = board.split('-');
        if (cmd.length == 2) {
          List<String> size = cmd[1].split(',');
          int x = int.parse(size[0]);
          int y = int.parse(size[1]);
          if (cmd[0] == 'lt' || cmd[0] == 'lefttop') {
            a1 = 0;
            a2 = x;
            b1 = 0;
            b2 = y;
          }
          else if (cmd[0] == 'tl' || cmd[0] == 'topleft') {
            a1 = 0;
            a2 = y;
            b1 = 0;
            b2 = x;
          }
          else if (cmd[0] == 'rt' || cmd[0] == 'righttop') {
            a1 = 19 - x;
            a2 = 19;
            b1 = 0;
            b2 = y;
          }
          else if (cmd[0] == 'tr' || cmd[0] == 'topright') {
            a1 = 0;
            a2 = y;
            b1 = 19-x;
            b2 = 19;
          }

        }
      }

      if (board.startsWith('lt-') || board.startsWith('lefttop-')) {
        List<String> size = board.split('-')[1].split(',');
        if (size.length == 2) {
          a1 = 0;
          a2 = int.parse(size[0]);
          b1 = 0;
          b2 = int.parse(size[1]);
        }
      }
      else if (board.startsWith('tl-') || board.startsWith('topleft-')) {
        List<String> size = board.split('-')[1].split(',');
        if (size.length == 2) {
          a1 = 0;
          a2 = int.parse(size[2]);
          b1 = 0;
          b2 = int.parse(size[1]);
        }
      }
      else if (board.startsWith('tr-') || board.startsWith('topright-')) {

      }
      //TODO
    }
    catch (ex) {
    }

    for (int b = b1; b < b2; ++b) {
      for (int a = a1; a < a2; ++a) {
        // PositionController pc = PositionController(a, b, this, 0);
        // pc.addListener(onValueChanged);
        //  = pc;

        if (a == 0) {
          if (b == 0) {
            positions.add(Position('LT', _game[a * 19 + b]));
          }
          else if (b == 18) {
            positions.add(Position('LB', _game[a * 19 + b]));
          }
          else {
            positions.add(Position('L', _game[a * 19 + b]));
          }
        }
        else if (a == 18) {
          if (b == 0) {
            positions.add(Position('RT', _game[a * 19 + b]));
          }
          else if (b == 18) {
            positions.add(Position('RB', _game[a * 19 + b]));
          }
          else {
            positions.add(Position('R', _game[a * 19 + b]));
          }
        }
        else {
          if (b == 0) {
            positions.add(Position('T', _game[a * 19 + b]));
          }
          else if (b == 18) {
            positions.add(Position('B', _game[a * 19 + b]));
          }
          else {
            positions.add(Position('C', _game[a * 19 + b]));
          }
        }
      }
    }


    return GridView.count(
      crossAxisCount: a2 - a1,
      childAspectRatio: 1,
      //padding: EdgeInsets.all(5),
      children: positions,
    );
  }


}