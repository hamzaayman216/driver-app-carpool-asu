import 'package:carpool/constants.dart';
import 'package:carpool/controller/services/rides_service.dart';
import 'package:carpool/controller/services/user_service.dart';
import 'package:carpool/models/ride.dart';
import 'package:carpool/models/user.dart';
import 'package:carpool/components/driver_rides_list.dart';
import 'package:carpool/screens/add_ride_screen.dart';
import 'package:carpool/screens/driver_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

late User loggedInUser;

class DriverScreen extends StatefulWidget {
  static const String id = 'driver_screen';

  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  UserService userService = UserService();
  CarPoolUser querySnapshot = CarPoolUser(name: '', email: '', phoneNumber: '', imageUrl: '', balance: 0);
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          title: Text('My Rides', style: TextStyle(color: Colors.black)),
          elevation: 20,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: kSecondaryColor),
        ),
        drawer: querySnapshot == null ? null : DriverProfileScreen(user: querySnapshot),
        body: SafeArea(
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance.ref('rides').onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                return Center(child: Text('No rides available', style: TextStyle(color: Colors.red, fontSize: 20)));
              } else {
                List<Ride> rides = RidesService().getDriverRides(snapshot.data!, loggedInUser.uid);
                return DriverRideList(ridesStream: Stream.fromIterable([rides]));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AddRideScreen(),
                ),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
