import 'package:flutter/material.dart';
import 'home.dart';
import 'tugas.dart';
import 'catatan.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Organizer',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return Home(nim: args['nim'], email: args['email']);
        },
        '/tugas': (context) => Tugas(),
        '/catatan': (context) => Catatan(),
        '/login': (context) => LoginPage(),
        '/profile': (context) =>
            ProfilePage(nim: '123456', email: 'email@example.com'),
      },
    );
  }
}
