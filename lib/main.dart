import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // Specify the path if not in root

  runApp(ProviderScope(child: const MyApp()));
}
