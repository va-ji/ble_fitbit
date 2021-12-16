import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:user_onboarding/helpers/helpers.dart';

class PermissionsProvider with ChangeNotifier {
  PermissionStatus? _currentPermission;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  PermissionStatus? get currentPermission => _currentPermission;

  /// request permission from user for location use
  Future<void> _requestPermission() async {
    late Map<Permission, PermissionStatus> _currentPermissions;
    if (Platform.isAndroid) {
      AndroidDeviceInfo _androidDeviceInfo = await _deviceInfo.androidInfo;
      if (_androidDeviceInfo.version.sdkInt! >= 31) {
        _currentPermissions = await [
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.location
        ].request();
      } else {
        _currentPermissions = await [
          Permission.bluetooth,
          Permission.locationWhenInUse
        ].request();
      }
    } else {
      // iOS
      _currentPermissions =
          await [Permission.bluetooth, Permission.locationWhenInUse].request();
    }

    if (_currentPermissions[Permission.locationWhenInUse] != null) {
      if (_currentPermissions[Permission.locationWhenInUse] !=
          PermissionStatus.granted) {
        if (_currentPermissions[Permission.locationWhenInUse]!
            .isPermanentlyDenied) {
          openAppSettings();
        }
        _currentPermissions[Permission.locationWhenInUse] =
            await Permission.locationWhenInUse.request();
      }
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo _androidDeviceInfo = await _deviceInfo.androidInfo;
      if (_androidDeviceInfo.version.sdkInt! >= 31) {
        if (_currentPermissions[Permission.bluetoothConnect] !=
            PermissionStatus.granted) {
          if (_currentPermissions[Permission.bluetoothConnect]!
              .isPermanentlyDenied) {
            openAppSettings();
          }
          _currentPermissions[Permission.bluetoothScan] =
              await Permission.bluetoothConnect.request();
          if (_currentPermissions[Permission.bluetoothScan] !=
              PermissionStatus.granted) {
            if (_currentPermissions[Permission.bluetoothScan]!
                .isPermanentlyDenied) {
              openAppSettings();
            }
            _currentPermissions[Permission.bluetoothConnect] =
                await Permission.bluetoothConnect.request();
          }
        }
      } else {
        if (_currentPermissions[Permission.bluetooth] !=
            PermissionStatus.granted) {
          if (_currentPermissions[Permission.bluetooth]!.isPermanentlyDenied) {
            openAppSettings();
          }
          _currentPermissions[Permission.bluetooth] =
              await Permission.bluetooth.request();
        }
      }
    } else {
      if (_currentPermissions[Permission.bluetooth] !=
          PermissionStatus.granted) {
        if (_currentPermissions[Permission.bluetooth]!.isPermanentlyDenied) {
          openAppSettings();
        }
        _currentPermissions[Permission.bluetooth] =
            await Permission.bluetooth.request();
      }
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo _androidDeviceInfo = await _deviceInfo.androidInfo;
      if (_androidDeviceInfo.version.sdkInt! >= 31) {
        if (_currentPermissions[Permission.locationWhenInUse] ==
                PermissionStatus.granted &&
            _currentPermissions[Permission.bluetoothScan] ==
                PermissionStatus.granted &&
            _currentPermissions[Permission.bluetoothConnect] ==
                PermissionStatus.granted) {
          _currentPermission = PermissionStatus.granted;
        } else {
          _currentPermission = PermissionStatus.denied;
        }
      } else {
        if (_currentPermissions[Permission.locationWhenInUse] ==
                PermissionStatus.granted &&
            _currentPermissions[Permission.bluetooth] ==
                PermissionStatus.granted) {
          _currentPermission = PermissionStatus.granted;
        } else {
          _currentPermission = PermissionStatus.denied;
        }
      }
    } else {
      if (_currentPermissions[Permission.locationWhenInUse] ==
              PermissionStatus.granted &&
          _currentPermissions[Permission.bluetooth] ==
              PermissionStatus.granted) {
        _currentPermission = PermissionStatus.granted;
      } else {
        _currentPermission = PermissionStatus.denied;
      }
    }
    notifyListeners();
  }

  /// update current location permission
  Future<void> askPermissionStatus() async {
    try {
      PermissionStatus _locationPermission =
          await Permission.locationWhenInUse.status;

      PermissionStatus _bluetoothPermission = await Permission.bluetooth.status;

      if (_locationPermission != PermissionStatus.granted ||
          _bluetoothPermission != PermissionStatus.granted) {
        _requestPermission();
      } else {
        _currentPermission = PermissionStatus.granted;
        notifyListeners();
      }
    } catch (e) {
      _currentPermission = PermissionStatus.denied;
      logger.e(e.toString());
      notifyListeners();
    }
  }

  void refresh() {
    notifyListeners();
  }

  /// update curretn permission status with provided [permission]
  set updateCurrentPermission(PermissionStatus permission) {
    _currentPermission = permission;
    notifyListeners();
  }
}
