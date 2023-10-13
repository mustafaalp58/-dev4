import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];

  void addTask(String name, String description, DateTime startDate,
      TimeOfDay startTime, DateTime endDate, TimeOfDay endTime) {
    setState(() {
      tasks
          .add(Task(name, description, startDate, startTime, endDate, endTime));
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görevlerim'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(tasks[index].name),
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            onDismissed: (direction) {
              deleteTask(index);
            },
            child: Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(tasks[index].name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Açıklama: ${tasks[index].description}'),
                    Text(
                        'Bitiş: ${tasks[index].endDate.toString()} ${tasks[index].endTime.format(context)}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailPage(task: tasks[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog() {
    String name = "";
    String description = "";
    DateTime startDate = DateTime.now();
    TimeOfDay startTime = TimeOfDay.now();
    DateTime endDate = DateTime.now();
    TimeOfDay endTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Etkinlik Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (text) {
                  name = text;
                },
                decoration: InputDecoration(labelText: 'Başlık'),
              ),
              TextField(
                onChanged: (text) {
                  description = text;
                },
                decoration: InputDecoration(labelText: 'Açıklama'),
              ),
              Row(
                children: <Widget>[
                  Text('Başlama Tarihi: '),
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            startDate = date;
                          });
                        }
                      });
                    },
                    child: Text(
                      "${startDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Başlama Saati: '),
                  TextButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: startTime,
                      ).then((time) {
                        if (time != null) {
                          setState(() {
                            startTime = time;
                          });
                        }
                      });
                    },
                    child: Text(
                      startTime.format(context),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Bitiş Tarihi: '),
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            endDate = date;
                          });
                        }
                      });
                    },
                    child: Text(
                      "${endDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Bitiş Saati: '),
                  TextButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: endTime,
                      ).then((time) {
                        if (time != null) {
                          setState(() {
                            endTime = time;
                          });
                        }
                      });
                    },
                    child: Text(
                      endTime.format(context),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ekle'),
              onPressed: () {
                if (name.isNotEmpty) {
                  addTask(name, description, startDate, startTime, endDate,
                      endTime);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class Task {
  final String name;
  final String description;
  final DateTime startDate;
  final TimeOfDay startTime;
  final DateTime endDate;
  final TimeOfDay endTime;

  Task(this.name, this.description, this.startDate, this.startTime,
      this.endDate, this.endTime);
}

class TaskDetailPage extends StatelessWidget {
  final Task task;

  TaskDetailPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görev Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Başlık: ${task.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Açıklama: ${task.description}'),
            Text(
                'Bitiş: ${task.endDate.toString()} ${task.endTime.format(context)}'),
          ],
        ),
      ),
    );
  }
}
