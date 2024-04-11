import 'package:flutter/material.dart';
import 'package:naliv_shifts_naliv/api.dart';
import 'package:naliv_shifts_naliv/pages/homePage.dart';
import 'package:naliv_shifts_naliv/pages/loginPage.dart';

void main() {
  runApp(const NalivShiftsApp());
}

class NalivShiftsApp extends StatefulWidget {
  const NalivShiftsApp({super.key});

  @override
  State<NalivShiftsApp> createState() => _NalivShiftsAppState();
}

class _NalivShiftsAppState extends State<NalivShiftsApp> {
  String token = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          token = snapshot.data!;

          Widget homePage;

          if (token.isNotEmpty) {
            homePage = const HomePage();
          } else {
            homePage = const LoginPage();
          }

          return MaterialApp(
            title: 'Naliv Shifts Admin',
            theme: ThemeData(
              // colorScheme: ColorScheme.fromSeed(
              //     seedColor: Colors.indigo, brightness: Brightness.dark),
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Color(0xFF9EDEC6),
                onPrimary: Colors.black,
                secondary: Color(0xFF3EB489),
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.white,
                background: Colors.white,
                onBackground: Colors.black,
                surface: Colors.black12,
                onSurface: Colors.white,
              ),
              useMaterial3: true,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  backgroundColor: const Color(0xFF3EB489),
                  disabledBackgroundColor: const Color(0xFF9EDEC6),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: homePage,
          );
        }
      },
    );
  }
}
