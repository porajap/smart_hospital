import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConvertDateTimeFormat{
  static String convertDateFormat({required DateTime date}) => DateFormat('dd-MM-yyy').format(date);
  static String convertTimeFormat({required TimeOfDay time}) => '${time.hour}:${time.minute}';
}