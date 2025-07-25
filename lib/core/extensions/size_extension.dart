import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extensions for responsive sizes
extension SizeExtension on num {
  double get w => ScreenUtil().setWidth(this);   // Width based on screen size
  double get h => ScreenUtil().setHeight(this);  // Height based on screen size
  double get r => ScreenUtil().radius(this);     // Radius
  double get sp => ScreenUtil().setSp(this);     // Font size
}

/// Extra spacing shortcuts
extension SpacingExtension on num {
  SizedBox get verticalSpace => SizedBox(height: ScreenUtil().setHeight(this));
  SizedBox get horizontalSpace => SizedBox(width: ScreenUtil().setWidth(this));
}
