import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curry_puff_master/core/constants/app_themes.dart';
import 'package:curry_puff_master/core/utils/route_generator.dart';
import 'package:curry_puff_master/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:curry_puff_master/core/injection_container.dart' as di;

class CurryPuffMasterApp extends StatelessWidget {
  const CurryPuffMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        // Add other BLoCs here
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Curry Puff Master',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
            builder: (context, child) {
              return Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                      child: child!,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}