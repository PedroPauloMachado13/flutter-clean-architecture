import 'dart:io';

import 'package:flutter_clean_architecture/app/injector.dart';
import 'package:flutter_clean_architecture/app/interactor/actions/project_actions.dart';
import 'package:flutter_clean_architecture/app/interactor/entities/project_entity.dart';
import 'package:flutter_clean_architecture/app/interactor/repositories/project_repository.dart';
import 'package:flutter_clean_architecture/app/interactor/services/git_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_architecture/app/interactor/states/project_states.dart';

class ProjectReposityMock implements ProjectRepository {
  Future<List<ProjectEntity>> getProjects() async {
    return [
      ProjectEntity(
          directory: Directory('path'),
          name: 'Project',
          description: 'Mock project',
          gitStatus: 'updated')
    ];
  }

  @override
  Future<ProjectEntity> createOrUpdateProject(ProjectEntity project) {
    return Future.value(project);
  }

  @override
  Future<ProjectEntity> deleteProject(ProjectEntity project) {
    return Future.value(project);
  }
}

class GitServiceMock implements GitService {
  @override
  Future<String> getStatus(Directory dir) {
    return Future.value('updated');
  }
}

void main() {
  group('Fetch', () {
    test('Fetch for a list of projects', () async {
      injector.replaceInstance<ProjectRepository>(ProjectReposityMock());

      await fetchAllProjects();
      expect(projectsState.value.length, 1);
    });
  });

  group('Create or Update', () {
    test('Update a project', () async {
      injector.replaceInstance<ProjectRepository>(ProjectReposityMock());
      await fetchAllProjects();
      expect(projectsState.value.length, 1);

      final project =
          projectsState.value.first.copyWith(description: "Project updated");
      await createOrUpdateProject(project);

      expect(projectsState.value.first.description, "Project updated");
    });

    test('Create a project', () async {
      injector.replaceInstance<ProjectRepository>(ProjectReposityMock());

      projectsState.value = [];

      final project = ProjectEntity(
          directory: Directory("path"),
          name: "Project mocked",
          description: "Aweasome description",
          gitStatus: "created");

      expect(projectsState.value.length, 0);

      await createOrUpdateProject(project);

      expect(projectsState.value.length, 1);
    });
  });

  group('Delete', () {
    test('Deletes projects', () async {
      injector.replaceInstance<ProjectRepository>(ProjectReposityMock());

      await fetchAllProjects();

      final project = projectsState.value.first;
      expect(projectsState.value.length, 1);

      await deleteProject(project);
      expect(projectsState.value.length, 0);
    });
  });

  group('Update Git status', () {
    test('Update a projects git status', () async {
      injector.replaceInstance<ProjectRepository>(ProjectReposityMock());
      injector.replaceInstance<GitService>(GitServiceMock());

      await fetchAllProjects();
      expect(projectsState.value.length, 1);

      final project = projectsState.value.first;
      await updateProjectGitStatus(project);

      expect(projectsState.value.first.gitStatus, 'updated');
    });
  });
}
