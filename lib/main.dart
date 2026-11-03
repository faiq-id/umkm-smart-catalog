import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/store_bloc.dart';
import 'bloc/store_state.dart';
import 'pages/admin_page.dart';
import 'pages/profile_page.dart';
import 'pages/store_page.dart';

void main() {
  runApp(const UmkmDemoApp());
}

class UmkmDemoApp extends StatelessWidget {
  const UmkmDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreBloc(),
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          final pal = state.store.palette;
          final scheme = ColorScheme.fromSeed(
            seedColor: pal.secondary,
            primary: pal.primary,
            onPrimary: Colors.white,
            secondary: pal.secondary,
            surface: pal.surface,
            onSurface: pal.onSurface,
          );
          return MaterialApp(
            title: '${state.store.name} — Demo Sistem UMKM',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: scheme,
              scaffoldBackgroundColor: pal.surface,
              textTheme: GoogleFonts.plusJakartaSansTextTheme(),
              splashFactory: InkSparkle.splashFactory,
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: WidgetStatePropertyAll(pal.outline.withValues(alpha: 0.4)),
                radius: const Radius.circular(8),
                thickness: const WidgetStatePropertyAll(6),
              ),
              switchTheme: SwitchThemeData(
                thumbColor: WidgetStateProperty.resolveWith(
                    (s) => s.contains(WidgetState.selected) ? Colors.white : pal.outline),
                trackColor: WidgetStateProperty.resolveWith((s) =>
                    s.contains(WidgetState.selected) ? pal.secondary : pal.surfaceHigh),
                trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (_) => const StorePage(),
              '/admin': (_) => const AdminPage(),
              '/profile': (_) => const ProfilePage(),
            },
          );
        },
      ),
    );
  }
}
