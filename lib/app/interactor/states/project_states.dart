import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/app/interactor/entities/project_entity.dart';

final projectsState = ValueNotifier<List<ProjectEntity>>([]);
final projectLoadingState = ValueNotifier<bool>(false);
final projectErrorState = ValueNotifier<bool>(false);
