import 'package:flutter/material.dart';

class DrawerModel {
  final IconData? icon;
  final Color? iconColor;
  final String? iconPath;
  final String title;
  final List<DrawerModel> submenus;
  final VoidCallback? onPressed;

  DrawerModel({
    this.icon,
    required this.title,
    this.submenus = const [],
    this.iconColor,
    this.iconPath,
    this.onPressed,
  });
}
