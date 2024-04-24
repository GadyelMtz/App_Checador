import 'package:sqflite/sqflite.dart';
import '../Modelo/profesor.dart';
import 'BDD.dart';

class ProfesorDB {
  static Future<int> insertar(Profesor p) async {
    Database base = await BDD.abrirBD();
    return base.insert("PROFESOR", p.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  // Es necesario eliminar los registros en la tabla HORARIO porque
  // ahí tambien se hace referencia al profesor eliminado
  static Future<int> eliminar(String nProfesor) async {
    Database base = await BDD.abrirBD();
    base.delete("HORARIO", where: "NPROFESOR=?", whereArgs: [nProfesor]);
    base.delete("PROFESOR", where: "NPROFESOR=?", whereArgs: [nProfesor]);
    return 0;
  }

  static Future<int> editar(String nProfesor, Profesor p) async {
    Database base = await BDD.abrirBD();
    return base.update("PROFESOR", p.toJSON(),
        where: "NPROFESOR=?",
        whereArgs: [nProfesor],
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<List<Profesor>> mostrar() async {
    Database base = await BDD.abrirBD();
    List<Map<String, dynamic>> resultado = await base.query("PROFESOR");
    return List.generate(resultado.length, (index) {
      return Profesor(
        nProfesor: resultado[index]['NPROFESOR'],
        nombre: resultado[index]['NOMBRE'],
        carrera: resultado[index]['CARRERA'],
      );
    });
  }

}
