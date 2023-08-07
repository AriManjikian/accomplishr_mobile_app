import 'package:accomplishr_mobile_app/firebase_options.dart';
import 'package:accomplishr_mobile_app/providers/user_provider.dart';
import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/screens/email_verification_screen.dart';
import 'package:accomplishr_mobile_app/screens/responsive_screen.dart';
import 'package:accomplishr_mobile_app/screens/welcome_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

FirebaseAuth _auth = FirebaseAuth.instance;

void checkDate() async {
  QuerySnapshot date = await FirebaseFirestore.instance
      .collection('Users')
      .doc(_auth.currentUser!.uid)
      .collection('Dates')
      .orderBy('dateAdded')
      .limitToLast(1)
      .get();
  if (date.docs.isNotEmpty) {
    if (date.docs[0]['dateAdded'] != DateTime.now().format('yMMMd')) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Dates')
          .doc(DateTime.now().format('yMMMd'))
          .set({"dateAdded": DateTime.now()});
      QuerySnapshot habits = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Habits')
          .get();
      for (var i = 0; i < habits.docs.length; i++) {
        final String habitId = habits.docs[i].get('habitId');
        FirebaseFirestore.instance
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection('Habits')
            .doc(habitId)
            .update({
          "count": 0,
          "isCompleted": false,
        });
      }
    }
  } else {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Dates')
        .doc(DateTime.now().format('yMMMd'))
        .set({"dateAdded": DateTime.now()});
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        //Title
        title: 'Accomplishr',
        //theme
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
        ),
        //Debug Banner Off
        debugShowCheckedModeBanner: false,
        //Home`
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  FirestoreMethods().checkDate();
                  return const ResponsiveScreen();
                }
                return const VerifyEmailPage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const WelcomeScreen();
          },
        ),
      ),
    );
  }
}
