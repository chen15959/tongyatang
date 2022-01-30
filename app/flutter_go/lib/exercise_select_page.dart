
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'exercise_lib.dart';


class ExerciseSelectPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ExerciseSelectPageState();
}


class ExerciseSelectPageState extends State<ExerciseSelectPage> {

  bool init_done = false;

  @override
  Widget build(BuildContext context) {

    if (exercises_tree.children.isEmpty) {
      if (!init_done) {
        load_exercise().then((value) =>
            setState(() {
              init_done = true;
            }));
        return Scaffold(
          appBar: AppBar(
            title: Text(r'练习题'),
            automaticallyImplyLeading: true,
          ),
          body: Center(
            child: Text(r'正在加载练习题 请稍候'),
          ),
        );
      }
      else {
        return Scaffold(
          appBar: AppBar(
            title: Text(r'练习题'),
            automaticallyImplyLeading: true,
          ),
          body: Center(
            child: Text(r'无法加载练习题'),
          ),
        );
      }
    }
    else {
      return Scaffold(
          appBar: AppBar(
            title: Text(r'练习题'),
            automaticallyImplyLeading: true,
          ),
          body: Center(
              child: ListView(
                children: _list2(exercises_tree, ''),
              )
          )
      );
    }
  }


  List<Widget> _list2(Node node, String leading_space) {
    List<Widget> ret = [];

    for (var elem in node.children) {
      if (elem is Exercise) {
        ret.add(ListTile(
          key: PageStorageKey<String>(elem.id),
          title: Text(leading_space + node.title + ': ' + elem.order),
          onTap: null, //TODO elem.id
        ));
      }
      else {
        ret.add(ExpansionTile(
          key: PageStorageKey<String>(elem.id),
          title: Text(leading_space + elem.title),
          children: _list2(elem, leading_space + '    '),
        ));
      }
    }

    return ret;
  }


}