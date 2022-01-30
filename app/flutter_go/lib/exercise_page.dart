import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go/exercise_lib.dart';

import 'game.dart';
import 'position.dart';


class ExercisePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ExercisePageState();

}


class ExercisePageState extends State<ExercisePage> {

  String _questionId = '';

  @override
  Widget build(BuildContext context) {

    if (_questionId.isEmpty) {
      _questionId = ModalRoute.of(context)!.settings.arguments.toString();
    }

    Exercise? exercise = exercises_map[_questionId];
    if (exercise == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('找不到练习题'),
        ),
        body: Container(),
      );
    }

    String prev = getPrev(_questionId);
    String next = getNext(_questionId);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(exercise.title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              MaterialButton(child: Text(r'上一题'),
                onPressed: prev.isEmpty ? null : () => setState(() => _questionId = prev)),
              MaterialButton(child: Text(r'交卷'),
                onPressed: null), //TODO
              MaterialButton(child: Text(r'下一题'),
                onPressed: next.isEmpty ? null : () => setState(() => _questionId = next))
            ],
          ),
          SizedBox(height: 10,),
          Text(exercise.text),//TODO
          SizedBox(height: 10,),
          Game(definition: exercise.board, initialization: exercise.question,)


      ],
    )
    );

  }


  Widget buildGame(BuildContext context, Exercise exercise) {
    //TODO
    return Container();
  }


  String readQuestion(String question) {
    //TODO
    return '';

  }

}