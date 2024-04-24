import 'package:checador_asistencia_aula_profesores/Controlador/materiaDB.dart';
import 'package:checador_asistencia_aula_profesores/Controlador/profesorDB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Controlador/asistenciaDB.dart';
import 'Controlador/horarioDB.dart';
import 'Modelo/asistencia.dart';
import 'Modelo/consulta1.dart';
import 'Modelo/horario.dart';
import 'Modelo/materia.dart';
import 'Modelo/profesor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Checador(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Checador extends StatefulWidget {
  @override
  State<Checador> createState() => _ChecadorState();
}

class _ChecadorState extends State<Checador> {
  int _indice = 0;
  int _indiceAuxiliar = 0;
  List<Materia> _materias = [];
  List<Profesor> _profesores = [];
  List<Horario> _horarios = [];
  List<Asistencia> _asistencias = [];
  List<Consulta1> _consulta1 = [];

  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarDatos();
    _selectedTime = TimeOfDay.now();
  }

  void cargarConsulta1(_nProfesor) async {
    List<Consulta1> consultaResultados = await HorarioDB.consulta1(_nProfesor);
    setState(() {
      _consulta1 = consultaResultados;
    });
  }

  void cargarDatos() async {
    List<Materia> temporalMaterias = await MateriaDB.mostrar();
    List<Profesor> temporalProfesores = await ProfesorDB.mostrar();
    List<Horario> temporalHorarios = await HorarioDB.mostrar();
    List<Asistencia> temporalAsistencias = await AsistenciaDB.mostrar();

    setState(() {
      _materias = temporalMaterias;
      _profesores = temporalProfesores;
      _horarios = temporalHorarios;
      _asistencias = temporalAsistencias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dinamicoAuxiliar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_person), label: "Registro"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled), label: "Profesor"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.book), label: "Materia"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar), label: "Horario"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: "Asistencia"),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _indice = index;
            _indiceAuxiliar = 0;
          });
        },
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now(), // Fecha inicial del selector (puede ser otra fecha)
      firstDate: DateTime(2000), // Primera fecha permitida
      lastDate: DateTime(2100), // Última fecha permitida
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Actualiza la fecha seleccionada
        controller.text =
            "${_selectedDate?.year}-${_selectedDate?.month}-${_selectedDate?.day}"; // Actualiza el texto en el campo de texto
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        controller.text = _selectedTime!.format(context);
      });
    }
  }

  Widget dinamicoAuxiliar() {
    String _nProfesor = "";
    String _nMat = "";

    switch (_indiceAuxiliar) {
      case 0:
        return dinamico();
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(top: 50),
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, bottom: 5, top: 5),
                    child: Text(
                      'Consultas \navanzadas',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                )),
            SizedBox(height: 30),
            Text(
              "Dado un docente, \n¿Que materias imparte, a que hora y en que edificio?",
              style: TextStyle(fontSize: 15, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            DropdownButtonFormField(
                padding: EdgeInsets.all(2),
                items: _profesores.map((profesor) {
                  return DropdownMenuItem(
                    child: Text("${profesor.nProfesor} - ${profesor.nombre}"),
                    value: profesor.nProfesor,
                  );
                }).toList(),
                onChanged: (profesor) {
                  setState(() {
                    _nProfesor = profesor.toString();
                    cargarConsulta1(_nProfesor);
                  });
                }),
            Expanded(
                child: ListView.builder(
              itemCount: _consulta1.length,
              itemBuilder: (contextBuilder, index) {
                print("${_consulta1[index].nombreMateria}");
                print("${_consulta1[index].horaHorario}");
                print("${_consulta1[index].edificioMateria}");
                return ListTile(
                  leading: CircleAvatar(child: Text("$index")),
                  title: Text("Materia: ${_consulta1[index].nombreMateria}"),
                  subtitle: Text(
                      "Edificio: ${_consulta1[index].edificioMateria} - Hora: ${_consulta1[index].horaHorario}"),
                );
              },
            ))
          ],
        );
      default:
        return Center();
    }
  }

  Widget dinamico() {
    switch (_indice) {
      case 0:
        return ListView(children: [
          Image.asset(
            "Images/banner.png",
            fit: BoxFit.fitWidth,
            height: 150,
          ),
          SizedBox(
            height: 50,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenerarBotonMenuPrincipal(
                      Icons.account_box_rounded, "Profesor", 0),
                  SizedBox(
                    width: 60,
                  ),
                  GenerarBotonMenuPrincipal(CupertinoIcons.book, "Materia", 1)
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenerarBotonMenuPrincipal(Icons.calendar_month, "Horario", 2),
                  SizedBox(
                    width: 60,
                  ),
                  GenerarBotonMenuPrincipal(Icons.check_box, "Asistencia", 3)
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenerarBotonMenuPrincipal(Icons.search, "Consultas", 4)
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("Aplicacion realizada por:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Diana Gabriela Juárez Díaz 20400760",
                  style: TextStyle(fontSize: 15)),
              Text("Gadyel Josue Martinez Guzman 20400775",
                  style: TextStyle(fontSize: 15)),
            ],
          )
        ]);
      case 1:
        return Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 50),
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, bottom: 5, top: 5),
                    child: Text(
                      'Profesores',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                )),
            Expanded(
              child: ListView.builder(
                itemCount: _profesores.length,
                itemBuilder: (contextBuilder, index) {
                  final controlador1 = TextEditingController();
                  final controlador2 = TextEditingController();
                  final controlador3 = TextEditingController();
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(index.toString()),
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                    ),
                    title: Text("${_profesores[index].nProfesor}"),
                    subtitle: Text(
                      "${_profesores[index].nombre} - ${_profesores[index].carrera}",
                    ),
                    onTap: () {
                      controlador1.text = _profesores[index].nProfesor;
                      controlador2.text = _profesores[index].nombre;
                      controlador3.text = _profesores[index].carrera;
                      showModalBottomSheet(
                        context: context,
                        elevation: 5,
                        isScrollControlled: true,
                        builder: (builder) {
                          return Container(
                            padding: EdgeInsets.only(
                              top: 20,
                              right: 10,
                              left: 10,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 40,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: controlador1,
                                  decoration: InputDecoration(
                                    enabled: false,
                                    labelText: 'nProfesor',
                                  ),
                                ),
                                TextField(
                                  controller: controlador2,
                                  decoration:
                                      InputDecoration(labelText: 'Nombre'),
                                ),
                                TextField(
                                  controller: controlador3,
                                  decoration:
                                      InputDecoration(labelText: 'Carrera'),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        MateriaDB.eliminar(controlador1.text)
                                            .then((value) {
                                          mensaje(
                                              "Profesor eliminado correctamente");
                                          cargarDatos();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Eliminar'),
                                    ),
                                    SizedBox(width: 40),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.yellow,
                                        foregroundColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        Profesor p = Profesor(
                                          nProfesor: controlador1.text,
                                          nombre: controlador2.text,
                                          carrera: controlador3.text,
                                        );
                                        ProfesorDB.editar(controlador1.text, p)
                                            .then((value) {
                                          mensaje(
                                              "Profesor actualizado correctamente");
                                          cargarDatos();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Actualizar'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );

      case 2:
        return Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 50),
                child: Card(
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, bottom: 5, top: 5),
                    child: Text(
                      'Materias',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                )),
            Expanded(
                child: ListView.builder(
                    itemCount: _materias.length,
                    itemBuilder: (contextBuilder, index) {
                      final controlador1 = TextEditingController();
                      final controlador2 = TextEditingController();
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(index.toString()),
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                        ),
                        title: Text("${_materias[index].nMat}"),
                        subtitle: Text(_materias[index].descripcion),
                        onTap: () {
                          controlador1.text = _materias[index].nMat;
                          controlador2.text = _materias[index].descripcion;
                          showModalBottomSheet(
                              context: context,
                              elevation: 5,
                              isScrollControlled: true,
                              builder: (builder) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      top: 20,
                                      right: 10,
                                      left: 10,
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          40),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: controlador1,
                                        decoration: InputDecoration(
                                            enabled: false, labelText: 'nMat'),
                                      ),
                                      TextField(
                                        controller: controlador2,
                                        decoration: InputDecoration(
                                            labelText: 'Descripcion'),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white),
                                            onPressed: () {
                                              MateriaDB.eliminar(
                                                      controlador1.text)
                                                  .then((value) {
                                                mensaje(
                                                    "Materia eliminada correctamente");
                                                cargarDatos();
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Eliminar'),
                                          ),
                                          SizedBox(width: 40),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.yellow,
                                                foregroundColor: Colors.black),
                                            onPressed: () {
                                              Materia m = Materia(
                                                  nMat: controlador1.text,
                                                  descripcion:
                                                      controlador2.text);
                                              MateriaDB.editar(
                                                      controlador1.text, m)
                                                  .then((value) {
                                                mensaje(
                                                    "Materia actualizada correctamente");
                                                cargarDatos();
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Actualizar'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                      );
                    }))
          ],
        );

      case 3:
        return Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 50),
                child: Card(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, bottom: 5, top: 5),
                    child: Text(
                      'Horarios',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                )),
            Expanded(
              child: ListView.builder(
                itemCount: _horarios.length,
                itemBuilder: (contextBuilder, index) {
                  final controlador1 = TextEditingController();
                  final controlador2 = TextEditingController();
                  final horaHorario = TextEditingController();
                  final edificioHorario = TextEditingController();
                  final salonHorario = TextEditingController();

                  String _nProfesor = _horarios[index].nProfesor;
                  String _nMateria = _horarios[index].nMat;

                  edificioHorario.text = _horarios[index].edificio;
                  salonHorario.text = _horarios[index].salon;

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(index.toString()),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    title: Text("${_horarios[index].nProfesor}"),
                    trailing: Text("${_horarios[index].hora}"),
                    subtitle: Text(
                      "${_horarios[index].edificio} - ${_horarios[index].salon}",
                    ),
                    onTap: () {
                      controlador1.text = _horarios[index].edificio;
                      controlador2.text = _horarios[index].salon;
                      horaHorario.text = _horarios[index].hora;
                      showModalBottomSheet(
                        context: context,
                        elevation: 5,
                        isScrollControlled: true,
                        builder: (builder) {
                          return Container(
                            padding: EdgeInsets.only(
                              top: 20,
                              right: 10,
                              left: 10,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 40,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("nHorario: ${_horarios[index].nHorario}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text("Profesor", textAlign: TextAlign.left),
                                DropdownButtonFormField(
                                    value: _horarios[index].nProfesor,
                                    items: _profesores.map((profesor) {
                                      return DropdownMenuItem(
                                        child: Text(
                                            "${profesor.nProfesor} - ${profesor.nombre}"),
                                        value: profesor.nProfesor,
                                      );
                                    }).toList(),
                                    onChanged: (profesor) {
                                      setState(() {
                                        _nProfesor = profesor.toString();
                                      });
                                    }),
                                SizedBox(height: 20),
                                Text("Materia", textAlign: TextAlign.left),
                                DropdownButtonFormField(
                                    value: _horarios[index].nMat,
                                    items: _materias.map((materia) {
                                      return DropdownMenuItem(
                                        child: Text(
                                            "${materia.nMat} - ${materia.descripcion}"),
                                        value: materia.nMat,
                                      );
                                    }).toList(),
                                    onChanged: (materia) {
                                      setState(() {
                                        _nMateria = materia.toString();
                                      });
                                    }),
                                TextFormField(
                                  readOnly: true,
                                  controller: horaHorario,
                                  onTap: () => _selectTime(context,
                                      horaHorario), // Abre el selector de hora al tocar el campo
                                  decoration: InputDecoration(
                                    labelText: 'Hora',
                                    suffixIcon: Icon(Icons.access_time),
                                  ),
                                ),
                                TextField(
                                  controller: edificioHorario,
                                  decoration:
                                      InputDecoration(labelText: 'Edificio'),
                                ),
                                TextField(
                                  controller: salonHorario,
                                  decoration:
                                      InputDecoration(labelText: 'Salon'),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white),
                                        onPressed: () {
                                          HorarioDB.eliminar(_horarios[index]
                                              .nHorario
                                              .toString());
                                          mensaje(
                                              "Horario eliminado correctamente");
                                          cargarDatos();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Eliminar')),
                                    SizedBox(width: 50),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow,
                                          foregroundColor: Colors.black),
                                      onPressed: () {
                                        Horario h = Horario(
                                            nHorario: 0,
                                            nProfesor: _nProfesor,
                                            nMat: _nMateria,
                                            hora:
                                                '${_selectedTime!.hour}:${_selectedTime!.minute}',
                                            edificio: edificioHorario.text,
                                            salon: salonHorario.text);
                                        if (_nProfesor == "" ||
                                            _nMateria == "" ||
                                            edificioHorario.text == "" ||
                                            salonHorario.text == "") {
                                          mensaje("No deje ningun campo vacio");
                                        } else
                                          HorarioDB.editar(
                                                  _horarios[index]
                                                      .nHorario
                                                      .toString(),
                                                  h)
                                              .then((value) {
                                            mensaje(
                                                "Horario actualizado correctamente");
                                            cargarDatos();
                                          });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Actualizar'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );

      case 4:
        return Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 50),
                child: Card(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, bottom: 5, top: 5),
                    child: Text(
                      'Asistencias',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                )),
            Expanded(
              child: ListView.builder(
                itemCount: _asistencias.length,
                itemBuilder: (contextBuilder, index) {
                  bool haAsistido;
                  String temporalHaAsistido;
                  if (_asistencias[index].asistencia == 0) {
                    haAsistido = true;
                    temporalHaAsistido = "Si asistió";
                  } else {
                    haAsistido = false;
                    temporalHaAsistido = "No asistió";
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(index.toString()),
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                    ),
                    title: Text(
                        "Horario: ${_asistencias[index].nHorario} - ${temporalHaAsistido}"),
                    subtitle: Text("${_asistencias[index].fecha}"),
                    onTap: () {
                      final diaAsistencia = TextEditingController();
                      diaAsistencia.text = _asistencias[index].fecha;
                      int _nHorario = _asistencias[index].nHorario;

                      showModalBottomSheet(
                        context: context,
                        elevation: 5,
                        isScrollControlled: true,
                        builder: (builder) {
                          return Container(
                            padding: EdgeInsets.only(
                              top: 20,
                              right: 10,
                              left: 10,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 40,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonFormField(
                                    value: _asistencias[index].nHorario,
                                    items: _horarios.map((horario) {
                                      return DropdownMenuItem(
                                        child: Text(
                                            "${horario.nHorario} - ${horario.nProfesor} - ${horario.hora} - ${horario.nMat} "),
                                        value: horario.nHorario,
                                      );
                                    }).toList(),
                                    onChanged: (horario) {
                                      setState(() {
                                        _nHorario =
                                            int.parse(horario.toString());
                                      });
                                    }),
                                TextFormField(
                                  readOnly: true,
                                  controller: diaAsistencia,
                                  onTap: () =>
                                      _selectDate(context, diaAsistencia),
                                  decoration: InputDecoration(
                                    labelText: 'Fecha',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text("¿El docente asistió?"),
                                DropdownButtonFormField(
                                  value: haAsistido,
                                  onChanged: (newValue) {
                                    setState(() {
                                      haAsistido = newValue!;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: true,
                                      child: Text('Sí'),
                                    ),
                                    DropdownMenuItem(
                                      value: false,
                                      child: Text('No'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        AsistenciaDB.eliminar(
                                                _asistencias[index]
                                                    .idAsistencia)
                                            .then((value) {
                                          mensaje(
                                              "Asistencia eliminada correctamente");
                                          cargarDatos();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Eliminar'),
                                    ),
                                    SizedBox(width: 40),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.yellow,
                                        foregroundColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        int temporalHaAsistido;
                                        if (haAsistido == true)
                                          temporalHaAsistido = 0;
                                        else
                                          temporalHaAsistido = 1;
                                        Asistencia a = Asistencia(
                                          idAsistencia: 0,
                                          fecha:
                                              "${_selectedDate?.year}-${_selectedDate?.month}-${_selectedDate?.day}",
                                          nHorario:
                                              _asistencias[index].nHorario,
                                          asistencia: temporalHaAsistido,
                                        );
                                        AsistenciaDB.editar(
                                                _asistencias[index]
                                                    .idAsistencia,
                                                a)
                                            .then((value) {
                                          mensaje(
                                              "Asistencia actualizada correctamente");
                                          cargarDatos();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Actualizar'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );

      case 5:
        return Center(child: Icon(Icons.home));
      default:
        return Center();
    }
  }

  Widget GenerarBotonMenuPrincipal(IconData icono, String titulo, int boton) {
    String _nProfesor = "";
    String _nMateria = "";
    String _nHorario = "";

    bool haAsistido = false;
    return SizedBox(
      child: Column(
        children: [
          CircleAvatar(
            child: IconButton(
              onPressed: () {
                switch (boton) {
                  // Profesor
                  case 0:
                    showModalBottomSheet(
                        elevation: 5,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          final nombreProfesor = TextEditingController();
                          final carreraProfesor = TextEditingController();
                          final nProfesor = TextEditingController();
                          return Container(
                            padding: EdgeInsets.only(
                                top: 20,
                                right: 10,
                                left: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nProfesor,
                                  decoration:
                                      InputDecoration(labelText: 'nProfesor'),
                                ),
                                TextField(
                                  controller: nombreProfesor,
                                  decoration:
                                      InputDecoration(labelText: 'Nombre'),
                                ),
                                TextField(
                                  controller: carreraProfesor,
                                  decoration:
                                      InputDecoration(labelText: 'Carrera'),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancelar')),
                                    SizedBox(width: 50),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        Profesor p = Profesor(
                                            nProfesor: nProfesor.text,
                                            nombre: nombreProfesor.text,
                                            carrera: carreraProfesor.text);
                                        if (nProfesor.text == "" ||
                                            nombreProfesor.text == "" ||
                                            carreraProfesor.text == "")
                                          mensaje("No deje ningun campo vacio");
                                        else
                                          ProfesorDB.insertar(p).then((value) {
                                            mensaje(
                                                "Profesor registrado correctamente");
                                            cargarDatos();
                                          });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Registrar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  //Materia
                  case 1:
                    showModalBottomSheet(
                        elevation: 5,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          final nombreMateria = TextEditingController();
                          final descripcionMateria = TextEditingController();
                          return Container(
                            padding: EdgeInsets.only(
                                top: 20,
                                right: 10,
                                left: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nombreMateria,
                                  decoration:
                                      InputDecoration(labelText: 'nMat'),
                                ),
                                TextField(
                                  controller: descripcionMateria,
                                  decoration:
                                      InputDecoration(labelText: 'Descripcion'),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancelar')),
                                    SizedBox(width: 50),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        Materia m = Materia(
                                            nMat: nombreMateria.text,
                                            descripcion:
                                                descripcionMateria.text);
                                        if (nombreMateria.text == "" ||
                                            descripcionMateria.text == "")
                                          mensaje("No deje ningun campo vacio");
                                        else
                                          MateriaDB.insertar(m).then((value) {
                                            mensaje(
                                                "Materia registrada correctamente");
                                            cargarDatos();
                                          });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Registrar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });

                  case 2:
                    showModalBottomSheet(
                        elevation: 5,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          final horaHorario = TextEditingController();
                          final edificioHorario = TextEditingController();
                          final salonHorario = TextEditingController();

                          return Container(
                            padding: EdgeInsets.only(
                                top: 20,
                                right: 10,
                                left: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Profesor", textAlign: TextAlign.left),
                                DropdownButtonFormField(
                                    items: _profesores.map((profesor) {
                                      return DropdownMenuItem(
                                        child: Text(
                                            "${profesor.nProfesor} - ${profesor.nombre}"),
                                        value: profesor.nProfesor,
                                      );
                                    }).toList(),
                                    onChanged: (profesor) {
                                      setState(() {
                                        _nProfesor = profesor.toString();
                                      });
                                    }),
                                SizedBox(height: 20),
                                Text("Materia", textAlign: TextAlign.left),
                                DropdownButtonFormField(
                                    items: _materias.map((materia) {
                                      return DropdownMenuItem(
                                        child: Text(
                                            "${materia.nMat} - ${materia.descripcion}"),
                                        value: materia.nMat,
                                      );
                                    }).toList(),
                                    onChanged: (materia) {
                                      setState(() {
                                        _nMateria = materia.toString();
                                      });
                                    }),
                                TextFormField(
                                  readOnly:
                                      true, // Para que no se pueda editar manualmente
                                  controller: horaHorario,
                                  onTap: () => _selectTime(context,
                                      horaHorario), // Abre el selector de hora al tocar el campo
                                  decoration: InputDecoration(
                                    labelText: 'Hora',
                                    suffixIcon: Icon(Icons.access_time),
                                  ),
                                ),
                                TextField(
                                  controller: edificioHorario,
                                  decoration:
                                      InputDecoration(labelText: 'Edificio'),
                                ),
                                TextField(
                                  controller: salonHorario,
                                  decoration:
                                      InputDecoration(labelText: 'Salon'),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancelar')),
                                    SizedBox(width: 50),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        Horario h = Horario(
                                            nHorario: 0,
                                            nProfesor: _nProfesor,
                                            nMat: _nMateria,
                                            hora:
                                                '${_selectedTime!.hour}:${_selectedTime!.minute}',
                                            edificio: edificioHorario.text,
                                            salon: salonHorario.text);
                                        if (_nProfesor == "" ||
                                            _nMateria == "" ||
                                            edificioHorario.text == "" ||
                                            salonHorario.text == "")
                                          mensaje("No deje ningun campo vacio");
                                        else
                                          HorarioDB.insertar(h).then((value) {
                                            mensaje(
                                                "Horario registrado correctamente");
                                            cargarDatos();
                                          });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Registrar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });

                  case 3:
                    showModalBottomSheet(
                        elevation: 5,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          final diaAsistencia = TextEditingController();
                          return Container(
                            padding: EdgeInsets.only(
                                top: 20,
                                right: 10,
                                left: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Horario", textAlign: TextAlign.left),
                                DropdownButtonFormField(
                                    items: _horarios.map((horario) {
                                      return DropdownMenuItem(
                                        child: Text(
                                            "${horario.nHorario} - nProfesor: ${horario.nProfesor}"),
                                        value: horario.nHorario,
                                      );
                                    }).toList(),
                                    onChanged: (horario) {
                                      setState(() {
                                        _nHorario = horario.toString();
                                      });
                                    }),
                                SizedBox(height: 20),
                                TextFormField(
                                  readOnly:
                                      true, // Para que no se pueda editar manualmente
                                  controller: diaAsistencia,
                                  onTap: () => _selectDate(context,
                                      diaAsistencia), // Abre el selector de fecha al tocar el campo
                                  decoration: InputDecoration(
                                    labelText: 'Fecha',
                                    suffixIcon: Icon(Icons
                                        .calendar_today), // Ícono para indicar que es un selector de fecha
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text("¿El docente asistió?"),
                                DropdownButtonFormField(
                                  value: haAsistido,
                                  onChanged: (newValue) {
                                    setState(() {
                                      haAsistido = newValue!;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: true,
                                      child: Text('Sí'),
                                    ),
                                    DropdownMenuItem(
                                      value: false,
                                      child: Text('No'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancelar')),
                                    SizedBox(width: 50),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        int haAsistido = 1;
                                        if (haAsistido == true) {
                                          haAsistido = 1;
                                        } else
                                          haAsistido = 0;
                                        Asistencia a = Asistencia(
                                            idAsistencia: 0,
                                            nHorario: int.parse(_nHorario),
                                            fecha:
                                                "${_selectedDate?.year}-${_selectedDate?.month}-${_selectedDate?.day}",
                                            asistencia: haAsistido);
                                        if (a.asistencia == "" ||
                                            a.fecha == "" ||
                                            a.asistencia == null)
                                          mensaje("No deje ningun campo vacio");
                                        else
                                          AsistenciaDB.insertar(a)
                                              .then((value) {
                                            mensaje(
                                                "Asistencia registrada correctamente");
                                            cargarDatos();
                                          });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Registrar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  case 4:
                    setState(() {
                      _indiceAuxiliar = 1;
                    });
                }
              },
              icon: Icon(icono),
              color: Colors.white,
              iconSize: 70,
            ),
            backgroundColor: Colors.blue,
            radius: 50,
          ),
          Text(
            titulo,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  void mensaje(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}
