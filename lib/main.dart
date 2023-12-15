import 'package:carpool/screens/driver_login_screen.dart';
import 'package:carpool/screens/driver_registration_screen.dart';
import 'package:carpool/screens/driver_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(CarPool());
}


class CarPool extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: DriverLoginScreen.id,
      routes:{
        DriverScreen.id:(context)=>DriverScreen(),
        DriverLoginScreen.id:(context)=>DriverLoginScreen(),
        DriverRegistrationScreen.id:(context)=>DriverRegistrationScreen(),
      } ,
    );
  }
}