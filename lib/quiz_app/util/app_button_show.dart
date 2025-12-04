import 'package:flutter/material.dart';

class AppButtonShow extends ValueNotifier<bool>{
  AppButtonShow._() : super(false);
  static final AppButtonShow instance = AppButtonShow._();
  
  bool get enableRestartButton => value;

  void set({required bool enableRestartButton}) {
    value = enableRestartButton;
  }
}