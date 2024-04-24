import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BDD {

  static Future<Database> abrirBD() async {
    return openDatabase(
        join(await getDatabasesPath(), "A.db"),
        onCreate: (db, version) {
          return script(db);
        },
        version: 1
    );
  }

  static Future<void> script(Database db) async{
    db.execute("CREATE TABLE MATERIA(NMAT TEXT PRIMARY KEY, DESCRIPCION TEXT)");
    db.execute("CREATE TABLE HORARIO(NHORARIO INTEGER PRIMARY KEY AUTOINCREMENT, NPROFESOR TEXT, NMAT TEXT, HORA TEXT, EDIFICIO TEXT, SALON TEXT, "
        "FOREIGN KEY (NPROFESOR) REFERENCES PROFESOR(NPROFESOR),"
        "FOREIGN KEY (NMAT) REFERENCES MATERIA(NMAT))");
    db.execute("CREATE TABLE PROFESOR(NPROFESOR TEXT PRIMARY KEY, NOMBRE TEXT, CARRERA TEXT)");
    db.execute("CREATE TABLE ASISTENCIA(IDASISTENCIA INTEGER PRIMARY KEY AUTOINCREMENT, NHORARIO INTEGER, FECHA DATE, ASISTENCIA BOOLEAN, "
        "FOREIGN KEY (NHORARIO) REFERENCES HORARIO(NHORARIO))");

  }

}