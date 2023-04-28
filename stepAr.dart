import 'dart:math';

import 'package:flutter/material.dart';
import 'package:siyaj/widget/DashBoardCardAr.dart';
import 'package:siyaj/widget/buttonNavAr.dart';
import 'package:siyaj/widget/containerButtonAr.dart';
import 'package:siyaj/widget/dailyAverageAr.dart';
import 'package:siyaj/widget/topTextButtonAr.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboardar extends StatefulWidget {
  const Dashboardar({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboardar> {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double miles = 0.0;
  double duration = 0.0;
  double calories = 0.0;
  double addValue = 0.025;
  int steps = 0;
  double previousDistacne = 0.0;
  double distance = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AccelerometerEvent>(
        stream: SensorsPlatform.instance.accelerometerEvents,
        builder: (context, snapShort) {
          if (snapShort.hasData) {
            x = snapShort.data.x;
            y = snapShort.data.y;
            z = snapShort.data.z;
            distance = getValue(x, y, z);
            if (distance > 3) {
              steps++;
            }
            calories = calculateCalories(steps);
            duration = calculateDuration(steps);
            miles = calculateMiles(steps);
          }
          return Stack(
            children: [
              /*Container(
                height: 400,
                width: 30,
                decoration: const BoxDecoration(
                    /*gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff0C1E4E),
                          Color(0xff224A88),
                        ])*/),
              ),*/
              // ignore: sized_box_for_whitespace
              Container(
                height: 700,
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(
                        height: 150,
                      ),

                      // dashboard card
                      DashboardCardar(steps, miles, calories, duration),
                      //const DailyAverage(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      //bottomNavigationBar: const ButtonNav(),
    );
  }

  double getValue(double x, double y, double z) {
    double magnitude = sqrt(x * x + y * y + z * z);
    getPreviousValue();
    double modDistance = magnitude - previousDistacne;
    setPreviousValue(magnitude);
    return modDistance;
  }

  void setPreviousValue(double distance) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setDouble("preValue", distance);
  }

  void getPreviousValue() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      previousDistacne = _pref.getDouble("preValue") ?? 0.0;
    });
  }

  // void calculate data
  double calculateMiles(int steps) {
    double milesValue = (steps / 1312.33595801);
    return milesValue;
  }

  double calculateDuration(int steps) {
    double durationValue = (steps * 3 / 1000);
    return durationValue;
  }

  double calculateCalories(int steps) {
    double caloriesValue = (steps * 0.0566);
    return caloriesValue;
  }
}