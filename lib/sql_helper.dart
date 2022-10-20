import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE books_database(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      author TEXT,
      publisher TEXT,
      year TEXT,
      thick TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('books_database.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // add
  static Future<int> addBook(
      String title, String author, String publisher, String year, String thick) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'author': author, 'publisher': publisher, 'year': year, 'thick': thick};
    return await db.insert('books_database', data);
  }

  // read
  static Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await SQLHelper.db();
    return db.query('books_database');
  }

  // update
  static Future<int> updateBooks(
      int id, String title, String author, String publisher, String year, String thick) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'author': author, 'publisher': publisher, 'year': year, 'thick': thick};
    return await db.update('books_database', data, where: "id = $id");
  }

  // delete
  static Future<void> deleteBook(int id) async {
    final db = await SQLHelper.db();
    await db.delete('books_database', where: "id = $id");
  }
}
