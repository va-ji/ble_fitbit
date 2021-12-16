import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_onboarding/helpers/helpers.dart';
//import 'package:user_onboarding/providers/providers.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class BleScanProvider with ChangeNotifier {
  final reactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> _discoveredDevices = [];
  StreamSubscription<DiscoveredDevice>? _scanStream;
  Stream<ConnectionStateUpdate>? _currentConnectionStream;
  StreamSubscription<ConnectionStateUpdate>? _connection;
  bool _isScanning = false;
  bool _isConnected = false;
  bool _gotPermission = false;

  void startScanForDevices() async {
    //TODO replace True with permission == PermissionStatus.granted is for IOS test
    _discoveredDevices = [];
    _isScanning = true;
    if (Platform.isAndroid) {
      var permission = await Permission.location.request();
      if (permission == PermissionStatus.granted) {
        _gotPermission = true;
      }
    } else if (Platform.isIOS) {
      _gotPermission = true;
    }
    //refreshScreen();
    if (_gotPermission) {
      _scanStream = reactiveBle.scanForDevices(
          withServices: [], scanMode: ScanMode.balanced).listen((device) {
        if (_discoveredDevices.every((element) => element.id != device.id)) {
          _discoveredDevices.add(device);
          // refreshScreen();
        }
      }, onError: (Object error) {
        logger.v("ERROR while scanning:$error \n");
        // refreshScreen();
      });
    }
  }

  bool get isScanning => _isScanning;
  List<DiscoveredDevice> get scannedDevices => _discoveredDevices;

  void stopScan() async {
    await _scanStream!.cancel();
    _isScanning = false;
    // refreshScreen();
  }

  void onConnectDevice(index) {
    _currentConnectionStream = reactiveBle.connectToAdvertisingDevice(
      id: _discoveredDevices[index].id,
      prescanDuration: const Duration(seconds: 2),
      withServices: [],
    );

    _connection = _currentConnectionStream!.listen((event) {
      var id = event.deviceId.toString();
      switch (event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            logger.v('Connecting to $id\n');
            break;
          }
        case DeviceConnectionState.connected:
          {
            _isConnected = true;
            logger.v('Connected to $id\n');

            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            _isConnected = false;
            //_logTexts = "${_logTexts}Disconnecting from $id\n";
            logger.v('Disconnecting from $id\n');
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            // _logTexts = "${_logTexts}Disconnected from $id\n";
            logger.v('Disconnected from $id\n');

            break;
          }
      }
      refreshScreen();
    });
  }

  void refreshScreen() {}
}
