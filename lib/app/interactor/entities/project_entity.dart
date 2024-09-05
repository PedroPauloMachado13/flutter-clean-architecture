import 'dart:io';

// Representação de regra de negócio CORPORATIVAS
class ProjectEntity {
  final Directory directory;
  final String name;
  final String description;
  final String gitStatus;

  ProjectEntity(
      {required this.directory,
      required this.name,
      required this.description,
      required this.gitStatus});

  ProjectEntity copyWith(
      {Directory? directory,
      String? name,
      String? description,
      String? gitStatus}) {
    return ProjectEntity(
        directory: directory ?? this.directory,
        name: name ?? this.name,
        description: description ?? this.description,
        gitStatus: gitStatus ?? this.gitStatus);
  }
}
