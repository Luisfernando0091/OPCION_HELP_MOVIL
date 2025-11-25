import 'package:option_help/view/models/User_Model.dart';

class RequerimeintoModel {
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
  final String? fechaCierre;
  final String? solucion;
  final String createdAt;
  final String updatedAt;

  final UserModel? usuario;
  final UserModel? tecnico;

  RequerimeintoModel({
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
    this.fechaCierre,
    this.solucion,
    required this.createdAt,
    required this.updatedAt,
    this.usuario,
    this.tecnico,
  });

  factory RequerimeintoModel.fromJson(Map<String, dynamic> json) {
    return RequerimeintoModel(
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
      fechaCierre: json['fecha_cierre'],
      solucion: json['solucion'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],

      usuario: json['usuario'] != null
          ? UserModel.fromJson(json['usuario'])
          : null,

      tecnico: json['tecnico'] != null
          ? UserModel.fromJson(json['tecnico'])
          : null,
    );
  }
}
