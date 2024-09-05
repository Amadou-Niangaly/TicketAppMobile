import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ticket_app/page/home/home.dart';
import 'package:ticket_app/page/login_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDPiG5qG-mBySYv3KhUWesDnGiU8mfwn9Q",
        authDomain: "gestion-ticket-a3d23.firebaseapp.com",
        projectId: "gestion-ticket-a3d23",
        storageBucket: "gestion-ticket-a3d23.appspot.com",
        messagingSenderId: "96898811232",
        appId: "1:96898811232:web:58a5603cc0c501635d0a05",
      ),
    );
  } catch (e) {
    // ignore: avoid_print
    print('Erreur lors de l\'initialisation: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Gestion des tickets",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF8FAFB) ,
        hintColor: const Color(0xFF5F67EA),
      ),

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,AsyncSnapshot<User?> snapshot){
          if(snapshot.hasData && snapshot.data !=null){
            return const HomePage();
          }
          else if(snapshot.connectionState ==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
            
          }
          return  LoginPage();
        },
      ),
    
    );
  }
}



