import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../providers/providers.dart';
import '../screens.dart';

class PermissionScreen extends StatefulWidget {
  static const String route = '/testMode/test';
  final patientIdFormKey = GlobalKey<FormState>();

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  List<Widget> adaptiveStatement() {
    if (Platform.isIOS) {
      return [
        const Icon(
          Icons.bluetooth_searching,
          size: 150,
        ),
        const Text(
          "Bluetooth permission need to be granted for this app to provide its basic funtionalities. Please enable the permissions before you proceed.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ];
    }
    return [
      const Icon(
        Icons.location_pin,
        size: 150,
      ),
      const Text(
        "Location permission need to be granted for this app to provide its basic funtionalities. Please enable the permissions before you proceed.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: const Text(
          'BioKin App Permission',
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: adaptiveStatement(),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              height: 80,
              child: Consumer<PermissionsProvider>(
                builder: (_, permissionData, __) {
                  if (permissionData.currentPermission ==
                      PermissionStatus.granted) {
                    //Navigator.pushNamed(context, '/home');
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const BleScan()));
                  }
                  return ElevatedButton(
                      child: const Text(
                        "Allow Permission",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: permissionData.currentPermission ==
                              PermissionStatus.granted
                          ? () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  BleScan())) //Navigator.pushNamed(context, '/home')
                          : () async {
                              await permissionData.askPermissionStatus();
                            });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
