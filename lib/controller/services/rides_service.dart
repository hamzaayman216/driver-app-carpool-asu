import 'package:carpool/models/ride.dart';
import 'package:firebase_database/firebase_database.dart';

class RidesService {
  List<Ride> getDriverRides(DatabaseEvent snapshot, String driverId) {
    var ridesMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
    List<Ride> rides = [];
    ridesMap.forEach((key, value) {
      if (value is Map<dynamic, dynamic>) {
        var rideMap = Map<String, dynamic>.from(value);
        var ride = Ride.fromMap(rideMap);
        if (ride.driverId == driverId && ride.status != 'Finished') {
          rides.add(ride);
        }
      }
    });
    return rides;
  }

  List<Ride> getDriverHistoryRides(DatabaseEvent snapshot, String driverId) {
    var ridesMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
    List<Ride> rides = [];
    ridesMap.forEach((key, value) {
      if (value is Map<dynamic, dynamic>) {
        var rideMap = Map<String, dynamic>.from(value);
        var ride = Ride.fromMap(rideMap);
        if (ride.driverId == driverId && ride.status == 'Finished') {
          rides.add(ride);
        }
      }
    });
    return rides;
  }

  Future<void> deleteRide(String rideId) async {
    DatabaseReference ridesRef = FirebaseDatabase.instance.ref('rides');
    Query query = ridesRef.orderByChild('id').equalTo(rideId);
    DataSnapshot snapshot = await query.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      String? keyToDelete = data.keys.firstWhere(
            (k) => data[k]['id'] == rideId,
        orElse: () => null,
      );
      if (keyToDelete != null) {
        await ridesRef.child(keyToDelete).remove();
      }
    }
  }

  Future<void> addRide(Ride ride) async {
    DatabaseReference ridesRef = FirebaseDatabase.instance.ref('rides');
    await ridesRef.child(ride.id).set(ride.toMap());
  }
}
