class Horario{

  int nHorario;
  String nProfesor;
  String nMat;
  String hora;
  String edificio;
  String salon;


  Horario({
    required this.nHorario,
    required this.nProfesor,
    required this.nMat,
    required this.hora,
    required this.edificio,
    required this.salon
  });

  Map<String, dynamic> toJSON() {
    return {
      'NPROFESOR':nProfesor,
      'NMAT':nMat,
      'HORA':hora,
      'EDIFICIO':edificio,
      'SALON':salon
    };
  }


}