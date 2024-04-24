class Materia{
  String nMat;
  String descripcion;

  Materia({
    required this.nMat,
    required this.descripcion
  });

  Map<String, dynamic> toJSON() {
    return {
      'NMAT':nMat,
      'DESCRIPCION':descripcion
    };
  }


}