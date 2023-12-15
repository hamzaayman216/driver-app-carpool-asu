import 'package:carpool/components/driver_history_list.dart';
import 'package:carpool/constants.dart';
import 'package:carpool/controller/services/rides_service.dart';
import 'package:carpool/controller/services/user_service.dart';
import 'package:carpool/models/ride.dart';
import 'package:carpool/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

late User loggedInUser;

class DriverHistoryScreen extends StatefulWidget {
  static const String id = 'driver_screen';

  @override
  _DriverHistoryScreenState createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  UserService userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CarPoolUser querySnapshot = CarPoolUser(name: '', email: '', phoneNumber: '', imageUrl: '',balance: 0);

  @override
  void initState() {
    super.initState();
    loggedInUser = _auth.currentUser!;
    initUser();
  }

  void initUser() async {
    CarPoolUser? user = await userService.getCurrentUser();
    if (user != null) {
      setState(() {
        querySnapshot = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: Text('My History', style: TextStyle(color: Colors.black)),
        elevation: 20,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kSecondaryColor),
      ),
      body: SafeArea(
        child: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref('rides').onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
              return Center(child: Text('No rides available', style: TextStyle(color: Colors.red, fontSize: 20)));
            } else {
              List<Ride> rides = RidesService().getDriverHistoryRides(snapshot.data!, loggedInUser.uid);
              return DriverHistoryList(ridesStream: Stream.fromIterable([rides]));
            }
          },
        ),
      ),

    );
  }
}
