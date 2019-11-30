import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:money_manager/models/dados.dart';

class GastosHelper {
  static final GastosHelper _instance = GastosHelper.internal();

  factory GastosHelper() => _instance;

  GastosHelper.internal();

  Database _db;
  Database _dbHistorico;
  var hoje = DateTime.now();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

    Future<Database> get dbHistorico async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDbHistorico();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "gastos.db");

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE gasto("
          "id     INTEGER PRIMARY KEY AUTOINCREMENT, "
          "nome   TEXT, "
          "valor  FLOAT, "
          "data   TEXT, "
          "tipo   TEXT)");
    });
  }

    Future<Database> initDbHistorico() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "gastos.db");

    return openDatabase(path, version: 1,
        onCreate: (Database dbHistorico, int newerVersion) async {
      await dbHistorico.execute("CREATE TABLE gasto("
          "id     INTEGER PRIMARY KEY AUTOINCREMENT, "
          "nome   TEXT, "
          "valor  FLOAT, "
          "data   TEXT, "
          "tipo   TEXT)");
    });
  }

  Future close() async {
    Database database = await db;
    database.close();
  }

  Future<Gastos> save(Gastos gastos) async {
    Database database = await db;
    gastos.id = await database.insert('gasto', gastos.toMap());
    return gastos;
  }

  Future<Gastos> getById(int id) async {
    Database database = await db;
    List<Map> maps = await database.query('gasto',
        columns: ['id', 'nome', 'valor', 'data', 'tipo'],
        where: 'id = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return Gastos.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> delete(int id) async {
    Database database = await db;
    return await database.delete('gasto', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database database = await db;
    return await database.rawDelete("DELETE * FROM gasto");
  }

  Future<int> update(Gastos gastos) async {
    Database database = await db;
    return await database.update('gasto', gastos.toMap(),
        where: 'id = ?', whereArgs: [gastos.id]);
  }

  Future<List<Gastos>> getAll() async {
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM gasto ORDER BY data");
    List<Gastos> moneyList = listMap.map((x) => Gastos.fromMap(x)).toList();
    return moneyList;
  }

  Future<List<Gastos>> getGastos() async {
    Database database = await db;
    List listMap =
        await database.rawQuery("SELECT * FROM gasto WHERE tipo = 'Gastos'");
    List<Gastos> moneyList = listMap.map((x) => Gastos.fromMap(x)).toList();
    return moneyList;
  }
  
  Future<List<GastosHistorico>> getGastosHistorico() async {
    Database database = await db;
    List listMap =
        await database.rawQuery("SELECT * FROM gasto WHERE tipo = 'Gastos'");
    List<GastosHistorico> moneyList = listMap.map((x) => GastosHistorico.fromMap(x)).toList();
    return moneyList;
  }

  Future<List<Gastos>> getGanhos() async {
    Database database = await db;
    List listMap =
        await database.rawQuery("SELECT * FROM gasto WHERE tipo = 'Ganhos'");
    List<Gastos> moneyList = listMap.map((x) => Gastos.fromMap(x)).toList();
    return moneyList;
  }

    Future<List<GastosHistorico>> getGanhosHistorico() async {
    Database database = await db;
    List listMap =
        await database.rawQuery("SELECT * FROM gasto WHERE tipo = 'Ganhos'");
    List<GastosHistorico> moneyList = listMap.map((x) => GastosHistorico.fromMap(x)).toList();
    return moneyList;
  }

  Future<double> getGastosTotal() async {
    Database database = await db;
    List moneyList = await database.rawQuery(
        "SELECT SUM(valor) AS GastosTotais FROM gasto WHERE tipo = 'Gastos'");
    double value = moneyList[0]["SUM(valor)"];
    return value;
  }

  Future<double> getGanhosTotal() async {
    Database database = await db;
    List moneyList = await database.rawQuery(
        "SELECT SUM(valor) AS GanhosTotais FROM gasto WHERE tipo = 'Ganhos'");
    double value = moneyList[0]["SUM(valor)"];
    return value;
  }

  Future getTotalGasto() async {
    Database database = await db;
    var result = await database.rawQuery(
        "SELECT CASE WHEN SUM(valor) IS NULL THEN 0.0 ELSE SUM(valor) END AS TotalGasto FROM gasto WHERE tipo = 'Gastos'");
    return result.toList();
  }

  Future getTotalGanho() async {
    Database database = await db;
    var result = await database.rawQuery(
        "SELECT CASE WHEN SUM(valor) IS NULL THEN 0.0 ELSE SUM(valor) END AS TotalGanho FROM gasto WHERE tipo = 'Ganhos'");
    return result.toList();
  }
}
