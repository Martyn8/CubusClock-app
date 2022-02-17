import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SendData {
  final database = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> walls = ["Wall 1", "Wall 2", "Wall 3", "Wall 4", "Wall 5"];

  Future sendData(String dataString) async {
    late int wallNr;
    late String timestamp;
    late String duration;
    late int numOfRecords;
    final userUID = _auth.currentUser!.uid;
    final userAcrRef =
        database.child("Users").child("$userUID").child('Activities');
    late String activityName;

    numOfRecords = getNumberOfRecords(dataString);

    for (int i = 0; i < numOfRecords; i++) {
      wallNr = int.parse(dataString[1 + i * 27]);
      String date = dataString.substring(2 + i * 27, 12 + i * 27);
      String time = dataString.substring(12 + i * 27, 20 + i * 27);
      duration = dataString.substring(20 + i * 27, 28 + i * 27);
      timestamp = date + " " + time;
      try {
        String result = await getActivityName(wallNr);
        activityName = result;
      } catch (e) {
        print(e.toString());
        return null;
      } finally {
        DatabaseReference actRef = userAcrRef.child(activityName);
        Map<String, dynamic> actData = {
          'duration': duration,
          'timestamp': timestamp,
        };
        String reading = DateTime.now().microsecondsSinceEpoch.toString();
        await actRef.child("$reading").set(actData);
      }
    }
    return true;
  }

  Future<String> getActivityName(
    int wallNr,
  ) async {
    final userUID = _auth.currentUser!.uid;
    final userWallRef = await database
        .child("Users")
        .child("$userUID")
        .child('Walls')
        .child("${walls[wallNr - 1]}")
        .once();
    final actName = userWallRef.value;

    return actName;
  }

  int getNumberOfRecords(String data) {
    int number = int.parse(data[0]);
    return number;
  }
}
