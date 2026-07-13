import 'package:flutter/material.dart';

abstract final class AppRadius {
  AppRadius._();

  static const double r8 = 8;
  static const double r12 = 12;
  static const double r16 = 16;

  static const BorderRadius radius8 =
      BorderRadius.all(Radius.circular(8));

  static const BorderRadius radius12 =
      BorderRadius.all(Radius.circular(12));

  static const BorderRadius radius16 =
      BorderRadius.all(Radius.circular(16));
}