import 'package:carpool/constants.dart';
import 'package:carpool/controller/services/rides_service.dart';
import 'package:flutter/material.dart';
import 'package:carpool/models/ride.dart';

class DeleteRideScreen extends StatefulWidget {
  final Ride ride;

  DeleteRideScreen({required this.ride});
  @override
  State<DeleteRideScreen> createState() => _DeleteRideScreenState();
}

class _DeleteRideScreenState extends State<DeleteRideScreen> {
  final RidesService _ridesService = RidesService();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Delete Ride',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: kSecondaryColor,
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _ridesService.deleteRide(widget.ride.id);
                    Navigator.pop(context);
                  } catch (e) {
                  }
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ));
  }
}
