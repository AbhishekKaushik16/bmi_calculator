import 'package:flutter/material.dart';
import '../widget_utils.dart';
double appBarHeight(BuildContext context) {
    return screenAwareSize(68.0, context) + MediaQuery.of(context).padding.top;
  }