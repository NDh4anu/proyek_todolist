class Todo {
  int? id;
  String nama;
  String deskripsi;
  bool done;

  Todo(this.nama, this.deskripsi, {this.done = false, this.id});

  static List<Todo> dummyData = [
    Todo("Latihan Menggamabr", "Latihan perlombaan menggambar"),
    Todo("Makan Malam", "Makan malam bersama camer", done: true),
    Todo("Bernyanyi Bersama", "Nyanyi bersama teman-teman")
  ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'done': done ? 1 : 0
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(id: map['id'], map['nama'] as String, map['deskripsi'] as String,
        done: map['done'] == 0 ? false : true);
  }
}
