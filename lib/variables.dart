import 'package:flutter/material.dart';

final List<String> ports = List.generate(29, (index) => 'COM${index + 1}');
final Map<String, dynamic> slots = {
  'SLOT 1': {
    'port': 'COM1',
    'active': true,
    'color': Colors.grey[300],
    'command': '',
  },
  'SLOT 2': {
    'port': 'COM2',
    'active': true,
    'color': Colors.grey[300],
    'command': '',
  },
  'SLOT 3': {
    'port': 'COM3',
    'active': true,
    'color': Colors.grey[300],
    'command': '',
  },
  'SLOT 4': {
    'port': 'COM4',
    'active': true,
    'color': Colors.grey[300],
    'command': '',
  },
};
