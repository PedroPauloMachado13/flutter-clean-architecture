import 'package:flutter_clean_architecture/app/interactor/entities/project_entity.dart';

abstract class ProjectRepository {
  Future<List<ProjectEntity>> getProjects();

  Future<ProjectEntity> createOrUpdateProject(ProjectEntity project);

  Future<ProjectEntity> deleteProject(ProjectEntity project);
}
