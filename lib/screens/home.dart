import 'package:flutter/material.dart';
import 'package:todoapp_flutter/constants/colors.dart';
import 'package:todoapp_flutter/model/todo.dart';
import 'package:todoapp_flutter/widgets/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = ToDo.toDoList();
  List<ToDo> _foundToDo = [];
  final _toDoController = TextEditingController();

  @override
void initState() {
  _loadToDoList();
  super.initState();
}

void _loadToDoList() async {
  final prefs = await SharedPreferences.getInstance();
  final todoListString = prefs.getStringList('todoList') ?? [];

  setState(() {
    todoList.clear();
    for (final todoText in todoListString) {
      todoList.add(ToDo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        toDoText: todoText,
      ));
    }
    _foundToDo = todoList;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(children: [
              searchBox(),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50, bottom: 20),
                      child: Text('¿Qué tengo que hacer?',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    for (ToDo todo in _foundToDo.reversed)
                      toDoItem(
                          todo: todo,
                          onTodoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem),
                  ],
                ),
              )
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _toDoController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: 'Agrega una nueva tarea',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    _addToDoItem(_toDoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }

 void _addToDoItem(String toDo) async {
  final prefs = await SharedPreferences.getInstance();
  final todoListString = prefs.getStringList('todoList') ?? [];

  setState(() {
    todoList.add(ToDo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      toDoText: toDo,
    ));
  });

  todoListString.add(toDo);
  prefs.setStringList('todoList', todoListString);

  _toDoController.clear();
}

  void _runFilter(String enteredKeywords) {
    List<ToDo> results = [];
    if (enteredKeywords.isEmpty) {
      results = todoList;
    } else {
      results = todoList
          .where((item) => item.toDoText!
              .toLowerCase()
              .contains(enteredKeywords.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: 'Buscar',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: tdBGColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.menu,
              color: tdBlack,
              size: 30,
            ),
            Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset('assets/images/download.jpg')),
            )
          ],
        ));
  }
}
