import 'package:flutter/material.dart';
import 'package:painel_velocitynet/modules/appState/app_state.dart';

class AppController extends ValueNotifier<AppState> {
  AppController() : super(AppState.initial());

  void toogleExpand() {
    value = value.copyWith(isExpanded: !value.isExpanded);
  }

  void collapse() {
    value = value.copyWith(isExpanded: false);
  }

  void expand() {
    value = value.copyWith(isExpanded: true);
  }
}
