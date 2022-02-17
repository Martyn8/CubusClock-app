import 'package:cubus_clock/model/tab_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../model/activity_read.dart';

class MeasurementsPage extends StatefulWidget {
  const MeasurementsPage({Key? key}) : super(key: key);

  @override
  _MeasurementsPageState createState() => _MeasurementsPageState();
}

class _MeasurementsPageState extends State<MeasurementsPage> {
  final _database = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<TabChoice> tabsActivities = List.empty(growable: true);
  List<ActivityRead> singleObjectReadingList = List.empty();
  List<Widget> childrenList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    final userUID = _auth.currentUser!.uid;
    return StreamBuilder(
        stream: _database
            .child("Users")
            .child("$userUID")
            .child('Activities')
            .orderByKey()
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //check if there are activity measurements
            if ((snapshot.data! as Event).snapshot.value == null) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Activity Measurements",
                      style: TextStyle(
                          color: textColor, fontSize: 25, letterSpacing: 1),
                    ),
                    backgroundColor: darkBackgroundColor,
                  ),
                  body: Container(
                    color: lightBackgroundColor,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.alarm_off_sharp,
                          size: 80,
                          color: textColor,
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          'There are no measurements yet.',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          'Start tracking time of your activities!',
                          style: TextStyle(color: primaryColor, fontSize: 20),
                        ),
                      ],
                    )),
                  ));
            } else {
              final dbTabs = Map<dynamic, dynamic>.from(
                  (snapshot.data! as Event).snapshot.value);
              dbTabs.forEach((key, value) {
                final List<ActivityRead> readingsList =
                    List.empty(growable: true);
                for (var reading in value.values) {
                  readingsList.add(ActivityRead(
                      timestamp: reading["timestamp"],
                      duration: reading["duration"]));
                }
                tabsActivities
                    .add(TabChoice(title: key, activitiesList: readingsList));
              });

              tabsActivities.forEach(
                (element) {
                  childrenList.add(
                    ListView.builder(
                      itemCount: element.activitiesList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0.1,
                          color: lightBackgroundColor,
                          child: ListTile(
                              title: Text(
                                "Timestamp: ${element.activitiesList[index].timestamp}",
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "Duration: ${element.activitiesList[index].duration}",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18, /*fontWeight: FontWeight.w500*/
                                ),
                              )),
                        );
                      },
                    ),
                  );
                },
              );

              return DefaultTabController(
                length: tabsActivities.length,
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "Activity Measurements",
                        style: TextStyle(
                            color: textColor, fontSize: 25, letterSpacing: 1),
                      ),
                      backgroundColor: darkBackgroundColor,
                      bottom: TabBar(
                        isScrollable: true,
                        indicatorColor: primaryColor,
                        onTap: (tabIndex) {
                          singleObjectReadingList =
                              tabsActivities[tabIndex].activitiesList;
                        },
                        tabs: tabsActivities.map<Widget>((TabChoice tabChoice) {
                          return Tab(
                            child: Text(tabChoice.title),
                          );
                        }).toList(),
                      ),
                    ),
                    body: Container(
                      color: lightBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: TabBarView(
                          children: childrenList,
                        ),
                      ),
                    )),
              );
            }
          } else if (snapshot.hasError) {
            return Text('Error ${snapshot.error.toString()}');
          } else {
            return Text("");
          }
        });
  }
}
