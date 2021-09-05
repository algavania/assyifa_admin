import 'package:assyifa_admin/services/auth.dart';
import 'package:assyifa_admin/services/routes.dart';
import 'package:assyifa_admin/views/navigations/call_center/call_center.dart';
import 'package:assyifa_admin/views/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

void main() async {
  final String name = 'chatbot';
  final FirebaseOptions options = const FirebaseOptions(
    googleAppID: '1:798471618272:android:20c90f0936a16ce9915a85',
    gcmSenderID: '798471618272',
    apiKey: 'AIzaSyDFrnmkEmjvZkcLn8JLRC_rTbDg8n-LmdY',
  );

  Future<void> _configure() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: name,
      options: options,
    );
    assert(app != null);
    print('Configured $app');
  }

  WidgetsFlutterBinding.ensureInitialized();
  await _configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const MaterialColor primarySwatch = const MaterialColor(
      0xFF39A2DB,
      const <int, Color>{
        50: const Color(0xFF39A2DB),
        100: const Color(0xFF39A2DB),
        200: const Color(0xFF39A2DB),
        300: const Color(0xFF39A2DB),
        400: const Color(0xFF39A2DB),
        500: const Color(0xFF39A2DB),
        600: const Color(0xFF39A2DB),
        700: const Color(0xFF39A2DB),
        800: const Color(0xFF39A2DB),
        900: const Color(0xFF39A2DB),
      },
    );

    return StreamProvider<UserModel>.value(
      catchError: (_, __) => null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'As-Syifa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xFF39A2DB),
            primarySwatch: primarySwatch,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: AppBarTheme(
                textTheme: TextTheme(
                    headline6: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                    )
                )
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color(0xFF39A2DB),
              ),
            ),
            textSelectionTheme:
            TextSelectionThemeData(selectionColor: Color(0xFFD0F3FC))),
        home: Wrapper(),
        routes: {
          Routes.callCenter: (context) => CallCenter(),
        },
    ),
    );
  }
}
