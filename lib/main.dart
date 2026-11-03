import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/splash_page.dart';
import 'features/event/event_provider.dart';

void main() {
  runApp(
    // Provider diletakkan di root agar HomePage dan halaman turunan dapat mengakses data
    ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: MaterialApp(
        title: 'Jabar EventGo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashPage(),
      ),
    ),
  );
}
