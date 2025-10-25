import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_utils.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
    : super(const ThemeState(themeMode: ThemeMode.system, isDarkMode: false)) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeChanged>(_onThemeChanged);
  }

  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    final themeMode = await AppUtils.getThemeMode();
    emit(
      ThemeState(themeMode: themeMode, isDarkMode: themeMode == ThemeMode.dark),
    );
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await AppUtils.setThemeMode(event.themeMode);
    emit(
      ThemeState(
        themeMode: event.themeMode,
        isDarkMode: event.themeMode == ThemeMode.dark,
      ),
    );
  }
}
