import 'package:animal_random_app/model/animal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper dbHelper = DBHelper._();

  Database? db;

  //Create Database
  Future<void> initDB() async {
    var directory = await getDatabasesPath();
    String path = join(directory, "demo.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int ver) async {
        String query =
            "CREATE TABLE IF NOT EXISTS tbl_animal(Id INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT NOT NULL,Dec TEXT NOT NULL, Image BLOB NOT NULL);";

        await db.execute(query);
      },
    );
  }

  //Create Table
  Future<int> insertRecord({required Animal animal}) async {
    await initDB();

    String query = "INSERT INTO tbl_animal(Name, Dec, Image) VALUES(?, ?, ?);";
    List args = [animal.name, animal.dec, animal.image];

    return await db!
        .rawInsert(query, args); // return on integer => inserted record's id
  }

  //Fetch All Data
  Future<List<Animal>> fetchAllRecords() async {
    await initDB();

    String query = "SELECT * FROM tbl_animal;";

    List<Map<String, dynamic>> allRecords = await db!.rawQuery(query);

    List<Animal> allAnimals =
        allRecords.map((e) => Animal.fromMap(data: e)).toList();

    return allAnimals;
  }

  //Delete Records
  Future<int> deleteRecords({required int id}) async {
    await initDB();

    String query = "DELETE FROM tbl_animal WHERE Id=?;";
    List args = [id];

    return await db!.rawDelete(query, args);
  }

  //Update Records
  Future<int> updateRecords({required Animal animal, required int id}) async {
    await initDB();

    String query = "UPDATE tbl_animal SET Name=?, Dec=?, Image=? WHERE Id=?;";
    List args = [animal.name, animal.dec, animal.image, id];

    return await db!.rawUpdate(query, args);
  }

  //Search by name
  Future<List<Animal>> fetchSearchRecords({required String Name}) async {
    await initDB();

    String query = "SELECT * FROM tbl_animal WHERE Name LIKE '%$Name%';";

    List<Map<String, dynamic>> searchRecords = await db!.rawQuery(query);

    List<Animal> searchedAnimals =
        searchRecords.map((e) => Animal.fromMap(data: e)).toList();

    return searchedAnimals;
  }
}
