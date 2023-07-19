import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:todo_app/model.dart';

class DBHelper{
  static Database? _db;

  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todo.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  //creacion de la tabla
  _createDatabase(Database db, int version) async{
    await db.execute(
      "CREATE TABLE mytodo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, desc TEXT NOT NULL, dateandtime TEXT NOT NULL)"
    );
  }

  //insercion de datos
  Future<TodoModel> insert(TodoModel todoModel) async{
    var dbClient = await db;
    await dbClient?.insert('mytodo', todoModel.toMap());
    return todoModel;
  }

  //mostrar los registros
  Future<List<TodoModel>> getDataList() async{
    await db;
    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery('SELECT * FROM mytodo');
    return QueryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  //eliminacion de un registro
  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient!.delete('mytodo', where: 'id = ?', whereArgs: [id]);
  }

  //actualizacion de un registro
  Future<int> update(TodoModel todoModel) async{
    var dbClient = await db;
    return await dbClient!.update('mytodo', todoModel.toMap(), where: 'id = ?', whereArgs: [todoModel.id]);
  }
}