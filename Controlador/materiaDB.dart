import 'package:sqflite/sqflite.dart';
import '../Modelo/materia.dart';
import 'BDD.dart';
class MateriaDB{

  static Future<int> insertar(Materia m) async{
    print(m.toString());
    Database base = await BDD.abrirBD();
    return base.insert("MATERIA", m.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar (String nMat) async{
    Database base = await BDD.abrirBD();
    base.delete("MATERIA", where: "NMAT=?",
        whereArgs: [nMat]);
    return 0;
  }

  static Future<int> editar (String nMat, Materia m) async{
    Database base = await BDD.abrirBD();
    return base.update("MATERIA", m.toJSON(), where: "NMAT=?",
        whereArgs: [nMat], conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<List <Materia>> mostrar() async{
    Database base = await BDD.abrirBD();
    List<Map<String, dynamic>> resultado = await base.query("MATERIA");
    return List.generate(resultado.length, (index){
      return Materia(
          nMat: resultado[index]['NMAT'],
          descripcion: resultado[index]['DESCRIPCION']
      );
    });
  }
}