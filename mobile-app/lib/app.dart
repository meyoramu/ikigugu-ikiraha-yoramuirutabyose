// Core Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:flutter_bloc/flutter_bloc.dart';

// Application imports
import 'package:curry_puff_master/core/constants/app_themes.dart';
import 'package:curry_puff_master/core/injection_container.dart' as di;
import 'package:curry_puff_master/core/utils/route_generator.dart';
import 'package:curry_puff_master/features/auth/presentation/bloc/auth_bloc.dart';

/// The root widget of the Curry Puff Master application.
///
/// This widget initializes the application's theme, routing, and state management.
/// It sets up the BLoC providers and handles the overall app configuration.
class CurryPuffMasterApp extends StatelessWidget {
  /// Creates a [CurryPuffMasterApp] widget.
  ///
  /// This is the entry point of the application that sets up the Material app
  /// with proper theming, routing, and state management configuration.
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