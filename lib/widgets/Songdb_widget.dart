

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Future newfun()async {
 await Hive.openBox('newbox');
}