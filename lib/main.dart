import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/splash_page.dart';
import 'features/event/event_provider.dart';
import 'features/ticket/ticket_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EventProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Jabar EventGo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashPage(),
      ),
    ),
  );
}