import 'package:sqflite/sqflite.dart';
import '../Modelo/consulta1.dart';
import '../Modelo/consulta2.dart';
import '../Modelo/consulta3.dart';
import '../Modelo/horario.dart';
import '../Modelo/profesor.dart';
import 'BDD.dart';

class HorarioDB {
  static Future<int> insertar(Horario h) async {
    Database base = await BDD.abrirBD();
    return base.insert("HORARIO", h.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar(String nHorario) async {
    Database base = await BDD.abrirBD();
    base.delete("HORARIO", where: "NHORARIO=?", whereArgs: [nHorario]);
    return 0;
  }

  static Future<int> editar(String nHorario, Horario h) async {
    Database base = await BDD.abrirBD();
    return base.update("HORARIO", h.toJSON(),
        where: "NHORARIO=?",
        whereArgs: [nHorario],
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<List<Horario>> mostrar() async {
    Database base = await BDD.abrirBD();
    List<Map<String, dynamic>> resultado = await base.query("HORARIO");
    return List.generate(resultado.length, (index) {
      return Horario(
          nHorario: resultado[index]['NHORARIO'],
          nProfesor: resultado[index]['NPROFESOR'],
          nMat: resultado[index]['NMAT'],
          hora: resultado[index]['HORA'],
          edificio: resultado[index]['EDIFICIO'],
          salon: resultado[index]['SALON']);
    });
  }

  static Future<List<Consulta1>> consulta1(String nProfesor) async {
    Database base = await BDD.abrirBD();
    List<Map<String, dynamic>> resultado = await base.rawQuery(
      "SELECT MATERIA.DESCRIPCION AS NOMBRE, HORARIO.HORA, HORARIO.EDIFICIO " +
          "FROM HORARIO " +
          "JOIN PROFESOR ON HORARIO.NPROFESOR = PROFESOR.NPROFESOR " +
          "JOIN MATERIA ON HORARIO.NMAT = MATERIA.NMAT " +
          "WHERE PROFESOR.NPROFESOR = ?",
      [nProfesor],
    );
    return List.generate(resultado.length, (index) {
      return Consulta1(
          edificioMateria: resultado[index]['EDIFICIO'],
          horaHorario: resultado[index]['HORA'],
          nombreMateria: resultado[index]['NOMBRE']);
    });
  }

  static Future<List<Consulta2>> consulta2(String fecha) async {
    Database base = await BDD.abrirBD();
    List<Map<String, dynamic>> resultado = await base.rawQuery(
        "SELECT PROFESOR.NOMBRE, ASISTENCIA.ASISTENCIA " +
            "FROM ASISTENCIA " +
            "JOIN HORARIO ON ASISTENCIA.NHORARIO = HORARIO.NHORARIO " +
            "JOIN PROFESOR ON HORARIO.NPROFESOR = PROFESOR.NPROFESOR " +
            "WHERE ASISTENCIA.FECHA = ?",
        [fecha]
    );

    return List.generate(resultado.length, (index) {
      return Consulta2(
          nombreProfesor: resultado[index]['NOMBRE'],
          asistencia: resultado[index]['ASISTENCIA']
      );
    });
  }


  static Future<List<Consulta3>> consulta3(String materia) async {
    Database base = await BDD.abrirBD();
    List<Map<String, dynamic>> resultado = await base.rawQuery(
        "SELECT PROFESOR.NOMBRE, HORARIO.EDIFICIO, HORARIO.SALON, HORARIO.HORA " +
            "FROM HORARIO " +
            "JOIN PROFESOR ON HORARIO.NPROFESOR = PROFESOR.NPROFESOR " +
            "WHERE HORARIO.NMAT = ?",
        [materia]
    );

    return List.generate(resultado.length, (index) {
      return Consulta3(
          nombreProfesor: resultado[index]['NOMBRE'],
          edificio: resultado[index]['EDIFICIO'],
          salon: resultado[index]['SALON'],
          hora: resultado[index]['HORA']
      );
    });
  }

}
