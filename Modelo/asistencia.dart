class Asistencia{
  int idAsistencia;
  int nHorario;
  String fecha;
  int asistencia;

  Asistencia({
    required this.idAsistencia,
    required this.nHorario,
    required this.fecha,
    required this.asistencia
  });

  Map<String, dynamic> toJSON() {
    return {
      'NHORARIO':nHorario,
      'FECHA':fecha,
      'ASISTENCIA':asistencia,
    };
  }

}