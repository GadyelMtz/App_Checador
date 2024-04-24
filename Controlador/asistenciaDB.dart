import 'package:sqflite/sqflite.dart';

import '../Modelo/asistencia.dart';
import 'BDD.dart';
class AsistenciaDB{

  static Future<List<Asistencia>> mostrar() async {
    Database base = await BDD.abrirBD();
    List<Map<String, dynamic>> resultado = await base.query("ASISTENCIA");
    return List.generate(resultado.length, (index) {
      return Asistencia(
          idAsistencia: resultado[index]['IDASISTENCIA'],
          nHorario: resultado[index]['NHORARIO'],
          fecha: resultado[index]['FECHA'],
          asistencia: resultado[index]['ASISTENCIA']);
    });
  }

  static Future<int> eliminar(int idAsistencia) async {
    Database base = await BDD.abrirBD();
    base.delete("ASISTENCIA", where: "IDASISTENCIA=?", whereArgs: [idAsistencia]);
    return 0;
  }

  static Future<int> insertar(Asistencia a) async{
    Database base = await BDD.abrirBD();
    return base.insert("ASISTENCIA", a.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }


  static Future<int> editar(int idAsistencia, Asistencia a) async {
    Database base = await BDD.abrirBD();
    return base.update("ASISTENCIA", a.toJSON(),
        where: "IDASISTENCIA=?",
        whereArgs: [idAsistencia],
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

}
