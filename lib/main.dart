
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  TextEditingController _controller = TextEditingController();
  List<String> tasks = [];
  bool s=false;


  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
  }

  void add(String task) {
    setState(() {
      tasks.add(task);
    });
    save();
  }

  void remove(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    save();
  }

  void toggleTaskCompleted(int index) {
    setState(() {

      if (tasks[index].startsWith('*')) {
        tasks[index] = tasks[index].substring(1);
      } else {
        tasks[index] = '*' + tasks[index];
      }
    });
    save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          title: Center(
              child: Text('To-Do List',
                style: TextStyle(color: Colors.red),
              )
          ),
        ),


        body: Column(
            children: [
              Expanded(
                child: Card( color: Colors.grey.shade200,
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Card(color: Colors.red,

                        child: ListTile(
                          leading: Checkbox(
                            checkColor: Colors.black,
                            focusColor: Colors.white,
                            activeColor: Colors.white,
                            value: tasks[index].startsWith('*'),

                            onChanged: (value) {
                              toggleTaskCompleted(index);
                            },
                          ),
                          title: Text(
                            tasks[index].startsWith('*') ? tasks[index].substring(1) : tasks[index],

                            style: TextStyle(color: Colors.white,
                              decoration: tasks[index].startsWith('*') ? TextDecoration.lineThrough : null,
                            ),
                          ),

                          trailing: IconButton(
                            icon: Icon(Icons.delete_forever_rounded,color: Colors.white,),
                            onPressed: () {
                              remove(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            hintText: 'Enter your task...'
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                     margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red),

                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            add(_controller.text);
                            _controller.clear();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ),
        );
    }
}



