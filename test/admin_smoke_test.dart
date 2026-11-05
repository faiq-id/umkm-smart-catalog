import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:umkm_demo/bloc/store_bloc.dart';
import 'package:umkm_demo/pages/admin_login_page.dart';
import 'package:umkm_demo/pages/admin_page.dart';
import 'package:umkm_demo/services/auth_service.dart';

void main() {
  testWidgets(
    'AdminPage renders AdminLoginPage safely without Firebase initialized',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final authService = AuthService(
        initError: 'Simulasi mode offline tanpa inisialisasi Firebase.',
      );

      await tester.pumpWidget(
        BlocProvider(
          create: (_) => StoreBloc(
            enableCloudSync: false,
            authService: authService,
          ),
          child: const MaterialApp(
            home: AdminPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ErrorWidget), findsNothing);
      expect(find.byType(AdminLoginPage), findsOneWidget);
      expect(find.text('Masuk ke Panel Admin'), findsOneWidget);
      expect(find.text('Lihat Simulasi Panel Admin (Tamu)'), findsOneWidget);
    },
  );
}
