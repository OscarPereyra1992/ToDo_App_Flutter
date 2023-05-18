class ToDo{
  String? id;
  String? toDoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.toDoText,
    this.isDone = false,

  });

  static List<ToDo> toDoList(){
    return[
      ToDo(id: '01', toDoText: 'Texto de prueba', isDone: true),
      ToDo(id: '02', toDoText: 'Texto de prueba', isDone: true),
      ToDo(id: '03', toDoText: 'Texto de prueba', isDone: true),
      ToDo(id: '04', toDoText: 'Texto de prueba', ),
      ToDo(id: '05', toDoText: 'Texto de prueba', ),
      ToDo(id: '06', toDoText: 'Texto de prueba', ),
    ];
  }
}