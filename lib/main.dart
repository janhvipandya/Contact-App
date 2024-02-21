import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/Controllers/crud_services.dart';
import 'package:first_app/Views/add_contact_page.dart';
import 'package:first_app/Views/favourite_page.dart';
import 'package:first_app/Views/home.dart';
import 'package:first_app/Views/login_page.dart';
import 'package:first_app/Views/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/auth_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      theme: ThemeData(
        textTheme: GoogleFonts.soraTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade800),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => CheckUser(),
        "/home": (context) => Homepage(),
        "/signup": (context) => SignupPage(),
        "/login": (context) => LoginPage(),
        "/add": (context) => AddContact(),
        "/favourites": (context) => FavoritesPage(
            favoriteContactsStream: CRUDService().getFavouriteContacts()),
      },
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
