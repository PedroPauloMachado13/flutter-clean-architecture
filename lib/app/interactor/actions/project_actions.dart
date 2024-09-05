// Aqui ficam todas as regras de negócio da APLICAÇÃO

import 'package:flutter_clean_architecture/app/injector.dart';
import 'package:flutter_clean_architecture/app/interactor/entities/project_entity.dart';
import 'package:flutter_clean_architecture/app/interactor/repositories/project_repository.dart';
import 'package:flutter_clean_architecture/app/interactor/services/git_service.dart';
import 'package:flutter_clean_architecture/app/interactor/services/launcher_service.dart';
import 'package:flutter_clean_architecture/app/interactor/states/project_states.dart';

Future<void> fetchAllProjects() async {
  projectLoadingState.value = true;

  final repository = injector.get<ProjectRepository>();
  final projects = await repository.getProjects();
  projectsState.value = projects;

  projectLoadingState.value = false;
}

Future<void> createOrUpdateProject(ProjectEntity project) async {
  final repository = injector.get<ProjectRepository>();
  final newProject = await repository.createOrUpdateProject(project);
  final projectsCopy = projectsState.value.toList();
  final index = projectsCopy
      .indexWhere((i) => i.directory.path == newProject.directory.path);

  if (index != -1) {
    projectsCopy[index] = newProject;
  } else {
    projectsCopy.add(newProject);
  }

  projectsState.value = projectsCopy;
}

Future<void> deleteProject(ProjectEntity project) async {
  final repository = injector.get<ProjectRepository>();
  final deletedProject = await repository.deleteProject(project);
  final projects = projectsState.value.toList();
  projects
      .removeWhere((i) => i.directory.path == deletedProject.directory.path);
  projectsState.value = projects;
}

Future<void> updateProjectGitStatus(ProjectEntity project) async {
  final service = injector.get<GitService>();
  final status = await service.getStatus(project.directory);

  final updatedProject = project.copyWith(gitStatus: status);

  createOrUpdateProject(updatedProject);
}

Future<void> openProject(ProjectEntity project) async {
  final service = injector.get<LauncherService>();
  service.launch(project.directory);
}
