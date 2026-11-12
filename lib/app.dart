import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'data/api/api_client.dart';
import 'data/repositories/booking_repository.dart';
import 'screens/home/home_screen.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';

class RayanGardenApp extends StatefulWidget {
  /// [state] can be injected (tests); otherwise a real API-backed state is made.
  const RayanGardenApp({super.key, this.state});

  final AppState? state;

  @override
  State<RayanGardenApp> createState() => _RayanGardenAppState();
}

class _RayanGardenAppState extends State<RayanGardenApp> {
  late final AppState _state;
  late final bool _ownsState;

  @override
  void initState() {
    super.initState();
    _ownsState = widget.state == null;
    _state = widget.state ??
        AppState(repository: ApiBookingRepository(ApiClient()));
  }

  @override
  void dispose() {
    if (_ownsState) _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScope(
        state: _state,
        child: Builder(builder: (context) {
          final state = AppScope.of(context);
          return MaterialApp(
            title: 'Rayan Garden',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: Locale(state.lang),
            supportedLocales: const [Locale('fa'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) => Directionality(
              textDirection: state.isFa ? TextDirection.rtl : TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            ),
            home: const HomeScreen(),
          );
        }),
      );
}
