class Profesor{
  String nProfesor;
  String nombre;
  String carrera;

  Profesor({
    required this.nProfesor,
    required this.nombre,
    required this.carrera
  });

  Map<String, dynamic> toJSON() {
    return {
      'NPROFESOR':nProfesor,
      'NOMBRE':nombre,
      'CARRERA':carrera
    };
  }

}