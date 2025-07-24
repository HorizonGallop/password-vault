import 'package:flutter/material.dart';

/// Extensions for responsive sizes
extension SizeExtension on num {
  double get w => this.w; // Width based on screen size
  double get h => this.h; // Height based on screen size
  double get r => this.r; // Radius
  double get sp => this.sp; // Font size
}

/// Extra spacing shortcuts
extension SpacingExtension on num {
  SizedBox get verticalSpace => SizedBox(height: h);
  SizedBox get horizontalSpace => SizedBox(width: w);
}
