import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'utils/app_colors.dart';
import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        home: const HomeView(),
        scrollBehavior: _DragDenganMouse(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
            surface: AppColors.surface,
          ),
          scaffoldBackgroundColor: AppColors.canvas,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.canvas,
            foregroundColor: AppColors.textPrimary,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 72,
            titleTextStyle: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          cardTheme: CardThemeData(
            color: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(color: AppColors.outline),
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primary,
            disabledColor: AppColors.surfaceSoft,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            secondaryLabelStyle: const TextStyle(color: Colors.white),
            side: const BorderSide(color: AppColors.outline),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.canvas,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: AppColors.primary,
            linearTrackColor: AppColors.surfaceSoft,
          ),
        ),
      );
}

class _DragDenganMouse extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, PointerDeviceKind.mouse};
}
