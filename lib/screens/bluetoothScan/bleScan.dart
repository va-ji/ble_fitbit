import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:user_onboarding/helpers/helpers.dart';
import 'package:user_onboarding/providers/providers.dart';

import '../../providers/providers.dart';

class BleScan extends StatefulWidget {
  const BleScan({Key? key}) : super(key: key);

  @override
  _BleScanState createState() => _BleScanState();
}

class _BleScanState extends State<BleScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bluetooth scan',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Consumer<BleScanProvider>(builder: (context, bleInstance, _) {
            return IconButton(
                color: Colors.black,
                onPressed: bleInstance.isScanning
                    ? null
                    : () {
                        logger.v('Starting to scan for devcies');
                        bleInstance.startScanForDevices();
                      },
                icon: const Icon(Icons.replay_rounded));
          })
        ],
      ),
      body: const SizedBox(),
    );
  }
}
