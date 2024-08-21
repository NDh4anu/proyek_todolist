import 'package:flutter/material.dart';
import 'package:proyek_todolist/database_helper.dart';
import 'package:proyek_todolist/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> todoList = [];

  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _deskripsiCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    final todos = await dbHelper.getAllTodos();

    setState(() {
      todoList = todos;
    });
  }

  void addItem() async {
    await dbHelper.addTodo(Todo(_namaCtrl.text, _deskripsiCtrl.text));
    // todoList.add(Todo(_namaCtrl.text, _deskripsiCtrl.text));
    refreshList();

    _namaCtrl.clear();
    _deskripsiCtrl.clear();
  }

  void updateItem(int index, bool done) async {
    todoList[index].done = done;

    await dbHelper.updateTodo(todoList[index]);

    refreshList();
  }

  void deleteItem(int id) async {
    // todoList.removeAt(index);

    await dbHelper.deleteTodo(id);

    refreshList();
  }

  void tampilForm() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              title: const Text("Tambah Todo"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Tututp")),
                ElevatedButton(
                    onPressed: () {
                      addItem();
                      Navigator.pop(context);
                    },
                    child: const Text("Tambah"))
              ],
              content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  children: [
                    TextField(
                      controller: _namaCtrl,
                      decoration: const InputDecoration(hintText: "Nama Todo"),
                    ),
                    TextField(
                      controller: _deskripsiCtrl,
                      decoration:
                          const InputDecoration(hintText: "Deskripsi Todo"),
                    ),
                  ],
                ),
              ),
            ));
  }

  void cariTodo() async {
    String keyword = _searchCtrl.text;
    
    List<Todo> todos = [];

    if (keyword.isEmpty) {
      todos = await dbHelper.getAllTodos();
    } else {
      todos = await dbHelper.searchTodos(keyword);
    }

    setState(() {
      todoList = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasi Todo List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) {
                cariTodo();
              },
              decoration: const InputDecoration(
                  hintText: "Cari Todo",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: todoList[index].done
                        ? IconButton(
                            icon: const Icon(Icons.check_circle),
                            onPressed: () {
                              updateItem(index, !todoList[index].done);
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.radio_button_unchecked),
                            onPressed: () {
                              updateItem(index, !todoList[index].done);
                            },
                          ),
                    title: Text(todoList[index].nama),
                    subtitle: Text(todoList[index].deskripsi),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteItem(todoList[index].id ?? 0);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tampilForm();
        },
        child: const Icon(Icons.add_box),
      ),
    );
  }
}
