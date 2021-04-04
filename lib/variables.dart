import 'package:flutter/material.dart';

final List<String> ports = List.generate(29, (index) => 'COM${index + 1}');
final Map<String, dynamic> slots = {};
