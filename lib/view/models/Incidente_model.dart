import 'User_Model.dart';

class IncidenteModel {
  final int id;
  final String codigo;
  final String titulo;
  final String descripcion;
  final String estado;
  final String prioridad;
  final int usuarioId;
  final int tecnicoId;
  final int? categoriaId;
  final String fechaReporte;
  final String fechaCierre;
  final String? solucion;
  final String createdAt;
  final String updatedAt;

  //User
  final UserModel? usuario;
  final UserModel? tecnico;

  IncidenteModel({
    required this.id,
    required this.codigo,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.prioridad,
    required this.usuarioId,
    required this.tecnicoId,
    this.categoriaId,
    required this.fechaReporte,
    required this.fechaCierre,
    this.solucion,
    required this.createdAt,
    required this.updatedAt,
    required this.usuario,
    required this.tecnico,
  });

  factory IncidenteModel.fromJson(Map<String, dynamic> json) {
    return IncidenteModel(
      id: json['id'],
      codigo: json['codigo'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      prioridad: json['prioridad'],
      usuarioId: json['usuario_id'],
      tecnicoId: json['tecnico_id'],
      categoriaId: json['categoria_id'],
      fechaReporte: json['fecha_reporte'],
      fechaCierre: json['fecha_cierre'] ?? "",
      solucion: json['solucion'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      usuario: UserModel.fromJson(json['usuario']),
      tecnico: UserModel.fromJson(json['tecnico']),
    );
  }
}
