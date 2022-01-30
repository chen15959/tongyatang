import 'dart:convert';
import 'dart:collection';

import 'package:http/http.dart' as HTTP;

class Exercise {
  final String id;
  final String order;

  final String title;
  final String text;
  final String board;
  final String offensive;
  final String question;
  final String answer;


  Exercise(this.id, this.order, this.title, this.text, this.board, this.offensive, this.question, this.answer);
}

class Node {
  final String id;
  final String title;
  final String text;

  List<dynamic> children = [];

  Node(this.id, this.title, this.text);

}



final String URL = 'https://raw.githubusercontent.com/chen15959/tongyatang/master/content/';

Node exercises_tree = Node('', '', '');
HashMap<String, dynamic> exercises_map = HashMap();
List<String> exercises_list = [];

Future<bool> load_exercise() async {
    try {
      HTTP.Response response = await HTTP.get(
          URL + 'index.json', headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var result = json.decode(response.body)['children'];
        for (Map elem in result) {
          Node node = Node(
              elem['order'].toString(), elem['name'], '');

          try {
            response = await HTTP.get(URL + elem['file'],
                headers: {'Content-Type': 'application/json'});
            if (response.statusCode == 200) {
              for (var elem in json.decode(response.body)['children']) {
                attach(node, elem);
              }
            }
            else {
              continue;
            }
          }
          catch (ex) {
            continue;
          }

          exercises_tree.children.add(node);
        }
      }
    }
    catch (ex) {
      int i = 10;
      i = i + 5;

    }


    walk_through(exercises_tree);



  // }
  // catch (ex) {
  //   //TODO load from local
  //
  //
  // }

  return false;
}


bool attach(Node node, Map json) {
   try {
     if (json.containsKey('question')) {
       node.children.add(Exercise(node.id + '.' + json['order'].toString(), json['order'].toString(), node.title, node.text, json['board'], json['offensive'], json['question'], json['answer']));
     }
     else {
       Node node1 = Node(node.id + '.' + json['order'].toString(), json['title'], json['text']);
       for (Map child in json['children']) {
         attach(node1, child);
       }
       node.children.add(node1);

     }


     // for (Map elem in json['children']) {
     //   if (elem.containsKey('question')) {
     //     node.children.add(Exercise(node.id + '.' + elem['order'], node.text, elem['board'], elem['offensive'], elem['question'], elem['answer']));
     //   }
     //   else {
     //     Node node1 = Node(node.id + '.' + elem['order'], elem['title'], elem['text']);
     //     for (Map elem1 in elem['children']) {
     //       attach(node1, elem1);
     //     }
     //     node.children.add(node1);
     //   }


//     }
   }
   catch (ex) {
     int a = 10;
     a = a + 3;
   }

   return false;
}


void walk_through(Node node) {
  for (var child in node.children) {
    if (child is Exercise) {
      exercises_map.putIfAbsent(child.id, () => child);
      exercises_list.add(child.id);
    }
    else {
      walk_through(child);
    }
  }
}


String getPrev(String id) {
  for (int i = 0; i < exercises_list.length; ++i) {
    if (exercises_list[i] == id) {
      if (i == 0) {
        break;
      }
      else {
        return exercises_list[i - 1];
      }
    }
  }

  return '';
}


String getNext(String id) {
  for (int i = 0; i < exercises_list.length; ++i) {
    if (exercises_list[i] == id) {
      if (i == exercises_list.length - 1) {
        break;
      }
      else {
        return exercises_list[i + 1];
      }
    }
  }

  return '';
}